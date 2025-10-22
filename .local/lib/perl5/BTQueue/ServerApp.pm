use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ServerApp {
    # use Carp::Always;
    # use Data::Printer;

    use English    qw(-no_match_vars);
    use File::Spec qw();
    use File::Temp qw();
    use POSIX      qw(
        EADDRINUSE
        SIGALRM
        SIGINT
        SIGTERM
        setsid
    );
    use Sub::Util qw(set_subname);

    use IO::Async::Loop     qw();
    use IO::Async::Listener qw();
    use IO::Async::Signal   qw();
    use Log::Any            qw($log);

    use BTQueue::ServerRole qw();                                              # roles not implemented yet in 5.40, emulating

    field $config : param;
    field $loop : reader = IO::Async::Loop->new;
    field $role;

    ADJUST {
        $role = BTQueue::ServerRole->new(app => $self);
    }

    method execute() {
        $self->_listen();

        if ($config->foreground) {
            $self->_setup_signal_handlers();
            $loop->run;
        } else {
            $loop->fork(
                keep_signals => true,
                code         => sub() {
                    setsid()
                        or die $log->fatalf('failed to create new session ([%d] %s)', int($!), $!) . "\n";

                    close STDIN && open(STDIN, '<', File::Spec->devnull)
                        or die "reopen stdin: $!";

                    close STDOUT && open(STDOUT, '>>', File::Spec->catfile($config->temp_dir, 'journal.jsonl'))
                        or die "reopen stdout: $!";

                    close STDERR && open(STDERR, '>>', File::Spec->catfile($config->temp_dir, 'log'))
                        or die "reopen stderr $!";

                    STDOUT->autoflush(1);
                    STDERR->autoflush(1);

                    $self->_setup_signal_handlers();
                    $loop->run;

                    return 0;
                },
            );
        }

        return 0;
    }

    method halt($errno = 0, %add) {
        $log->tracef('halting process with error code: %d', $errno);
        $loop->stop();

        if (-S $config->socket_path) {
            unlink($config->socket_path)
                or $log->warnf('unable to cleanup socket ([%d] %s): %s', int($!), $!, $config->socket_path);
        }

        exit $errno;
    }

    method _listen() {
        my $listener = IO::Async::Listener->new(
            on_stream => sub($, $stream) {
                $log->tracef('stream created: %s', "$stream");

                $stream->configure(
                    on_read => sub($self, $buff_sref, $eof) {
                        if (substr($$buff_sref, -1) eq "\n") {
                            if ($$buff_sref =~ s/^(.*)\R//) {
                                $role->on_message($1, $stream);
                            }
                            return 1;
                        }
                        return 0;
                    },
                    on_read_eof => sub($stream) {
                        $log->tracef('read eof for stream %s', "$stream");
                        $role->on_message('{"event": "closed"}', $stream);
                    },
                    on_read_error => sub(@p) {
                        $log->errorf('read_error: %s', \@p);
                    },
                    on_write_eof => sub(@p) {
                        $log->tracef('write_eof: %s', \@p);
                    },
                    on_write_error => sub(@p) {
                        $log->errorf('write_error: %s', \@p);
                    },
                );
                $loop->add($stream);
            },
        );

        $loop->add($listener);

        my $socket_path_init = $config->socket_path . '.' . $PROCESS_ID;
        $listener->listen(
            addr => {
                family   => 'unix',
                socktype => 'stream',
                path     => $socket_path_init,
            },
            on_fail => sub(@d) {
                $log->fatalf('unable to bind to socket ([%d] %s): %s', int($d[-1]), $d[-1], $d[-2]);
                exit int($d[-1]);
            },
            on_listen_error => sub(@d) {
                unlink $socket_path_init
                    or $log->errorf('unable cleanup socket ([%d] %s): %s', int($!), $!, $socket_path_init);
                $log->fatalf('unable to listen on socket ([%d] %s): %s', int($d[-1]), $d[-1], $d[-2]);
                exit int($d[-1]);
            },
            on_listen => sub($self) {
                ## unfortunately there is no access to atomic rename which fails on existence of the target file
                ## man 2 rename (RENAME_NOREPLACE)
                ## checking file existence and renaming separately creates a very short race condition
                if (-S $config->socket_path) {
                    $log->noticef('another server is running on socket, bailing out: %s', $config->socket_path);
                    unlink $socket_path_init
                        or $log->errorf('unable cleanup socket ([%d] %s): %s', int($!), $!, $socket_path_init);
                    exit EADDRINUSE();
                }
                rename $socket_path_init, $config->socket_path or do {
                    my $err = int($!);
                    $log->fatalf('unable to expose socket ([%d] %s): %s', $err, $!, $config->socket_path);
                    exit $err;
                };
            },
        );

        return $self;
    }

    method _setup_signal_handlers() {
        $self->_add_signal_handler('ALRM', sub($signal) {$self->halt(128 + SIGALRM())});
        $self->_add_signal_handler('HUP',  sub($signal) { });
        $self->_add_signal_handler('INT',  sub($signal) {$self->halt(128 + SIGINT())});
        $self->_add_signal_handler('TERM', sub($signal) {$self->halt(128 + SIGTERM())});
        $self->_add_signal_handler('USR1', sub($signal) { });
        $self->_add_signal_handler('USR2', sub($signal) { });

        return;
    }

    method _add_signal_handler($name, $cb) {
        $log->tracef('addind signal handler: %s', $name);
        my $handler = IO::Async::Signal->new(
            name       => $name,
            on_receipt => set_subname("signal_handler_$name", $cb),
        );
        $loop->add($handler);
        return $handler;
    }
}

__END__
