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
    field $process;

    method on_stream($stream) {
        return $stream->write($self->_message_register());
    }

    method dispatch($stream, $message, $req_href) {
        my \%req = $req_href;

        match($req{event} : equ) {
            case ('cancel') {
                $log->infof('canceling: %s', $cmd);
                say {$self->app->res} 'canceled';
                $process->kill('INT') if $process;
            }
            case ('execute') {
                $start = Time::Moment->now;
                $log->infof('executing child: %s', $cmd);
                say {$self->app->res} 'cd ', File::Spec->rel2abs('.'), ' && ', $shell;

                $process = IO::Async::Process->new(
                    command   => $cmd,
                    on_finish => sub($process, $status) {
                        my ($signal, $core);
                        if ($status & SIGNAL_FLAG()) {
                            $signal = $status & SIGNAL_FLAG();
                            $core   = $status & COREDUMP_FLAG();
                            say {$self->app->res} sprintf('died with signal: %d (%s)', $signal, $signals{$signal});
                            say {$self->app->res} sprintf('%s coredump', $core ? 'with' : 'without');
                        }

                        my $code = $signal ? 128 + $signal : ($status >> 8);
                        {
                            local $! = $signal;
                            say {$self->app->res} 'exitcode: ',      int($!);
                            say {$self->app->res} 'exitcode_name: ', "$!";
                        }

                        $log->infof('process exited with code: %d', $code);

                        my $dur_sec = $start->delta_seconds(Time::Moment->now);
                        if (!$self->app->quiet && $dur_sec > NOTIFY_AFTER_SEC()) {
                            my $gid = getgrnam($ENV{USER});
                            system('wall', '-g', $gid,
                                sprintf('Process %s has finished in %d seconds', $self->app->id, $dur_sec))
                                or true;
                        }

                        $stream->write($self->_message_finished($code, $signal, $core))->then(sub {
                            exit $code;
                        })->catch(sub(@p) {
                            p @p;
                            exit 200;                                          # TODO
                        })->await;
                    },
                );

                $self->app->loop->add($process);
            }
            case ('registered') {$log->debugf('process registered: %s', $message)}
            case (undef)        {$log->warnf('malformed message: %s', $message)}
            default             {$log->warnf('unknown event: %s', $req{event})}
        }

        return;
    }

    method _message_register() {
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

    method _message_finished($code, $signal, $core) {
        my ($code_name, $signal_name);

        if ($signal) {
            $signal_name = $signals{$signal};
            $code_name   = sprintf 'died on signal: %s', $signal_name;
        } elsif ($code < 128) {
            local $! = $code;
            $code_name = "$!";
        } else {
            # do nothing
        }

        return $self->json->encode({
            event => 'finished',
            data  => {
                exit_code => $code,
                finish    => Time::Moment->now->to_string,
                (exit_code_name => $code_name) x !!$code_name,
                (signal         => $signal) x !!$signal,
                (signal_name    => $signal_name) x !!$signal,
                (coredump       => $core) x !!$core,
            },
        }) . "\n";
    }
}

__END__
