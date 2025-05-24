package BTQueue::Server;

use v5.40;
use experimental qw(class declared_refs defer refaliasing);

use Data::Printer;

use Exporter qw(import);
our @EXPORT_OK = qw(
    server_check_running
);

use English qw(-no_match_vars);
use POSIX   qw(
    EADDRINUSE
    ECONNREFUSED
    ENOENT
);

use Future::AsyncAwait;

use Cpanel::JSON::XS    qw();
use IO::Async::Listener qw();
use Log::Any            qw($log);

use constant {JSON_ONE_LINE => Cpanel::JSON::XS->new->canonical->utf8(0)->unblessed_bool([1])->pretty(0)->indent(0)};

async sub server_check_running($loop, $options_href) {
    my \%OPTIONS = $options_href;

    if (-S $OPTIONS{socket_path}) {
        try {
            my $socket = await $loop->connect(
                addr => {
                    family   => 'unix',
                    socktype => 'stream',
                    path     => $OPTIONS{socket_path},
                },
            );
            $log->infof('another server is running on socket, bailing out: %s', $OPTIONS{socket_path});
            exit EADDRINUSE();
        } catch ($err) {
            my $category = $err->category;
            my @details  = $err->details;

            if ($category eq 'connect' and $details[-1] == ECONNREFUSED()) {
                $log->debugf('abandoned socket detected: %s', $OPTIONS{socket_path});
                unlink $OPTIONS{socket_path} or do {
                    my $err = int($!);
                    $log->errorf('unable cleanup socket ([%d] %s): %s', int($!), $!, $OPTIONS{socket_path});
                    exit $err;
                };
            } elsif ($category eq 'connect' and $details[-1] == ENOENT()) {
                return;
            } else {
                $log->fatalf('unknown issue ([%d] %s): %s', int($details[-1]), $details[-1], $OPTIONS{socket_path});
                exit int($details[-1]);
            }
        };
    }

    return;
}

__END__
