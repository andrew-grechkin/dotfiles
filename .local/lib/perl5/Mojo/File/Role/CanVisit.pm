package Mojo::File::Role::CanVisit;

# ABSTRACT: Package Mojo::File::Role::CanVisit

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Mojo::Base qw(-role);

use File::Find            qw();
use File::Spec::Functions qw();

sub visit ($self, $cb, $options = {}) {
    my %stat;
    return \%stat unless -d $$self;

    local $File::Find::skip_pattern   = qr/^[.]/x unless $options->{'hidden'};
    local $File::Find::dont_use_nlink = 1 if $options->{'dont_use_nlink'};

    my $max_depth = $options->{'max_depth'};
    my $wanted    = sub {
        if ($max_depth) {
            my $rel = $File::Find::name =~ s{^\Q$$self\E/?}{}r;
            $File::Find::prune = 1 if File::Spec::Functions::splitdir($rel) >= $max_depth;
        }

        $cb->($File::Find::name, \%stat);
    };

    File::Find::find({'wanted' => $wanted, 'no_chdir' => 1}, $$self);

    return \%stat;
}

__END__
