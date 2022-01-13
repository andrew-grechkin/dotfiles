package TestService::Action::Mojo;

use v5.34;
use Mojo::Base 'TestService::Action', -signatures;
use namespace::autoclean;

use Carp;

use Mojo::Promise;
use Mojo::URL;
use Mojo::UserAgent;

use experimental qw(declared_refs refaliasing try);

use constant { ## no tidy
    'UA' => Mojo::UserAgent->new->insecure(1)->max_redirects(2)->request_timeout(10)->tap(sub {$_->proxy->detect}),
};

sub fetch_data ($self, $tests) {
    my \@tests = $tests;

    $self->log->debugf('fetching data in parallel: %d', scalar @tests);

    my @promises = map {$self->make_request($_)} @tests;

    my $results;
    Mojo::Promise->all(@promises)->then(
        sub (@txs) {
            $self->log->tracef("tx [%s %s] '%s'", $_->[0]->res->code, $_->[0]->res->message, $_->[0]->req->url)
                foreach @txs;
            $results = [map {decode_tx($_->[0])} @txs];
        },
    )->wait;

    return $results;
}

sub make_request ($self, $options) {
    my $url    = $self->make_url($options);
    my $verb   = lc ($options->{'verb'} // 'get');
    my $body   = $options->{'body'};
    my $method = UA()->can($verb =~ m/_p\z/ ? $verb : $verb . '_p')
        or croak $self->log->fatalf('invalid verb: %s', $verb);

    my %body = $options->{'body'} ? (json => $options->{'body'}) : ();

    return $method->(
        UA(),
        $url => { ## no tidy
            %{$options->{'headers'} // {}},
            Accept => 'application/json',
        },
        %body,
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

    return $url;
}

sub decode_tx ($tx) {
    my $res  = $tx->result;
    my $data = $res->json // {};

    return $data;
}

1;

__END__
