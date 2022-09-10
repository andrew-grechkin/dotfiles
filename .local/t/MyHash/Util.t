#!/usr/bin/env perl

use v5.36;
use warnings;

use Test2::V0;
use Test2::Tools::Spec;
use experimental qw(builtin declared_refs defer for_list refaliasing try); 

use MyHash::Util qw(
    build_data_cache
    build_reverse_indices
    compact
    clean_hash_from_key
);

my %valid_data = (
    'key1' => {'a' => '1a', 'b' => '1b', 'c' => '1c'},
    'key2' => {'a' => '2a', 'b' => '2b', 'c' => '2c'},
    'key3' => {'a' => '3a', 'b' => '3b', 'c' => '3c'},
);

describe 'MyHash::Util' => sub {
    my $package = 'MyHash::Util';

    tests 'build_data_cache' => sub {
        my @tests = ({
                description => 'empty data',
                input       => [
                    {},
                    'a' => sub {return $_[0]->{'a'}},
                    'b' => sub {return $_[0]->{'b'}},
                ],
                expected => [{}],
            },
            {
                description => 'valid data',
                input       => [
                    \%valid_data,
                    'a' => sub {return $_[0]->{'a'}},
                    'b' => sub {return $_[0]->{'b'}},
                ],
                expected => [{
                        'a' => {'key1' => '1a', 'key2' => '2a', 'key3' => '3a'},
                        'b' => {'key1' => '1b', 'key2' => '2b', 'key3' => '3b'},
                    },
                ],
            },
        );
        run_tests($package, 'build_data_cache', \@tests);
    };

    tests 'build_reverse_indices' => sub {
        my @tests = ({
                description => 'empty data',
                input       => [
                    {},
                    'a' => sub {return $_[0]->{'a'}},
                    'b' => sub {return $_[0]->{'b'}},
                ],
                expected => [{}],
            },
            {
                description => 'valid data',
                input       => [
                    \%valid_data,
                    'by_a' => sub {return $_[0]->{'a'}},
                    'by_b' => sub {return $_[0]->{'b'}},
                ],
                expected => [{
                        'by_a' => {'1a' => {'key1' => undef}, '2a' => {'key2' => undef}, '3a' => {'key3' => undef}},
                        'by_b' => {'1b' => {'key1' => undef}, '2b' => {'key2' => undef}, '3b' => {'key3' => undef}},
                    },
                ],
            },
        );
        run_tests($package, 'build_reverse_indices', \@tests);
    };

    tests 'compact' => sub {
        my @tests = ({
                description => 'undefined',
                input       => [undef],
                expected    => [undef],
            },
            {
                description => 'array',
                input       => [[42, undef]],
                expected    => [[42, undef]],
            },
            {
                description => 'empty data',
                input       => [{}],
                expected    => [{}],
            },
            {
                description => 'empty data 2',
                input       => [{'x' => undef, 'y' => {'z' => undef}}],
                expected    => [{}],
            },
            {
                description => 'valid data',
                input       => [{
                        'x1' => undef,
                        'x2' => [],
                        'x3' => {},
                        'y2' => [undef],
                        'y3' => {'_' => undef},
                        %valid_data,
                    },
                ],
                expected => [{'x2' => [], 'y2' => [undef], %valid_data}],
            },
        );

        run_tests($package, 'compact', \@tests);
    };

    tests 'clean_hash_from_key' => sub {
        my @tests = ({
                description => 'undefined',
                input       => [undef, 'x'],
                expected    => [undef],
            },
            {
                description => 'array',
                input       => [[42, undef], 'x'],
                expected    => [[42, undef]],
            },
            {
                description => 'empty data',
                input       => [{}, 'x'],
                expected    => [{}],
            },
            {
                description => 'empty data 2',
                input       => [{'x' => undef, 'y' => {'z' => undef}}, 'z'],
                expected    => [{'x' => undef, 'y' => {}}],
            },
            {
                description => 'valid data',
                input       => [{
                        'x1' => undef,
                        'x2' => [],
                        'x3' => {},
                        'y2' => [undef],
                        'y3' => {'_'  => undef},
                        'z'  => {'x2' => 'x2'},
                    },
                    'x2',
                ],
                expected => [{'x1' => undef, 'x3' => {}, 'y2' => [undef], 'y3' => {'_' => undef}, 'z' => {}}],
            },
        );

        run_tests($package, 'clean_hash_from_key', \@tests);
    };

    tests 'merge' => sub {
        my @tests = ({
                description => 'undefined',
                input       => [undef, undef],
                expected    => [undef],
            },
            {
                description => 'scalar',
                input       => ['a', 42],
                expected    => [42],
            },
            {
                description => 'array',
                input       => [['a'], 42],
                expected    => [42],
            },
            {
                description => 'valid data',
                input       => [{'a' => 1,  'b' => 2}, {'a' => 11, 'c' => 3}],
                expected    => [{'a' => 11, 'b' => 2, 'c' => 3}],
            },
            {
                description => 'valid data recursive',
                input       =>
                    [{'a' => 1, 'b' => 2, 'd' => {'d1' => {'h' => 'h'}}}, {'a' => 11, 'c' => 3, 'd' => {'d2' => 2}}],
                expected => [{'a' => 11, 'b' => 2, 'c' => 3, 'd' => {'d1' => {'h' => 'h'}, 'd2' => 2}}],
            },
        );

        run_tests($package, 'merge', \@tests);
    };
};

sub run_tests ($package, $sub, $tests_ref) {
    for my $t ($tests_ref->@*) {
        my @result = $package->can($sub)->($t->{'input'}->@*);
        is(\@result, $t->{'expected'}, "${package}::${sub} " . $t->{'description'});
    }
    return 0;
}

done_testing();
