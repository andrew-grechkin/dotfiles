#!/usr/bin/env perl

use v5.40;
use warnings qw(FATAL utf8);

use English    qw(-no_match_vars);
use IPC::Open2 qw(open2);

use Test2::V0;
use Path::Tiny qw();

sub run_script {
    my ($stdin_content, @args) = @_;

    my @cmd = ('lines-set-op', @args);
    my $pid = open2(my $chld_out, my $chld_in, @cmd)
        or die "failed to execute script: $!\n";

    print {$chld_in} $stdin_content;
    close $chld_in;

    my @lines = <$chld_out>;
    waitpid($pid, 0) == $pid
        or die "unable to wait for process to finish: $!\n";

    if ($CHILD_ERROR != 0) {
        my $exit_code = $CHILD_ERROR >> 8;
        my $signal    = $CHILD_ERROR & 127;
        die "process exited with non-zero status (exit code: $exit_code, signal: $signal)\n";
    }

    chomp @lines;
    return join "\n", sort @lines;
}

sub test_operation {
    my ($name, $stdin, $file_content, $args, $expected) = @_;

    my $temp_file = Path::Tiny->tempfile;
    $temp_file->spew_utf8($file_content);

    my $output = run_script($stdin, @$args, $temp_file->stringify);

    my @expected_lines  = sort split m/\R/, $expected;
    my $sorted_expected = join "\n", @expected_lines;

    is($output, $sorted_expected, $name);
}

my $file1_content = "a\nb\nc\n";
my $file2_content = "b\nc\nd\n";

subtest 'Intersection' => sub {
    test_operation('output', $file1_content, $file2_content, ['-i'],  "b\nc");
    test_operation('count',  $file1_content, $file2_content, ['-ic'], '2');
};

subtest 'Union' => sub {
    test_operation('output', $file1_content, $file2_content, ['-u'],  "a\nb\nc\nd");
    test_operation('count',  $file1_content, $file2_content, ['-uc'], '4');
};

subtest 'Left Difference' => sub {
    test_operation('output', $file1_content, $file2_content, ['-l'],  'a');
    test_operation('count',  $file1_content, $file2_content, ['-lc'], '1');
};

subtest 'Right Difference' => sub {
    test_operation('output', $file1_content, $file2_content, ['-r'],  'd');
    test_operation('count',  $file1_content, $file2_content, ['-rc'], '1');
};

subtest 'Symmetric Difference' => sub {
    test_operation('output', $file1_content, $file2_content, ['-s'],  "a\nd");
    test_operation('count',  $file1_content, $file2_content, ['-sc'], '2');
};

done_testing();

__END__
