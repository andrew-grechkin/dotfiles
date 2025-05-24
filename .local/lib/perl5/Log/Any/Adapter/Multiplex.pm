package Log::Any::Adapter::Multiplex;

# ABSTRACT: Adapter to use allow structured logging across other adapters

use v5.40;
use autodie;
use warnings     qw(FATAL utf8);
use parent       qw(Log::Any::Adapter::Base);
use experimental qw(class declared_refs defer refaliasing);

use Carp       qw();
use List::Util qw();
use Sub::Util  qw();

use Log::Any          qw();
use Log::Any::Manager qw();
use Log::Any::Proxy   qw();

## no critic [Subroutines::ProtectPrivateSubs]

sub init ($self, @) {
    my \%adapters = $self->{'adapters'};

    if (List::Util::any {ref ne 'ARRAY'} values %adapters) {
        Carp::croak('A list of adapters and their arguments must be provided');
    }

    foreach my $adapter_name (sort keys %adapters) {
        my \@adapter_args = $adapters{$adapter_name};
        my $adapter_class = Log::Any::Manager->_get_adapter_class($adapter_name);
        eval "require $adapter_class" or Carp::croak $@; ## no critic [BuiltinFunctions::ProhibitStringyEval, ErrorHandling::RequireCheckingReturnValueOfEval]
        push $self->{'adapters_cache'}->@*, $adapter_class->new(@adapter_args, 'category' => $self->{'category'});
    }

    return;
}

sub structured ($self, $level, $category, @structured_log_args) {
    my $is_level = "is_$level";
    my $unstructured_log_text;
    my $result;

    foreach my $adapter ($self->{'adapters_cache'}->@*) {
        next unless $adapter->$is_level;
        if ($adapter->can('structured')) {
            $result = $adapter->structured($level, $category, @structured_log_args);
        } else {
            $unstructured_log_text //= join ' ', Log::Any::Proxy::_stringify_params(@structured_log_args);
            $adapter->$level($unstructured_log_text);
        }
    }

    return $result;
}

# Delegate detection methods to other adapters
{
#     no warnings 'redefine';
    no strict 'refs';
    foreach my $method (Log::Any->detection_methods()) {
        my $name = __PACKAGE__ . "::$method";
        *{$name} = Sub::Util::set_subname(
            $name => sub ($self, @) {
                return List::Util::any {$_->$method} $self->{'adapters_cache'}->@*;
            },
        );
    }
}

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Multiplex - Adapter to use allow structured logging across other adapters

=head1 VERSION

version 1.710

=head1 SYNOPSIS

    Log::Any::Adapter->set(
        'Multiplex',
        adapters => {
            'Stdout' => [],
            'Stderr' => [ log_level => 'warn' ],
            ...
            $adapter => \@adapter_args
        },
    );

=head1 DESCRIPTION

This built-in L<Log::Any> adapter provides a simple means of routing logs to
multiple other L<Log::Any::Adapter>s.

Adapters receiving messages from this adapter can behave just like they are the
only recipient of the log message. That means they can, for example, use
L<Log::Any::Adapter::Development/Structured logging> (or not).

C<adapters> is a hashref whose keys should be adapters, and whose
values are the arguments to pass those adapters on initialization.

Note that this differs from other loggers like L<Log::Dispatch>, which will
only provide its output modules a single string C<$message>, and not the full
L<Log::Any/Log context data>.

=head1 SEE ALSO

L<Log::Any>, L<Log::Any::Adapter>

=head1 AUTHORS

=over 4

=item *

Jonathan Swartz <swartz@pobox.com>

=item *

David Golden <dagolden@cpan.org>

=item *

Doug Bell <preaction@cpan.org>

=item *

Daniel Pittman <daniel@rimspace.net>

=item *

Stephen Thirlwall <sdt@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Jonathan Swartz, David Golden, and Doug Bell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
