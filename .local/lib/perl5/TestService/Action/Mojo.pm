package TestService::Action::Mojo;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use Mojo::Base   qw(TestService::Action);
use experimental qw(class declared_refs defer refaliasing);
use namespace::autoclean;

use Carp qw(croak);

use Data::Printer;
use Mojo::Promise   qw();
use Mojo::URL       qw();
use Mojo::UserAgent qw();

use MyList::Util qw(partition);

use constant { ## no tidy
    'UA' => Mojo::UserAgent->new->insecure(1)->max_redirects(2)->request_timeout(10)->tap(sub {$_->proxy->detect}),
};

sub fetch_data ($self, $tests_aref) {
    my (\@sequential, \@parallel) = partition(sub ($it) {$it->{'sequential'}}, $tests_aref);

    my ($results, $error);
    if (@parallel) {
        $self->log->tracef('fetching data in parallel: %d', scalar @parallel);

        my @promises = map {$self->make_request($_)} @parallel;
        Mojo::Promise->all(@promises)->then(
            sub (@txs) {
                $results = [map {$self->decode_tx($_->[0])} @txs];
            },
        )->catch(
            sub ($err) {
                chomp $err;
                $error = $err;
            },
        )->wait;
    }
    if (@sequential) {
        $self->log->tracef('fetching data in a sequence: %d', scalar @sequential);

        Mojo::Promise->map({'concurrency' => 1}, sub {$self->make_request($_)}, @sequential)->then(
            sub (@txs) {
                $results = [map {$self->decode_tx($_->[0])} @txs];
            },
        )->catch(
            sub ($err) {
                chomp $err;
                $error = $err;
            },
        )->wait;
    }

    die $error if $error;
    return $results;
}

sub make_request ($self, $options) {
    my $url    = $self->make_url($options);
    my $verb   = lc($options->{'method'} // $options->{'verb'} // 'get');
    my $method = UA()->can($verb =~ m/_p\z/ ? $verb : $verb . '_p')
        or croak $self->log->fatalf('invalid verb: %s', $verb);

    my %headers = ( ## no tidy
        'accept' => 'application/json',
        %{$options->{'headers'} // {}},
    );
    my %body = $options->{'body'} ? ('json' => $options->{'body'}) : ();

    $self->log->tracef('rq: %s', $url);
    return $method->(UA(), $url => \%headers, %body)->catch(
        sub ($err) {
            die "$err: $url\n";
        },
    );
}

sub make_url ($self, $options) {
    my $url = Mojo::URL->new($options->{'url'} // 'https://example.com');
    $url->scheme($options->{'scheme'})         if $options->{'scheme'};
    $url->userinfo($options->{'userinfo'})     if $options->{'userinfo'};
    $url->host($options->{'host'})             if $options->{'host'};
    $url->port($options->{'port'})             if $options->{'port'};
    $url->path_query($options->{'path_query'}) if $options->{'path_query'};
    $url->path($options->{'path'})             if $options->{'path'};
    $url->query($options->{'query'})           if $options->{'query'};
    $url->fragment($options->{'fragment'})     if $options->{'fragment'};

    return $url->to_abs;
}

sub decode_tx ($self, $tx) {
    if ($tx->res->is_success) {
        $self->log->debugf("tx [%s %s]: '%s'", $tx->res->code, $tx->res->message, $tx->req->url);
    } else {
        $self->log->errorf("tx [%s %s]: '%s'", $tx->res->code, $tx->res->message, $tx->req->url);
    }
    $self->log->tracef('req: %s', np $tx->req);
    $self->log->tracef('res: %s', np $tx->res);

    my $res  = $tx->result;
    my $data = $res->json // {};

    return $data;
}

__END__
