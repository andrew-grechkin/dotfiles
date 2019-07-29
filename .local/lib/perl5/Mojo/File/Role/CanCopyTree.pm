package Mojo::File::Role::CanCopyTree;

# ABSTRACT: Package Mojo::File::Role::CanCopyTree

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Mojo::Base qw(-role);

sub copy_tree_to() {
    return;
}

__END__
