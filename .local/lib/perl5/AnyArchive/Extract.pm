package AnyArchive::Extract;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Carp       qw(croak);
use List::Util qw(first);

my @supported = (
    {'suffix' => qr{[.]tar$}x,                                      'command' => _command_tar()},
    {'suffix' => qr{[.]tar.bz2$  | [.]tbz2$  | [.]tbz$ | [.]tz2$}x, 'command' => _command_tar('--bzip2')},
    {'suffix' => qr{[.]tar.gz$   | [.]tgz$   | [.]taz$}x,           'command' => _command_tar('--gzip')},
    {'suffix' => qr{[.]tar.lz$   | [.]tlzip$}x,                     'command' => _command_tar('--lzip')},
    {'suffix' => qr{[.]tar.lzma$ | [.]tlzma$ | [.]tlz$}x,           'command' => _command_tar('--lzma')},
    {'suffix' => qr{[.]tar.lzop$ | [.]tlzo$  | [.]tlzop$}x,         'command' => _command_tar('--lzop')},
    {'suffix' => qr{[.]tar.xz$   | [.]txz$}x,                       'command' => _command_tar('--xz')},
    {'suffix' => qr{[.]tar.zst$  | [.]tzst$}x,                      'command' => _command_tar('--zstd')},
    {'suffix' => qr{[.]tar.Z$    | [.]taZ$}x,                       'command' => _command_tar('-Z')},
    {'suffix' => qr{[.]Z$}x,                                        'command' => _command_uncompress()},
    {'suffix' => qr{[.]bz2$}x,                                      'command' => _command_bunzip2()},
    {'suffix' => qr{[.]deb$}x,                                      'command' => _command_ar()},
    {'suffix' => qr{[.]gz$}x,                                       'command' => _command_gunzip()},
    {'suffix' => qr{[.]zst$}x,                                      'command' => _command_zst()},
    {'suffix' => qr{[.]eml$}x,                                      'command' => _command_munpack()},
    {'suffix' => qr{[.]cp866[.]zip$}x,                              'command' => _command_unzip('-O', 'cp866')},
    {'suffix' => qr{[.]7z$       | [.]rar$   | [.]zip$}x,           'command' => _command_7zip()},
);

sub basename ($archive_path, $decompressor = undef) {
    return $archive_path->basename($decompressor // _decompressor($archive_path)->{'suffix'});
}

sub execute ($archive_path, $destination) {
    my $arc      = _decompressor($archive_path);
    my $basename = basename($archive_path);

    my @command
        = map {ref $_ eq 'CODE' ? $_->($archive_path, $basename, $arc, $destination) : $_} $arc->{'command'}->@*;
    say {*STDERR} join(' ', @command);

    system(@command) == 0
        or croak "Unable to execute extract command: $!";

    return;
}

sub _decompressor ($archive_path) {
    my $result = first {$archive_path =~ $_->{'suffix'}} @supported
        or croak "Unsupported archive format: $archive_path";
    return $result;
}

sub _get_filename     ($file, @)               {return $file->stringify}
sub _get_extract_path ($, $, $, $extract_path) {return $extract_path->stringify}

sub _command_ar         (@options) {return ['ar',         'x', \&_get_filename]}
sub _command_bunzip2    (@options) {return ['bunzip2',    \&_get_filename]}
sub _command_gunzip     (@options) {return ['gunzip',     \&_get_filename]}
sub _command_munpack    (@options) {return ['munpack',    '-f', \&_get_filename, '-C', '.']}
sub _command_uncompress (@options) {return ['uncompress', \&_get_filename]}
sub _command_unzip      (@options) {return ['unzip',      @options, '-d', \&_get_extract_path, \&_get_filename]}
sub _command_zst        (@options) {return ['zstd',       '-d', \&_get_filename]}

sub _command_tar (@options) {
    return ['tar', @options, '-xvf', \&_get_filename, '--force-local', '--directory', \&_get_extract_path];
}

sub _command_7zip (@options) {
    return ['7z', 'x', '-y', sub ($, $, $, $extract_path) {return "-o$extract_path"}, '--', \&_get_filename];
}

__END__

# use 7z and recode later
# local $ENV{'LANG'} = 'C';
# system ('7z', 'x', '-no-utf16', '-y', "-o$tmp", $file);
# system ("convmv -f cp866 -t utf-8 --notest -r $tmp 2>/dev/null");
# use unar with forced encoding
# system ('unar', '-e', '866', '-o', $tmp, $file);
