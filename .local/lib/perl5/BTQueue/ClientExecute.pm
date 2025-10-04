## no critic [Modules::RequireExplicitPackage]
use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ClientExecute : isa(BTQueue::Client) {
    use Data::Printer;

    use Config     qw(%Config);
    use English    qw(-no_match_vars);
    use File::Spec qw();
    use List::Util qw(mesh);

    use IO::Async::Process qw();
    use Log::Any           qw($log);
    use String::ShellQuote qw(shell_quote_best_effort);
    use Time::Moment       qw();

    use Syntax::Keyword::Match;
    use Syntax::Operator::Equ;

    use constant {
        'SIGNAL_FLAG'      => 127,
        'COREDUMP_FLAG'    => 128,
        'NOTIFY_AFTER_SEC' => 5,
    };

    field $cmd : param;
    field $depends : param;

    field $shell;
    field %signals : reader = mesh [split m/\s/, $Config{sig_num}], [split m/\s/, $Config{sig_name}];
    field $start : reader   = Time::Moment->now;

    method message_register() {
        $shell = join(' ', map {shell_quote_best_effort($_)} $cmd->@*);
        return $self->json->encode({
            event => 'register',
            data  => {
                cmd   => $cmd,
                cwd   => File::Spec->rel2abs('.'),
                id    => $self->app->id,
                out   => $self->app->out,
                pid   => $PROCESS_ID,
                res   => $self->app->res_path,
                shell => $shell,
                start => $start->to_string,
                (depends => $depends) x !!$depends,
            },
        }) . "\n";
    }

    method message_finished($code, $signal, $core) {
        my $signal_name = $signal ? $signals{$signal} : undef;

        return $self->json->encode({
            event => 'finished',
            data  => {
                exit_code => $code,
                finish    => Time::Moment->now->to_string,
                (signal      => $signal) x !!$signal,
                (signal_name => $signal_name) x !!$signal,
                (coredump    => $core) x !!$core,
            },
        }) . "\n";
    }

    method on_stream($stream) {
        return $stream->write($self->message_register());
    }

    method dispatch($stream, $message, $data_href) {
        my \%data = $data_href;

        match($data{event} : equ) {
            case ('cancel') {
                $log->infof('canceling: %s', $cmd);
                say {$self->app->res} 'canceled';
                exit 200;                                                      # TODO
            }
            case ('execute') {
                $start = Time::Moment->now;
                $log->infof('executing child: %s', $cmd);
                say {$self->app->res} 'cd ', File::Spec->rel2abs('.'), ' && ', $shell;
                my $process = IO::Async::Process->new(
                    command   => $cmd,
                    on_finish => sub ($process, $status) {
                        my ($signal, $core);
                        if ($status & SIGNAL_FLAG()) {
                            $signal = $status & SIGNAL_FLAG();
                            $core   = $status & COREDUMP_FLAG();
                            say {$self->app->res} sprintf('died with signal: %d (%s)', $signal, $signals{$signal});
                            say {$self->app->res} sprintf('%s coredump', $core ? 'with' : 'without');
                        }

                        my $code = ($status >> 8);
                        say {$self->app->res} 'exitcode: ', $code;

                        $log->infof('process exited with code: %d', $code);

                        my $dur_sec = $start->delta_seconds(Time::Moment->now);
                        if (!$self->app->quiet && $dur_sec > NOTIFY_AFTER_SEC()) {
                            my $gid = getgrnam($ENV{USER});
                            system('wall', '-g', $gid,
                                sprintf('Process %s has finished in %d seconds', $self->app->id, $dur_sec))
                                or true;
                        }

                        $stream->write($self->message_finished($code, $signal, $core))->then(sub {
                            exit $code;
                        })->catch(sub (@p) {
                            p @p;
                            exit 200;                                          # TODO
                        })->await;
                    },
                );
                $self->app->loop->add($process);
            }
            case ('registered') {$log->debugf('process registered: %s', $message)}
            case (undef)        {$log->warnf('malformed message: %s', $message)}
            default             {$log->warnf('unknown event: %s', $data{event})}
        }

        return;
    }
}

__END__
