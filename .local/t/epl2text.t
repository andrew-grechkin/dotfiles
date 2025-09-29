#!/usr/bin/env -S perl -CALS

use v5.40;
use warnings qw(FATAL utf8);
use utf8;

use English    qw(-no_match_vars);
use IPC::Open2 qw(open2);

use Test2::V0;
use Path::Tiny qw(path);

sub run_script {
    my ($stdin_content, @args) = @_;

    my @cmd = ('epl2text', @args);
    my $pid = open2(my $chld_out, my $chld_in, @cmd)
        or die "failed to execute script: $!\n";
    binmode($chld_out, ':encoding(UTF-8)')
        or die "unable to change IO encoding: $!\n";
    binmode($chld_in, ':encoding(UTF-8)')
        or die "unable to change IO encoding: $!\n";

    print {$chld_in} $stdin_content if defined $stdin_content;
    close $chld_in;

    my $output = do {local $/ = undef; <$chld_out>};

    waitpid($pid, 0) == $pid
        or die "unable to wait for process to finish: $!\n";

    if ($CHILD_ERROR != 0) {
        my $exit_code = $CHILD_ERROR >> 8;
        my $signal    = $CHILD_ERROR & 127;
        die "process exited with non-zero status (exit code: $exit_code, signal: $signal)\n";
    }

    return $output;
}

my $template1     = 'Привет, <%= $name %>. Your city is <%= $city %>.';
my $json1_content = '{"name": "Алиса", "role": "admin", "city": "ピラ砂丘"}';
my $json2_content = '{"city": "Wonderland"}';

my $template2 = <<'EO_TEMPLATE2';
% for my $user (@$users) {
- <%= $user %>
% }
EO_TEMPLATE2
my $json3_content = '{"users": ["Bob", "Чарли"]}';

subtest 'Basic rendering' => sub {
    my $json_file = Path::Tiny->tempfile;
    $json_file->spew_utf8($json1_content);

    my $output = run_script($template1, $json_file->stringify);
    like($output, qr/Привет, Алиса. Your city is ピラ砂丘/, 'Renders with single JSON file');
};

subtest 'Merging JSON files' => sub {
    my $json1 = Path::Tiny->tempfile;
    $json1->spew_utf8($json1_content);

    my $json2 = Path::Tiny->tempfile;
    $json2->spew_utf8($json2_content);

    my $output = run_script($template1, $json1->stringify, $json2->stringify);
    like($output, qr/Привет, Алиса. Your city is Wonderland/, 'Merges data from two JSON files');
};

subtest 'Looping in template' => sub {
    my $json_file = Path::Tiny->tempfile;
    $json_file->spew_utf8($json3_content);

    my $expected = "- Bob\n- Чарли\n";
    my $output   = run_script($template2, $json_file->stringify);
    is($output, $expected, 'Correctly renders a loop');
};

done_testing();

__END__
