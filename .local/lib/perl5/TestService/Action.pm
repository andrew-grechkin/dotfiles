package TestService::Action;

use v5.34;
use autodie;
use open IO => ':locale';
use warnings;
use warnings FATAL => qw(utf8);
use Mojo::Base -base, -signatures;
use namespace::autoclean;

use List::Util qw(zip);

use Mojo::File ();

use Data::Dumper ();
use JSON::PP     ();
use YAML::XS     ();

use experimental qw(declared_refs refaliasing try);

use constant { ## no tidy
    'JSON' => JSON::PP->new->utf8(1)->pretty(1)->canonical(1),
};

sub execute ($self, $names_ref, $tests_ref) {
    my \@names   = $names_ref;
    my \@tests   = $tests_ref;
    my \@results = $self->fetch_data(\@tests);

    foreach (zip \@names, \@tests, \@results) {
        my ($name, \%test, $result) = $_->@*;
        process_result($name, \%test, $result);
    }

    return \@results;
}

sub process_result ($test_name, $test, $result) {
    if ($test->{'save_to'}) {
        my \@save_to = ref $test->{'save_to'} eq 'ARRAY' ? $test->{'save_to'} : [$test->{'save_to'}];
        foreach my $save_to (@save_to) {
            $save_to = process_path($save_to, $test_name, $test);
            my $encoder = get_encoder($save_to);
            my $writer  = get_writer($save_to);

            $writer->($encoder->($result));
        }
    }

    if (exists $test->{'output'} && defined $test->{'output'}) {
        my $encoder_stdout = get_encoder($test->{'output'});
        my $writer_stdout  = get_writer(undef);
        $writer_stdout->($encoder_stdout->($result));
    }

    return;
}

sub get_encoder ($hint) {
    for ($hint) {
        last if not defined;
        return sub ($data) {return JSON()->encode($data)}
            if m/json\z/ix;
        return sub ($data) {
            return Data::Dumper->new([$data])->Purity(1)->Indent(1)->Terse(1)->Trailingcomma(1)->Sortkeys(1)->Dump;
            }
            if m/dump\z/ix;
    }
    return sub ($data) {local $YAML::XS::Boolean = 'JSON::PP'; return YAML::XS::Dump($data)}; ## no critic [Variables::ProhibitPackageVars]
}

sub get_writer ($path) {
    return sub ($bytes) {return Mojo::File->new($path)->spurt($bytes)}
        if $path;
    return sub ($text) {say $text if $text};
}

sub process_path ($path, $test_name, $test) {
    return $path =~ s{\$\$name}{$test_name}xgr;
}

1;

__END__
