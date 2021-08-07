package MyList::Util;

use v5.34;
use utf8;
use warnings;
use warnings FATAL => qw(utf8);
use experimental qw(declared_refs refaliasing signatures try);

use Exporter qw(import);
our @EXPORT_OK = qw(
    adjacent_pairs
    difference difference_stable
    difference_by
    symmetric_difference
    symmetric_difference_by
    intersection
    intersection_by
    union
    union_by
);

## no critic (Subroutines::RequireArgUnpacking)

sub adjacent_pairs ($array) {
    my @result;
    while ($array->@* > 1) {
        push (@result, [shift $array->@*, $array->[0]]);
    }
    return \@result;
}

sub difference : prototype($$) {
    my %lhs;
    undef $lhs{$_} foreach $_[0]->@*;
    delete @lhs{$_[1]->@*};
    return [keys %lhs];
}

sub difference_stable : prototype($$) {
    my %rhs;
    undef $rhs{$_} foreach $_[1]->@*;
    return [grep {!exists $rhs{$_}} $_[0]->@*];
}

sub difference_by : prototype(&$$) {
    my $code = shift;
    my %rhs;
    undef $rhs{$code->()} foreach $_[1]->@*;
    return [grep {!exists $rhs{$code->()}} $_[0]->@*];
}

sub symmetric_difference : prototype($$) {
    my (%cntr);
    ++$cntr{$_} foreach $_[0]->@*, $_[1]->@*;

    return [grep {$cntr{$_} < 2} $_[0]->@*, $_[1]->@*];
}

sub symmetric_difference_by : prototype(&$$) {
    my $code = shift;
    my (%cntr);
    ++$cntr{$code->()} foreach $_[0]->@*, $_[1]->@*;

    return [grep {$cntr{$code->()} < 2} $_[0]->@*, $_[1]->@*];
}

sub intersection : prototype($$) {
    my %rhs;
    undef $rhs{$_} foreach $_[1]->@*;
    return [grep {exists $rhs{$_}} $_[0]->@*];
}

sub intersection_by : prototype(&$$) {
    my $code = shift;
    my %rhs;
    undef $rhs{$code->()} foreach $_[1]->@*;
    return [grep {exists $rhs{$code->()}} $_[0]->@*];
}

sub union : prototype($$) {
    my %lhs;
    undef $lhs{$_} foreach $_[0]->@*;
    return [$_[0]->@*, grep {!exists $lhs{$_}} $_[1]->@*];
}

sub union_by : prototype(&$$) {
    my $code = shift;
    my %lhs;
    undef $lhs{$code->()} foreach $_[0]->@*;
    return [$_[0]->@*, grep {!exists $lhs{$code->()}} $_[1]->@*];
}

1;

__END__
