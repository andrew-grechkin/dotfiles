#!/usr/bin/env perl

use v5.40;
use warnings qw(FATAL utf8);

use Test2::V0;
use Test2::Tools::Spec;

use experimental qw(class declared_refs defer refaliasing);

use List::Util qw(shuffle);

use MyList::Util qw(
    adjacent_pairs
    difference
    difference_by
    difference_stable
    filter_by
    group_by
    intersection
    intersection_by
    partition
    symmetric_difference
    symmetric_difference_by
    union
    union_by

    combinations
    permutations

    mean
    sorted_median
    sorted_percentile
    sorted_quantile
);

## no critic [ValuesAndExpressions::ProhibitMagicNumbers]

tests 'MyList::Util::adjacent_pairs' => sub {
    is(adjacent_pairs([]),                 [],                                    'empty array');
    is(adjacent_pairs([42]),               [],                                    'only one element');
    is(adjacent_pairs([42, 10]),           [[42, 10]],                            'two elements');
    is(adjacent_pairs([42, 10, 20, 7]),    [[42, 10], [10, 20], [20, 7]],         'even amount of elements');
    is(adjacent_pairs([42, 10, 20, 7, 5]), [[42, 10], [10, 20], [20, 7], [7, 5]], 'odd amount of elements');
};

tests 'MyList::Util::filter_by' => sub {
    my @array = ({'a' => 1}, {'a' => 2}, {'a' => 3});
    is(filter_by(sub {$_[0]->{'a'} =~ m/2/},  []),      [],           'empty array');
    is(filter_by(sub {$_[0]->{'a'} =~ m/4/},  \@array), [],           'nothing mathed');
    is(filter_by(sub {$_[0]->{'a'} =~ m/2/},  \@array), [{'a' => 2}], 'one mathed');
    is(filter_by(sub {$_[0]->{'a'} =~ m/\d/}, \@array), \@array,      'many mathed');
};

tests 'MyList::Util::group_by' => sub {
    my @array = ({'a' => 1}, {'a' => 1}, {'a' => 3});
    is(group_by(sub {$_[0]->{'a'}}, []),      {},                                                     'empty array');
    is(group_by(sub {$_[0]->{'a'}}, \@array), {'1' => [{'a' => 1}, {'a' => 1}], '3' => [{'a' => 3}]}, 'all grouped');
};

tests 'MyList::Util::partition' => sub {
    my @array = ({'a' => 1}, {'a' => 1}, {'a' => 3});
    is([partition(sub {$_[0]->{'a'} == 1}, [])], [[], []], 'empty array');
    is([partition(sub {$_[0]->{'a'} == 1}, \@array)], [[{'a' => 1}, {'a' => 1}], [{'a' => 3}]], 'all grouped');
};

tests 'MyList::Util::difference' => sub {
    is(difference([], []),                          [],            'empty both');
    is(difference([42], []),                        [42],          'empty right');
    is(difference([], [42]),                        [],            'empty left');
    is(difference([42], [42]),                      [],            'equal arrays');
    is([sort (difference([1 .. 5], [3 .. 9])->@*)], [sort 1 .. 2], 'intersection exists');
    is([sort (difference([1 .. 5], [6 .. 9])->@*)], [sort 1 .. 5], 'intersection doesnt exists');
};

tests 'MyList::Util::difference_stable' => sub {
    is(difference_stable([],       []),       [],       'empty both');
    is(difference_stable([42],     []),       [42],     'empty right');
    is(difference_stable([],       [42]),     [],       'empty left');
    is(difference_stable([42],     [42]),     [],       'equal arrays');
    is(difference_stable([1 .. 5], [3 .. 9]), [1 .. 2], 'intersection exists');
    is(difference_stable([1 .. 5], [6 .. 9]), [1 .. 5], 'intersection doesnt exists');
};

tests 'MyList::Util::difference_by' => sub {
    is((difference_by {$_} [], []), [], 'empty both');
    is((difference_by {$_} [42], []), [42], 'empty right');
    is((difference_by {$_} [], [42]), [], 'empty left');
    is((difference_by {$_} [42], [42]), [], 'equal arrays');
    is((difference_by {$_} [1 .. 5], [3 .. 9]), [1 .. 2], 'intersection exists');
    is((difference_by {$_} [1 .. 5], [6 .. 9]), [1 .. 5], 'intersection doesnt exists');
};

tests 'MyList::Util::symmetric_difference' => sub {
    is(symmetric_difference([], []),             [],               'empty both');
    is(symmetric_difference([42], []),           [42],             'empty right');
    is(symmetric_difference([], [42]),           [42],             'empty left');
    is(symmetric_difference([42], [42]),         [],               'equal arrays');
    is(symmetric_difference([1 .. 5], [3 .. 9]), [1 .. 2, 6 .. 9], 'intersection exists');
    is(symmetric_difference([1 .. 5], [6 .. 9]), [1 .. 5, 6 .. 9], 'intersection doesnt exists');
};

tests 'MyList::Util::symmetric_difference_by' => sub {
    is((symmetric_difference_by {$_} [], []),             [],               'empty both');
    is((symmetric_difference_by {$_} [42], []),           [42],             'empty right');
    is((symmetric_difference_by {$_} [], [42]),           [42],             'empty left');
    is((symmetric_difference_by {$_} [42], [42]),         [],               'equal arrays');
    is((symmetric_difference_by {$_} [1 .. 5], [3 .. 9]), [1 .. 2, 6 .. 9], 'intersection exists');
    is((symmetric_difference_by {$_} [1 .. 5], [6 .. 9]), [1 .. 5, 6 .. 9], 'intersection doesnt exists');
};

tests 'MyList::Util::intersection' => sub {
    is(intersection([],       []),       [],       'empty both');
    is(intersection([42],     []),       [],       'empty right');
    is(intersection([],       [42]),     [],       'empty left');
    is(intersection([42],     [42]),     [42],     'equal arrays');
    is(intersection([1 .. 5], [3 .. 9]), [3 .. 5], 'intersection exists');
    is(intersection([1 .. 5], [6 .. 9]), [],       'intersection doesnt exists');
};

tests 'MyList::Util::intersection_by' => sub {
    is((intersection_by {$_} [], []), [], 'empty both');
    is((intersection_by {$_} [42], []), [], 'empty right');
    is((intersection_by {$_} [], [42]), [], 'empty left');
    is((intersection_by {$_} [42], [42]), [42], 'equal arrays');
    is((intersection_by {$_} [1 .. 5], [3 .. 9]), [3 .. 5], 'intersection exists');
    is((intersection_by {$_} [1 .. 5], [6 .. 9]), [],       'intersection doesnt exists');
};

tests 'MyList::Util::union' => sub {
    is(union([],       []),       [],       'empty both');
    is(union([42],     []),       [42],     'empty right');
    is(union([],       [42]),     [42],     'empty left');
    is(union([42],     [42]),     [42],     'equal arrays');
    is(union([1 .. 5], [3 .. 9]), [1 .. 9], 'intersection exists');
    is(union([1 .. 5], [6 .. 9]), [1 .. 9], 'intersection doesnt exists');
};

tests 'MyList::Util::union_by' => sub {
    is((union_by {$_} [], []), [], 'empty both');
    is((union_by {$_} [42], []), [42], 'empty right');
    is((union_by {$_} [], [42]), [42], 'empty left');
    is((union_by {$_} [42], [42]), [42], 'equal arrays');
    is((union_by {$_} [1 .. 5], [3 .. 9]), [1 .. 9], 'intersection exists');
    is((union_by {$_} [1 .. 5], [6 .. 9]), [1 .. 9], 'intersection doesnt exists');
};

tests 'MyList::Util::combinations' => sub {
    is(combinations(['a', 'b', 'c', 'd'], 4), [['a', 'b', 'c', 'd']]);
    is(combinations(['a', 'b', 'c', 'd'], 3), [['a', 'b', 'c'], ['a', 'b', 'd'], ['a', 'c', 'd'], ['b', 'c', 'd']]);
    is(combinations(['a', 'b', 'c', 'd'], 2), [['a', 'b'], ['a', 'c'], ['a', 'd'], ['b', 'c'], ['b', 'd'], ['c', 'd']]);
    is(combinations(['a', 'b', 'c', 'd'], 1), [['a'], ['b'], ['c'], ['d']]);
};

tests 'MyList::Util::permutations' => sub {
    is(
        permutations(['a', 'b', 'c']),
        [['a', 'b', 'c'], ['a', 'c', 'b'], ['c', 'a', 'b'], ['c', 'b', 'a'], ['b', 'c', 'a'], ['b', 'a', 'c']],
    );
    is(
        permutations(['a', 'b', 'c', 'd']),
        [
            ['a', 'b', 'c', 'd'],
            ['a', 'b', 'd', 'c'],
            ['a', 'd', 'b', 'c'],
            ['d', 'a', 'b', 'c'],
            ['d', 'a', 'c', 'b'],
            ['a', 'd', 'c', 'b'],
            ['a', 'c', 'd', 'b'],
            ['a', 'c', 'b', 'd'],
            ['c', 'a', 'b', 'd'],
            ['c', 'a', 'd', 'b'],
            ['c', 'd', 'a', 'b'],
            ['d', 'c', 'a', 'b'],
            ['d', 'c', 'b', 'a'],
            ['c', 'd', 'b', 'a'],
            ['c', 'b', 'd', 'a'],
            ['c', 'b', 'a', 'd'],
            ['b', 'c', 'a', 'd'],
            ['b', 'c', 'd', 'a'],
            ['b', 'd', 'c', 'a'],
            ['d', 'b', 'c', 'a'],
            ['d', 'b', 'a', 'c'],
            ['b', 'd', 'a', 'c'],
            ['b', 'a', 'd', 'c'],
            ['b', 'a', 'c', 'd'],
        ],
    );
};

tests 'MyList::Util::mean' => sub {
    my @array = shuffle(1 .. 9);
    is(mean([]),      undef, 'empty array');
    is(mean([42]),    42,    'one element');
    is(mean(\@array), 5);
};

tests 'MyList::Util::sorted_median' => sub {
    my @array = sort {$a <=> $b} (1 .. 19);
    is(sorted_median([]),      undef, 'empty array');
    is(sorted_median([42]),    42,    'one element');
    is(sorted_median(\@array), 10);
};

tests 'MyList::Util::sorted_percentile' => sub {
    my @array = sort {$a <=> $b} (1 .. 10);
    is(sorted_percentile(50,  []),      undef, 'empty array');
    is(sorted_percentile(50,  [42]),    42,    'one element');
    is(sorted_percentile(20,  \@array), 2);
    is(sorted_percentile(35,  \@array), 3);
    is(sorted_percentile(50,  \@array), 5);
    is(sorted_percentile(65,  \@array), 7);
    is(sorted_percentile(70,  \@array), 7);
    is(sorted_percentile(80,  \@array), 8);
    is(sorted_percentile(100, \@array), 10);
};

done_testing();

__END__
