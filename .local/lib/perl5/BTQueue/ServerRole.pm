## no critic [Modules::RequireExplicitPackage]
use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ServerRole {
    use Data::Printer;

    use List::Util qw(first);

    use Cpanel::JSON::XS   qw();
    use IO::Async::Process qw();
    use List::Util         qw(first);
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

        return $self;
    }

    method message_register() {
        return $json->encode({event => 'register'}) . "\n";
    }

    method on_stream($stream) {
        return $stream->write($self->message_register());
    }

    method on_message($message, $socket) {
        try {
            $log->tracef('message received: %s', $message);
            $self->dispatch($message, $socket);
        } catch ($err) {
            $log->debugf('invalid message received: %s', $message);
            p $err;
        };

        return 0;
    }

    method procs() {
        my @result = map {my %d = ($_->%*); delete $d{socket}; \%d}
            sort {$a->{start} cmp $b->{start}} (values %queue, values %finished);
        return \@result;
    }

    method dispatch($message, $stream) {
        my \%res = $json->decode($message);

        match($res{event} : equ) {
            case ('halt') {
                $log->infof('halting server');
                $app->halt();
            }
            case ('clear') {
                $log->infof('clearing finished jobs');
                %finished = ();
            }
            case ('query') {
                $log->infof('responding with data on query: %s', "$stream");

                my \@procs = $self->procs();

                if (exists $res{what}) {
                    if (defined $res{what}) {
                        $stream->write(
                            $json->encode({
                                event => 'response_single',
                                item  => (first {$_->{id} eq $res{what}} @procs),
                                (field => $res{field}) x !!$res{field},
                            })
                                . "\n",
                        );
                    } else {
                        $stream->write(
                            $json->encode({
                                event => 'response_single',
                                item  => $procs[-1],
                                (field => $res{field}) x !!$res{field},
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
                $log->infof('registering process: %s', "$stream");
                if ($res{data}{depends}) {
                    my \@procs = $self->procs();
                    $res{data}{depends} = ((first {$_->{id} eq "$res{data}{depends}"} @procs) // $procs[-1])->{id};
                }
                $queue{$stream} = {socket => $stream, status => 'waiting', $res{data}->%*};
                $self->on_queue_update();
            }
            case ('finished') {
                $log->infof('process finished: %s', "$stream");
                if (my $descriptor = $queue{$stream}) {
                    delete $descriptor->{'socket'};
                    p $descriptor;
                    $descriptor->{status} = $res{data}{exit_code} == 0 ? 'finished' : 'failed';
                    $descriptor->@{keys $res{data}->%*} = values $res{data}->%*;
                }
                $self->on_queue_update();
            }
            case ('closed') {
                $log->infof('stream closed: %s', "$stream");
                if (my $descriptor = $queue{$stream}) {
                    delete $descriptor->{'socket'};
                    p $descriptor;
                    $descriptor->{status} = 'closed';
                }
                $self->on_queue_update();
            }
            case (undef) {$log->warnf('malformed message: %s', $message)}
            default {
                $log->warnf('unknown event: %s', $res{event});
                $stream->write($json->encode({event => 'unknown-event'}) . "\n");
            }
        }

        return;
    }

    method on_queue_update() {
        return unless %queue;
        $log->debugf('queue is not empty: %s', scalar %queue);

        $self->move_to_finished();

        my @running = grep {$queue{$_}{status} eq 'running'} keys %queue;
        if (@running < $slots) {
            $log->debugf('there are empty slots available: %d/%d', scalar @running, $slots);

            while (my @waiting = grep {$_->{status} eq 'waiting'} values %queue) {
                my $descriptor = shift @waiting;

                if (my $id = $descriptor->{depends}) {
                    p $id;
                    my $dependency = first {$_->{id} eq $id} $self->procs()->@*;
                    p $dependency;
                    if (!$dependency || $dependency->{status} eq 'failed') {
                        $log->debugf('canceling process');
                        $descriptor->{status} = 'canceled';
                        my $socket = delete $descriptor->{socket};
                        $socket->write($json->encode({event => 'cancel'}) . "\n");
                        next;
                    } elsif ($dependency->{status} eq 'waiting') {
                        next;
                    }
                }

                my %copy = $descriptor->%*;
                delete @copy{'socket', 'status'};
                say {*STDOUT} $json->encode(\%copy);

                $descriptor->{status} = 'running';
                $log->debugf('executing process: %s', $descriptor->{id});
                $descriptor->{socket}->write($json->encode({event => 'execute'}) . "\n");
            }

        } else {
            $log->tracef('there are no empty slots available: %d/%d', scalar @running, $slots);
        }

        return;
    }

    method move_to_finished() {
        my @closed = grep {!$queue{$_}{'socket'}} keys %queue;
        foreach my $id (@closed) {
            $finished{$id} = delete $queue{$id};
        }

        return;
    }
}

__END__
