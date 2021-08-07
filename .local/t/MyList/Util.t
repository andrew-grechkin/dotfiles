#!/usr/bin/env perl

use v5.34;
use warnings;

use Test2::V0;
use Test2::Tools::Spec;
use experimental qw(declared_refs refaliasing signatures try);

use MyList::Util qw(
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

tests 'MyList::Util::adjacent_pairs' => sub {
    is(adjacent_pairs([]),                 [],                                    'empty array');
    is(adjacent_pairs([42]),               [],                                    'only one element');
    is(adjacent_pairs([42, 10]),           [[42, 10]],                            'two elements');
    is(adjacent_pairs([42, 10, 20, 7]),    [[42, 10], [10, 20], [20, 7]],         'even amount of elements');
    is(adjacent_pairs([42, 10, 20, 7, 5]), [[42, 10], [10, 20], [20, 7], [7, 5]], 'odd amount of elements');
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

done_testing();
