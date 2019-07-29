#!/usr/bin/env perl

use v5.40;
use warnings qw(FATAL utf8);

use Test2::V0;
use Test2::Tools::Spec;

use experimental qw(class declared_refs defer refaliasing);

use MyTime::Util qw(
    from_mysql_timestamp
    in_other_timezone
    overwrite_timezone
    timezone
);

my $tz1 = timezone('UTC');
my $tz2 = timezone('Asia/Tehran');

{                                                                              # experimental dynamic test
    my %tests = (
        'MyTime::Util::from_mysql_timestamp' => [
            {i => ['2021-02-01 00:00:00', $tz1], e => '2021-02-01T00:00:00Z', d => "No DST @{[$tz1->name]}"},
            {i => ['2021-05-01 00:00:00', $tz1], e => '2021-05-01T00:00:00Z', d => "   DST @{[$tz1->name]}"},
        ],
    );

    no strict 'refs';
    foreach my $test (keys %tests) {
        tests $test => sub {
            foreach my $param ($tests{$test}->@*) {
                is($test->($param->{i}->@*), $param->{e}, $param->{d});
            }
        };
    }
}

tests 'MyTime::Util::from_mysql_timestamp' => sub {
    is(from_mysql_timestamp('2021-02-01 00:00:00', $tz1), '2021-02-01T00:00:00Z',      "No DST @{[$tz1->name]}");
    is(from_mysql_timestamp('2021-05-01 00:00:00', $tz1), '2021-05-01T00:00:00Z',      "   DST @{[$tz1->name]}");
    is(from_mysql_timestamp('2021-02-01 00:00:00', $tz2), '2021-02-01T00:00:00+03:30', "No DST @{[$tz2->name]}");
    is(from_mysql_timestamp('2021-05-01 00:00:00', $tz2), '2021-05-01T00:00:00+04:30', "   DST @{[$tz2->name]}");
};

tests 'MyTime::Util::in_other_timezone' => sub {
    is(in_other_timezone('2021-02-01T22:00:00+01:00', $tz1),  '2021-02-01T21:00:00Z',      "No DST @{[$tz1->name]}");
    is(in_other_timezone('2021-05-01 22:00:00+02:00', $tz1,), '2021-05-01T20:00:00Z',      "   DST @{[$tz1->name]}");
    is(in_other_timezone('2021-02-01T22:00:00+01:00', $tz2),  '2021-02-02T00:30:00+03:30', "No DST @{[$tz2->name]}");
    is(in_other_timezone('2021-05-01 22:00:00+02:00', $tz2,), '2021-05-02T00:30:00+04:30', "   DST @{[$tz2->name]}");
};

tests 'MyTime::Util::overwrite_timezone' => sub {
    is(overwrite_timezone('2021-02-01T22:00:00+01:00', $tz1),  '2021-02-01T22:00:00Z',      "No DST @{[$tz1->name]}");
    is(overwrite_timezone('2021-05-01 22:00:00+02:00', $tz1,), '2021-05-01T22:00:00Z',      "   DST @{[$tz1->name]}");
    is(overwrite_timezone('2021-02-01T22:00:00+01:00', $tz2),  '2021-02-01T22:00:00+03:30', "No DST @{[$tz2->name]}");
    is(overwrite_timezone('2021-05-01 22:00:00+02:00', $tz2,), '2021-05-01T22:00:00+04:30', "   DST @{[$tz2->name]}");
};

done_testing();

__END__
