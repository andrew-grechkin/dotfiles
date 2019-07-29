package AnyArchive::Create;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Carp       qw(croak);
use List::Util qw(first);

my @supported = (
    {'suffix' => qr{[.]tar[.]gz$  |  [.]tgz$ |   [.]taz$}x, 'options' => ['--gzip']},
    {'suffix' => qr{[.]tar[.]zst$ |  [.]tzst$}x,            'options' => ['--zstd']},
);

sub execute ($archive_path, $items_aref, $root = undef) {
    my $format = first {$archive_path =~ $_->{'suffix'}} @supported
        or croak "Unsupported archive format for: $archive_path";

    my @items
        = $root
        ? ('--directory', $root, map {$_->relative($root)->stringify} $items_aref->@*)
        : (map {$_->stringify} $items_aref->@*);

    system('tar', $format->{'options'}->@*, '-vcf', $archive_path, @items) == 0
        or croak "Unable to execute compress command: $!";

    return;
}

__END__
