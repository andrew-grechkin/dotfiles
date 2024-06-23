package MyList::Util;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use List::Util qw(min sum0);
use Storable   qw(dclone);

use Exporter qw(import);
our @EXPORT_OK = qw(
    adjacent_pairs
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
    permutations

    mean
    sorted_median
    sorted_percentile
    sorted_quantile
);

## no critic [Subroutines::RequireArgUnpacking, Subroutines::ProhibitSubroutinePrototypes]

sub adjacent_pairs ($aref) {
    my \@array = $aref;
    my $pairs = @array - 1;

    my @result;
    for (my $i = 0; $i < $pairs; ++$i) {
        push(@result, [$array[$i], $array[$i + 1]]);
    }

    return \@result;
}

sub compact ($aref) {
    my @result = grep defined, $aref->@*;
    return \@result;
}

sub filter_by : prototype(&$) ($filter, $aref) {
    my @result = grep $filter->($_), $aref->@*;
    return \@result;
}

sub group_by : prototype(&$) ($key_extractor, $aref) {
    my \@array = $aref;
    my %result;
    foreach my $it (@array) {
        my $key = $key_extractor->($it) // 'undef';
        push($result{$key}->@*, $it);
    }
    return \%result;
}

sub partition : prototype(&$) ($partitioner, $aref) {
    my \@array = $aref;
    my (@truthy, @falsy);
    foreach my $it (@array) {
        $partitioner->($it) ? push(@truthy, $it) : push(@falsy, $it);
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

sub combinations ($array_ref, $k, $state = [], $result = []) {
    if ($k == 0) {
        push($result->@*, $state);
        return $result;
    }

    my $length = scalar $array_ref->@*;
    for (my $i = 0; $i < $length; ++$i) {
        combinations([$array_ref->@[($i + 1) .. $length - 1]], $k - 1, [$state->@*, $array_ref->[$i]], $result);
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

sub permutations ($array_ref) {
    my @result;
    my @d = (-1) x scalar $array_ref->@*;

    do {
        push(@result, dclone($array_ref));
    } while (sjt_next_permutation($array_ref, \@d));

    return \@result;
}

sub sjt_next_permutation ($array_ref, $dirs_ref) {
    my \@array = $array_ref;
    my $n      = @array;
    my $id     = -1;

    for (my $i = 0; $i < $n; ++$i) {
        $id = $i
            if (0 <= ($i + $dirs_ref->[$i]) && ($i + $dirs_ref->[$i]) < $n)
            and ($array[$i] gt $array[$i + $dirs_ref->[$i]])
            and (($id == -1) or ($array[$i] gt $array[$id]));
    }

    return 0 if $id == -1;                                                     # last permutation

    for (my $i = 0; $i < $n; ++$i) {
        $dirs_ref->[$i] = -$dirs_ref->[$i] if $array[$i] gt $array[$id];
    }

    #swap elements AND their directions
    ($array[$id], $array[$id + $dirs_ref->[$id]]) = ($array[$id + $dirs_ref->[$id]], $array[$id]);
    my $t = $dirs_ref->[$id];
    ($dirs_ref->[$id], $dirs_ref->[$id + $t]) = ($dirs_ref->[$id + $t], $dirs_ref->[$id]);
    return 1;
}

sub mean ($aref) {
    my \@values = $aref;
    return undef      if @values == 0;
    return $values[0] if @values == 1;

    return sum0(@values) / scalar @values;
}

sub sorted_median ($aref) {
    my \@values = $aref;
    my $size = @values;
    return undef      if @values == 0;
    return $values[0] if @values == 1;

    my @middle = @values[int(($size - 1) / 2) .. int($size / 2)];
    return mean(\@middle);
}

sub sorted_percentile ($p, $aref) {
    return sorted_quantile($p / 100, $aref);
}

sub sorted_quantile ($q, $aref) {
    my \@values = $aref;
    my $size = @values;
    return undef      if $q < 0 || 1 < $q || @values == 0;
    return $values[0] if @values == 1;

    my $index = min(int(($size + 1) * $q), $size) - 1;
    return $index >= 0 ? $values[$index] : undef;
}

__END__
