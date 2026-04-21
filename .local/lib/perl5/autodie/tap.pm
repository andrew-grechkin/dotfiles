package autodie::tap;

# just an example how to monkey patch `autodie::exception` class and
# make sure it has additional methods in each object

use v5.42;
use autodie  qw();                                                             # call import later, after patch
use warnings qw(FATAL utf8);
use overload qw();

use List::Util qw(pairmap);

use JSON::MaybeXS qw();

my $JCHARS = JSON::MaybeXS->new(utf8 => 0, canonical => 1, indent => 0, pretty => 0, convert_blessed => 1);
my $JBYTES = JSON::MaybeXS->new(utf8 => 1, canonical => 1, indent => 0, pretty => 0, convert_blessed => 1);

sub _code_to_string($val) {
    state $has_b = eval {require B; 1};

    if ($has_b) {
        my $cv = B::svref_2object($val);

        if ($cv->can('GV') && $cv->GV->isa('B::GV')) {
            my $gv   = $cv->GV;
            my $pkg  = $gv->STASH->NAME // 'undef';
            my $name = $gv->NAME        // 'undef';

            if ($name && $name eq '__ANON__') {
                $name = sprintf('%s [%s]', $name, $gv->FILE);
            }

            return "sub ${pkg}::$name";
        }
    }

    return 'sub { ... }';
}

sub _glob_to_string($val) {
    my $name = *{$val}{NAME}
        or return "$val";
    $name = '$lexical_var' if $name eq '$_[...]';

    my $pkg = *{$val}{PACKAGE} // 'undef';
    return $name if $pkg && $pkg eq 'main' && $name =~ /^\$/;

    return "*${pkg}::$name";
}

sub _prepare_data_recursively($val, $seen_href = {}) {
    my $type = ref($val)
        or return $val;

    return "$val" if $seen_href->{"$val"}++;

    while ($type eq 'REF') {
        $val  = $$val;
        $type = ref($val);
        return "$val" if $seen_href->{"$val"}++;
    }

    # if it's an object and it can present itself, no need to do anything additionally
    if (blessed($val)) {
        return $val->TO_JSON   if $val->can('TO_JSON');
        return "$val"          if overload::OverloadedStringify($val);
        return $val->stringify if $val->can('stringify');
        return $val->to_string if $val->can('to_string');
    }

    my $reftype = reftype($val);
    if ($type eq 'ARRAY' || $reftype eq 'ARRAY') {
        return [map {__SUB__->($_, $seen_href)} $val->@*];
    }

    if ($type eq 'HASH' || $reftype eq 'HASH') {
        state $sub = __SUB__;
        # cannot use __SUB__ directly in pairmap because it will point onto block itself and create endless recursion
        return {(('__CLASS__' => $type) x !!blessed($val)), pairmap {$a => $sub->($b, $seen_href)} $val->%*};
    }

    return _glob_to_string($val)                           if $type eq 'GLOB';
    return _code_to_string($val)                           if $type eq 'CODE';
    return sprintf('\\(%s)', __SUB__->($$val, $seen_href)) if $type eq 'SCALAR';

    die 'unexpected input, never should be here (need to fix function)';
}

sub _TO_JSON($self, @) {
    return _prepare_data_recursively({
        args       => $self->args,
        context    => $self->context,
        errno      => int($self->errno),
        errmsg     => sprintf('%s', $self->errno),
        error_type => 'autodie',
        eval_error => $self->eval_error,
        file       => $self->file,
        function   => $self->function,
        line       => $self->line,
        package    => $self->package,
    });
}

sub _to_json($self, @args) {
    return $JCHARS->encode(_TO_JSON($self, @args));
}

sub _encode_json($self, @args) {
    return $JBYTES->encode(_TO_JSON($self, @args));
}

sub import { ## no critic [Subroutines::RequireArgUnpacking]
    my ($class, @args) = @_;

    state $patched = 0;

    unless ($patched++) {
        ## no critic [TestingAndDebugging::ProhibitNoWarnings]
        no warnings 'redefine';
        *autodie::exception::TO_JSON     = \&_TO_JSON;
        *autodie::exception::to_json     = \&_to_json;
        *autodie::exception::encode_json = \&_encode_json;
    }

    @_ = ('autodie', @args);
    goto &autodie::import;
}

__END__

=pod

=encoding utf8

=head1 NAME

autodie::tap - Wrapper to extend autodie::exception with additional methods

=head1 SYNOPSIS

    use autodie::tap qw(:all);

    try {
        open(my $fh, '<', 'non-existent');
    } catch ($e) {
        say $e->to_json;
    }

=head1 DESCRIPTION

This module acts as a transparent wrapper for L<autodie>. Upon import, it
monkey-patches L<autodie::exception> to add additional functionality and
helper methods.

This is particularly useful for TUI applications or CLI tools that need to
output machine-readable error context or additional metadata.

=head1 METHODS

=head2 TO_JSON

Returns a hash reference containing the exception details. This is the standard
method recognized by L<JSON::MaybeXS> and L<Cpanel::JSON::XS> when
C<convert_blessed> is enabled.

=head2 to_json

A convenience method that returns the encoded JSON string (characters).

=head2 encode_json

A convenience method that returns the encoded JSON bytes (UTF-8 encoded).

=cut
