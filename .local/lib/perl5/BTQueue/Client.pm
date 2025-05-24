## no critic [Modules::RequireExplicitPackage]
use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::Client {
    use Cpanel::JSON::XS qw();
    use Log::Any         qw($log);

    field $app : reader : param;
    field $json : reader = Cpanel::JSON::XS->new->canonical->utf8(0)->unblessed_bool([1])->pretty(0)->indent(0);

    method on_message($stream, $message) {
        my %data;
        try {
            my $decoded = $json->decode($message);
            \%data = $decoded;
        } catch ($err) {
            $log->debugf('invalid message received: %s', $message);
        };

        try {
            $self->dispatch($stream, $message, \%data);
        } catch ($err) {
            $log->errorf('unable to dispatch message: %s', $message);
            $log->errorf('data: %s',                       $err);
        };

        return 0;
    }

    ADJUST {
        weaken($app);

        return $self;
    }
}

__END__
