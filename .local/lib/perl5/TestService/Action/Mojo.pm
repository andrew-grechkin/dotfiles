package TestService::Action::Mojo;

use v5.34;
use Mojo::Base 'TestService::Action', -signatures;
use namespace::autoclean;

use Mojo::Promise;
use Mojo::URL;
use Mojo::UserAgent;

use experimental qw(declared_refs refaliasing try);

use constant { ## no tidy
    'UA' => Mojo::UserAgent->new->max_redirects(2)->request_timeout(10)->tap(sub {$_->proxy->detect}),
};

# ---
# wttr.in:
#   common:
#     type: Mojo
#     verb: get
#     url: https://wttr.in
#     query: format=j1
#     output: ~
#     save_to: /tmp/$$name.yaml
#   specific:
#     Local: {}
#     Amsterdam:
#       path: Amsterdam

sub fetch_data ($self, $tests) {
    my \@tests = $tests;

    my @promises = map {$self->make_request($_)} @tests;

    my $results;
    Mojo::Promise->all(@promises)->then(
        sub (@txs) {
            $results = [map {decode_tx($_->[0])} @txs];
        },
    )->wait;

    return $results;
}

sub make_request ($self, $options) {
    my $url = Mojo::URL->new($options->{'url'} // 'https://example.com');
    $url->scheme($options->{'scheme'})         if $options->{'scheme'};
    $url->userinfo($options->{'userinfo'})     if $options->{'userinfo'};
    $url->host($options->{'host'})             if $options->{'host'};
    $url->port($options->{'port'})             if $options->{'port'};
    $url->path_query($options->{'path_query'}) if $options->{'path_query'};
    $url->path($options->{'path'})             if $options->{'path'};
    $url->query($options->{'query'})           if $options->{'query'};
    $url->fragment($options->{'fragment'})     if $options->{'fragment'};

    return UA()->get_p($url => {Accept => 'application/json'});

    # p $url;
    # try {
    #     my $tx  = UA()->get($url => {Accept => '*/*'});
    #     my $res = $tx->result;

    #     if (not $res->is_success) {
    #         croak sprintf ("Failed '%s': %s %s\n", $tx->req->url, $res->code, $res->message);
    #     }
    #     my $result = $res->json;
    #     return $result if $result;
    # } catch ($error) {
    #     chomp $error;
    #     croak sprintf ("failed requesting url '%s': %s", $url->to_abs, $error);
    # };

    # return {'data' => "$self", 'Привет' => 42};
}

sub decode_tx ($tx) {
    my $res  = $tx->result;
    my $data = $res->json // {};

    return $data;
}

1;

__END__
