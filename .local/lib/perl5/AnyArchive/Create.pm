package AnyArchive::Create;

use v5.36;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(builtin declared_refs defer for_list refaliasing try);

use Carp       qw(croak);
use List::Util qw(first);

my @supported = (
    {'suffix' => qr{[.]tar[.]gz$  |  [.]tgz$ |   [.]taz$}x, 'options' => ['--gzip']},
    {'suffix' => qr{[.]tar[.]zst$ |  [.]tzst$}x,            'options' => ['--zstd']},
);

sub execute ($archive_path, $items_aref, $root = undef) {
    my @items
        = $root
        ? ('--directory', $root, map {$_->relative($root)->stringify} $items_aref->@*)
        : (map {$_->stringify} $items_aref->@*);

    system('tar', _get_options($archive_path), '-vcf', $archive_path, @items) == 0
        or croak "Unable to execute compress command: $!";

    return;
}

sub _get_options ($archive_path) {
    my $result = first {$archive_path =~ $_->{'suffix'}} @supported
        or croak "Unsupported archive format: $archive_path";
    return $result->{'options'}->@*;
}

1;

__END__
