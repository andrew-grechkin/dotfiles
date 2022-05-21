package AnyArchive::Create;

use v5.34;
use autodie;
use open ':locale';
use utf8;
use warnings;
use warnings 'FATAL' => qw(utf8);
use experimental qw(declared_refs refaliasing signatures try);

use Carp;
use List::Util qw(first);

state @supported = (
    {'suffix' => qr{[.]tar.gz$ |   [.]tgz$ |   [.]taz$}x, 'options' => ['--gzip']},
    {'suffix' => qr{[.]tar.zst$ |  [.]tzst$}x,            'options' => ['--zstd']},
);

sub execute ($archive, $items, $root = undef) {
    my @items
        = $root
        ? ('--directory', $root, map {$_->relative($root)->stringify} $items->@*)
        : (map {$_->stringify} $items->@*);

    system ('tar', _get_options($archive), '-vcf', $archive, @items) == 0
        or croak "Unable to execute compress command: $!";

    return;
}

sub _get_options ($archive) {
    my $result = first {$archive =~ m{$_->{'suffix'}}} @supported
        or croak "Unsupported archive format: $archive";
    return $result->{'options'}->@*;
}

1;

__END__
