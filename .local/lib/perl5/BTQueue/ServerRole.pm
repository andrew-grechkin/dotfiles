use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ServerRole {
    use Data::Printer;

    use List::Util qw(first);

    use Cpanel::JSON::XS   qw();
    use IO::Async::Process qw();
    use Log::Any           qw($log);

    use Syntax::Keyword::Match;
    use Syntax::Operator::Equ;

    field $app : param;
    field $json = Cpanel::JSON::XS->new->canonical->utf8(0)->unblessed_bool([1])->pretty(0)->indent(0);

    field %queue;
    field %finished;
    field $slots = 1;

    ADJUST {
        weaken($app);
    }

    method on_stream($stream) {
        return $stream->write($self->_message_register());
    }

    method on_message($message, $socket) {
        try {
            $log->tracef('message received: %s', $message);
            $self->_dispatch($message, $socket);
        } catch ($err) {
            $log->debugf('invalid message received: %s', $message);
            p $err;
        };

        return 0;
    }

    method _message_register() {
        return $json->encode({event => 'register'}) . "\n";
    }

    method _dispatch($message, $stream) {
        my \%req = $json->decode($message);

        match($req{event} : equ) {
            case ('halt') {
                $log->infof('halting server');
                $app->halt();
            }
            case ('kill') {
                $log->infof('killing process: %s', $req{what});
                my $proc = first {$_->{id} eq $req{what}} values %queue;
                p $proc;

                if ($proc) {
                    $log->debugf('sending signal KILL to: %s', $proc->{pid});
                    $proc->{socket}->write($json->encode({event => 'cancel'}) . "\n");
                }
            }
            case ('clear') {
                $log->infof('clearing finished jobs');
                %finished = ();
            }
            case ('query') {
                $log->infof('responding with data on query: %s', "$stream");

                my \@procs = $self->_procs();

                if (exists $req{what}) {
                    if (defined $req{what}) {
                        $stream->write(
                            $json->encode({
                                event => 'response_single',
                                item  => (first {$_->{id} eq $req{what}} @procs),
                                (field => $req{field}) x !!$req{field},
                            })
                                . "\n",
                        );
                    } else {
                        $stream->write(
                            $json->encode({
                                event => 'response_single',
                                item  => $procs[-1],
                                (field => $req{field}) x !!$req{field},
                            })
                                . "\n",
                        );
                    }
                } else {
                    $stream->write(
                        $json->encode({
                            event => 'response',
                            items => \@procs,
                        })
                            . "\n",
                    );
                }
            }
            case ('register') {
                $log->infof('registering new process: %s', "$stream");
                if ($req{data}{depends}) {
                    my \@procs = $self->_procs();
                    $req{data}{depends} = ((first {$_->{id} eq "$req{data}{depends}"} @procs) // $procs[-1])->{id};
                }
                $queue{$stream} = {socket => $stream, status => 'waiting', $req{data}->%*};
                $self->_on_queue_update();
            }
            case ('finished') {
                $log->infof('process finished: %s', "$stream");
                if (my $descriptor = $queue{$stream}) {
                    delete $descriptor->{'socket'};
                    p $descriptor;
                    $descriptor->{status} = $req{data}{exit_code} == 0 ? 'finished' : 'failed';
                    $descriptor->@{keys $req{data}->%*} = values $req{data}->%*;
                }
                $self->_on_queue_update();
            }
            case ('closed') {
                $log->infof('stream closed: %s', "$stream");
                if (my $descriptor = $queue{$stream}) {
                    delete $descriptor->{'socket'};
                    p $descriptor;
                    $descriptor->{status} = 'closed';
                }
                $self->_on_queue_update();
            }
            case (undef) {
                $log->warnf('malformed message: %s', $message)
            }
            default {
                $log->warnf('unknown event: %s', $req{event});
                p %req;
                $stream->write($json->encode({event => 'unknown-event'}) . "\n");
            }
        }

        return;
    }

    method _procs() {
        my @result = map {
            my %d = ($_->%*);
            delete $d{socket};
            \%d
        } sort {$a->{start} cmp $b->{start}} (values %queue, values %finished);

        return \@result;
    }

    method _on_queue_update() {
        return unless %queue;
        $log->debugf('queue is not empty: %s', scalar %queue);

        $self->_move_to_finished();

        my @waiting = sort {$a->{start} cmp $b->{start}} grep {$_->{status} eq 'waiting'} values %queue;
        while (@waiting) {
            my @running = grep {$_->{status} eq 'running'} values %queue;

            if (@running >= $slots) {
                $log->tracef('there are no empty slots available: %d/%d', scalar @running, $slots);
                last;
            }

            $log->debugf('there are empty slots available: %d/%d', scalar @running, $slots);

            my $descriptor = shift @waiting;

            if (my $id = $descriptor->{depends}) {
                p $id;
                my $dependency = first {$_->{id} eq $id} $self->_procs()->@*;
                p $dependency;

                if (!$dependency || $dependency->{status} eq 'failed') {
                    $log->debugf('canceling process');
                    $descriptor->{status} = 'canceled';
                    my $socket = delete $descriptor->{socket};
                    $socket->write($json->encode({event => 'cancel'}) . "\n");
                    next;
                } elsif ($dependency->{status} eq 'waiting') {
                    next;
                } else {
                    $log->warnf('never should be here');
                }
            }

            my %copy = $descriptor->%*;
            delete @copy{'socket', 'status'};
            say {*STDOUT} $json->encode(\%copy);

            $descriptor->{status} = 'running';
            $log->debugf('executing process: %s', $descriptor->{id});
            $descriptor->{socket}->write($json->encode({event => 'execute'}) . "\n");
        }

        return;
    }

    method _move_to_finished() {
        my @closed = grep {!$queue{$_}{'socket'}} keys %queue;

        foreach my $id (@closed) {
            $finished{$id} = delete $queue{$id};
        }

        return;
    }
}

__END__
