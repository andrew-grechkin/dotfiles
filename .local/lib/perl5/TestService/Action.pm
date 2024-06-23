package TestService::Action;

use v5.40;
use autodie;
use open 'IO' => ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use Mojo::Base   qw(-base -signatures);
use experimental qw(class declared_refs defer refaliasing);

use JSON::PP qw();
use List::Util 1.60 qw(zip);

use Log::Any   qw();
use Mojo::File qw();
use Mojo::Util qw(encode dumper sha1_sum);
use YAML::XS   qw();
use namespace::autoclean;

has 'log'  => sub {Log::Any->get_logger('category' => __PACKAGE__)};
has 'json' => sub {JSON::PP->new->utf8->pretty->canonical->convert_blessed->allow_blessed};

sub execute ($self, $names_aref, $tests_aref) {
    my \@names   = $names_aref;
    my \@tests   = $tests_aref;
    my \@results = $self->fetch_data(\@tests);

    foreach (zip \@names, \@tests, \@results) {
        my ($name, \%test, $result) = $_->@*;
        $self->_process_result($name, \%test, $result);
    }

    return \@results;
}

sub _process_result ($self, $test_name, $test, $result) {
    $self->log->tracef('processing result: %s', $test_name);

    if ($test->{'save_to'}) {
        my \@save_to = ref $test->{'save_to'} eq 'ARRAY' ? $test->{'save_to'} : [$test->{'save_to'}];
        foreach my $save_to (@save_to) {
            $save_to = $self->_process_path($save_to, $test_name, $test);
            my $encoder = $self->_get_encoder($save_to);
            my $writer  = $self->_get_writer($save_to);

            $writer->($encoder->($result));
        }
    }

    if (exists $test->{'output'} && defined $test->{'output'}) {
        my $encoder_stdout = $self->_get_encoder($test->{'output'});
        my $writer_stdout  = $self->_get_writer(undef);
        $writer_stdout->($encoder_stdout->($result));
    }

    return;
}

sub _get_encoder ($self, $hint) {
    for ($hint) {
        last if not defined;
        if (m/json\z/ix) {
            return sub ($data) {return $self->json->encode($data)};
        } elsif (m/dump\z/ix) {
            return sub ($data) {return dumper $data};
        } elsif (m/sha1\z/ix) {
            return sub ($data) {return sha1_sum $data};
        } elsif (m/txt\z/ix) {
            return sub ($data) {return encode('UTF-8', $data)};
        }
    }
    return sub ($data) {local $YAML::XS::Boolean = 'JSON::PP'; return YAML::XS::Dump($data)}; ## no critic [Variables::ProhibitPackageVars]
}

sub _get_writer ($self, $path) {
    if ($path) {
        return sub ($bytes) {
            my $p = Mojo::File->new($path)->to_abs;
            $p->dirname->make_path;
            $self->log->infof('write to file: %s', $p);
            return $p->spurt($bytes);
        };
    }
    return sub ($text) {say $text if $text};
}

sub _process_path ($self, $path, $test_name, $test) {
    return $path =~ s{\$\$name}{$test_name}xgr;
}

__END__
