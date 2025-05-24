## no critic [Modules::RequireExplicitPackage]
use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ClientApp {
    use Carp::Always;
    use Data::Printer;

    use English    qw(-no_match_vars);
    use File::Spec qw();
    use File::Temp qw();
    use POSIX      qw(setsid);

    use IO::Async::Loop qw();
    use Log::Any        qw($log);

    use BTQueue::ClientExecute qw();
    use BTQueue::ClientQuery   qw();

    field $loop : reader = IO::Async::Loop->new;
    field $role;

    field $config : param;

    field $id : reader       = substr(File::Temp::tempnam('', sprintf('%06s-', $PROCESS_ID)), 1);
    field $out : reader      = File::Spec->catfile($config->temp_dir, $id) . '.out';
    field $res_path : reader = File::Spec->catfile($config->temp_dir, $id) . '.res';
    field $res : reader;

    method connect() {
        $loop->connect(
            addr => {
                family   => 'unix',
                socktype => 'stream',
                path     => $config->socket_path,
            },
            on_connect_error => sub (@d) {
                $log->fatalf('unable to connect to socket ([%d] %s): %s', int($d[-1]), $d[-1], $d[-2]);
                exit int($d[-1]);
            },
            on_stream => sub ($stream) {
                $log->tracef('stream created');

                $stream->configure(
                    on_read => sub($self, $buff_sref, $eof) {
                        if (substr($$buff_sref, -1) eq "\n") {
                            if ($$buff_sref =~ s/^(.*)\R//) {
                                $role->on_message($stream, $1);
                            }
                            return 1;
                        }
                        return 0;
                    },
                    on_read_eof => sub ($stream) {
                        my $h = $stream->read_handle;
                        $log->tracef('read eof for socket: %s', "$h");
                    },
                    on_read_error => sub (@p) {
                        $log->errorf('read_error: %s', \@p);
                    },
                    on_write_eof => sub (@p) {
                        $log->tracef('write_eof: %s', \@p);
                    },
                    on_write_error => sub (@p) {
                        $log->errorf('write_error: %s', \@p);
                    },
                );
                $loop->add($stream);

                $role->on_stream($stream);
            },
        );

        return;
    }

    method prepare() {
        if (-t 0) {
            close STDIN && open(STDIN, '<', File::Spec->devnull)
                or die "reopen stdin: $!";
        }

        $log->debugf('output redirected to: %s', $out);

        close STDOUT && open(STDOUT, '>>',  $out);
        close STDERR && open(STDERR, '>>&', \*STDOUT);
        open($res, '>>', $res_path)
            or $log->errorf('unable to open result file ([%d] %s)', int($!), $!);

        STDOUT->autoflush(1);
        STDERR->autoflush(1);
        $res->autoflush(1);

        return;
    }

    method query($request_href, $then = sub { }) {
        $role = BTQueue::ClientQuery->new(app => $self, request => $request_href, then => $then);
        $self->connect();
        $loop->run;
        return 0;
    }

    method execute($cmd_aref, $depends = undef) {
        $role = BTQueue::ClientExecute->new(app => $self, cmd => $cmd_aref, depends => $depends);

        $self->connect();
        say {*STDOUT} $PROCESS_ID;

        $loop->fork(
            keep_signals => true,
            code         => sub() {
                $self->prepare();
                setsid()
                    or die $log->fatalf('failed to create new session ([%d] %s)', int($!), $!) . "\n";

                $loop->run;
                return 0;

            },
        );

        return 0;
    }
}

__END__
