package TestService::Action;

use v5.34;
use autodie;
use open IO => ':locale';
use warnings;
use warnings FATAL => qw(utf8);
use Mojo::Base -base, -signatures;
use namespace::autoclean;

use List::Util 1.60 qw(zip);

use JSON::PP   ();
use Log::Any   ();
use Mojo::File ();
use Mojo::Util qw(encode dumper sha1_sum);
use YAML::XS ();

use experimental qw(declared_refs refaliasing try);

has log  => sub {Log::Any->get_logger(category => __PACKAGE__)};
has json => sub {JSON::PP->new->utf8->pretty->canonical->convert_blessed->allow_blessed};

sub execute ($self, $names_ref, $tests_ref) {
    my \@names   = $names_ref;
    my \@tests   = $tests_ref;
    my \@results = $self->fetch_data(\@tests);

    foreach (zip \@names, \@tests, \@results) {
        my ($name, \%test, $result) = $_->@*;
        $self->process_result($name, \%test, $result);
    }

    return \@results;
}

sub process_result ($self, $test_name, $test, $result) {
    $self->log->tracef('processing result: %s', $test_name);

    if ($test->{'save_to'}) {
        my \@save_to = ref $test->{'save_to'} eq 'ARRAY' ? $test->{'save_to'} : [$test->{'save_to'}];
        foreach my $save_to (@save_to) {
            $save_to = $self->process_path($save_to, $test_name, $test);
            my $encoder = $self->get_encoder($save_to);
            my $writer  = $self->get_writer($save_to);

            $writer->($encoder->($result));
        }
    }

    if (exists $test->{'output'} && defined $test->{'output'}) {
        my $encoder_stdout = $self->get_encoder($test->{'output'});
        my $writer_stdout  = $self->get_writer(undef);
        $writer_stdout->($encoder_stdout->($result));
    }

    return;
}

sub get_encoder ($self, $hint) {
    for ($hint) {
        last if not defined;
        if (m/json\z/ix) {
            return sub ($data) {return JSON()->encode($data)};
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

sub get_writer ($self, $path) {
    if ($path) {
        return sub ($bytes) {
            my $p = Mojo::File->new($path)->to_abs;
            $p->dirname->make_path;
            $self->log->infof('write to file: %s', $p);
            return $p->spurt($bytes);
        }
    }
    return sub ($text) {say $text if $text};
}

sub process_path ($self, $path, $test_name, $test) {
    return $path =~ s{\$\$name}{$test_name}xgr;
}

1;

__END__
