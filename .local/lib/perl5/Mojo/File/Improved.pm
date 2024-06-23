package Mojo::File::Improved;

# ABSTRACT: Package Mojo::File::Improved

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Exporter qw(import);
our @EXPORT_OK = qw(
    path
    tempdir
);

use File::Temp qw();

use Mojo::File qw();

sub _improved_class() {
    state $result = Mojo::File->with_roles('+CanVisit', '+CanCopyTree');
    return $result;
}

sub path {
    return _improved_class()->new(@_);
}

sub tempdir {
    return path(File::Temp->newdir(@_));
}

__END__
