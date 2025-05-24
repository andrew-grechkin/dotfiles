## no critic [Modules::RequireExplicitPackage]
use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::ClientQuery : isa(BTQueue::Client) {
    use Data::Printer;

    use Log::Any qw($log);

    use Syntax::Keyword::Match;
    use Syntax::Operator::Equ;

    field $request : param;
    field $then : param;

    method on_stream($stream) {
        $stream->write($self->json->encode($request) . "\n")
            ->then($then)
            ->await();

        return;
    }

    method dispatch($stream, $message, $data_href) {
        my \%data = $data_href;

        match($data{event} : equ) {
            case ('response') {
                say {*STDOUT} $self->json->encode($data{items});
                exit 0;
            }
            case ('response_single') {
                if (exists $data{field} && defined $data{field}) {
                    say {*STDOUT} $data{item}{$data{field}};
                } elsif (exists $data{field}) {
                    ## nothing to print
                } else {
                    say {*STDOUT} $self->json->encode($data{item});
                }
                exit 0;
            }
            case (undef) {
                $log->warnf('malformed message: %s', $message);
                exit 0;
            }
            default {
                $log->warnf('unknown event: %s', $data{event});
                exit 0;
            }
        }

        return;
    }
}

__END__
