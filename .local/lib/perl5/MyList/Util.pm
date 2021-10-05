package MyList::Util;

use v5.34;
use utf8;
use warnings;
use warnings FATAL => qw(utf8);
use experimental qw(declared_refs refaliasing signatures try);

use List::Util qw(sum0);

use Exporter qw(import);
our @EXPORT_OK = qw(
    adjacent_pairs
    average
    compact
    filter_by
    group_by
    partition

    difference difference_stable
    difference_by
    symmetric_difference
    symmetric_difference_by
    intersection
    intersection_by
    union
    union_by

    combinations
);

## no critic (Subroutines::RequireArgUnpacking)

sub adjacent_pairs ($array) {
    my @result;
    while ($array->@* > 1) {
        push (@result, [shift $array->@*, $array->[0]]);
    }
    return \@result;
}

sub average ($array_ref) {
    $array_ref->@*
        or return 0;
    return sum0($array_ref->@*) / scalar $array_ref->@*;
}

sub compact ($array_ref) {
    my @result = grep defined, $array_ref->@*;
    return \@result;
}

sub filter_by ($filter, $array_ref) {
    my @result = grep $filter->($_), $array_ref->@*;
    return \@result;
}

sub group_by ($key_extractor, $array_ref) {
    my %result;
    foreach my $it ($array_ref->@*) {
        my $key = $key_extractor->($it) // 'undefined';
        push ($result{$key}->@*, $it);
    }

    return \%result;
}

sub partition ($partitioner, $array_ref) {
    my (@truthy, @falsy);
    foreach my $it ($array_ref->@*) {
        $partitioner->($it) ? push (@truthy, $it) : push (@falsy, $it);
    }
    return (\@truthy, \@falsy);
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

sub combinations ($array, $k, $state = [], $result = []) {
    if ($k == 0) {
        push ($result->@*, $state);
        return $result;
    }

    my $length = scalar $array->@*;
    for (my $i = 0; $i < $length; ++$i) {
        combinations([$array->@[($i + 1) .. $length - 1]], $k - 1, [$state->@*, $array->[$i]], $result);
    }

    return $result;
}

#sub combinations ($list, $k) { # Trusty combination function.
#    return map { [$_] } @$list if $k <= 1;
#
#    my @combinations;
#    for (my $i = 0; $i + $k <= @$list; ++$i) {
#        my $current = $list->[$i];
#        my $rest    = [@$list[($i + 1) .. $#$list]];
#        push @combinations, [$current, @$_] for combinations($rest, $k - 1);
#    }
#
#    return @combinations;
#}

1;

__END__
