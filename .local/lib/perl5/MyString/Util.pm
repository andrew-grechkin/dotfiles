package MyString::Util;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Sub::Util qw();
use overload  qw();

use Exporter qw(import);
our @EXPORT_OK = qw(
    stringify_array
);

my $dump = Sub::Util::set_subname 'dump', sub {
    return Data::Dumper->new([$_[0]])
        ->Indent(1)
        ->Quotekeys(1)
        ->Sortkeys(1)
        ->Terse(1)
        ->Trailingcomma(1)
        ->Useqq(0)
        ->Dump;
};
my $dump_json_like = Sub::Util::set_subname 'dump_json_like', sub {
    return Data::Dumper->new([$_[0]])
        ->Indent(1)
        ->Pair(': ')
        ->Quotekeys(1)
        ->Sortkeys(1)
        ->Terse(1)
        ->Trailingcomma(0)
        ->Useqq(1)
        ->Dump;
};
my $dump_one_line = Sub::Util::set_subname 'dump_one_line', sub {
    return Data::Dumper->new([$_[0]])
        ->Indent(0)
        ->Quotekeys(1)
        ->Sortkeys(1)
        ->Terse(1)
        ->Trailingcomma(1)
        ->Useqq(0)
        ->Dump;
};
my $dump_one_line_json_like = Sub::Util::set_subname 'dump_one_line_json_like', sub {
    return Data::Dumper->new([$_[0]])
        ->Indent(0)
        ->Pair(':')
        ->Quotekeys(1)
        ->Sortkeys(1)
        ->Terse(1)
        ->Trailingcomma(0)
        ->Useqq(1)
        ->Dump;
};

sub _export_and_replace_subs() {
    require Data::Dumper;
    no warnings 'redefine'; ## no critic [TestingAndDebugging::ProhibitNoWarnings]
    no strict 'refs'; ## no critic [TestingAndDebugging::ProhibitProlongedStrictureOverride]
    *{__PACKAGE__ . '::dump'}                    = $dump;
    *{__PACKAGE__ . '::dump_json_like'}          = $dump_json_like;
    *{__PACKAGE__ . '::dump_one_line'}           = $dump_one_line;
    *{__PACKAGE__ . '::dump_one_line_json_like'} = $dump_one_line_json_like;

    return;
}

sub dump {
    _export_and_replace_subs();
    return $dump->(@_);
}

sub dump_json_like {
    _export_and_replace_subs();
    return $dump_json_like->(@_);
}

sub dump_one_line {
    _export_and_replace_subs();
    return $dump_one_line->(@_);
}

sub dump_one_line_json_like {
    _export_and_replace_subs();
    return $dump_one_line_json_like->(@_);
}

sub stringify_array {
    return map { ## no tidy
              defined
            ? ref
                ? overload::OverloadedStringify($_)
                    ? "$_"
                    : dump_one_line($_)
                : $_
            : 'undef'
    } @_;
}

__END__
