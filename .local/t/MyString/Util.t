#!/usr/bin/env perl

use v5.40;
use warnings qw(FATAL utf8);

use Test2::V0;
use Test2::Tools::Spec;

use experimental qw(class declared_refs defer refaliasing);

use MyString::Util;

sub main() {
    my %hash1  = ('a' => 'a1', 'b' => 'b1');
    my %hash2  = ('c' => 'a2', 'd' => 'b2');
    my @array1 = ('1', 'a', 42);

    say MyString::Util::dump_one_line(\%hash1);
    say MyString::Util::dump_one_line(\%hash2);
    say MyString::Util::dump_one_line(\@array1);

    say '';

    print MyString::Util::dump(\%hash1);
    print MyString::Util::dump(\%hash2);
    print MyString::Util::dump(\@array1);

    say '';

    say MyString::Util::dump_one_line_json_like(\%hash1);
    say MyString::Util::dump_one_line_json_like(\%hash2);
    say MyString::Util::dump_one_line_json_like(\@array1);

    say '';

    print MyString::Util::dump_json_like(\%hash1);
    print MyString::Util::dump_json_like(\%hash2);
    print MyString::Util::dump_json_like(\@array1);

    return 0;
}

# TODO implement tests

done_testing();

__END__
