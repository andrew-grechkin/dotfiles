package Auto::JSON;

use v5.34;
use warnings;
use experimental qw(signatures try);

use Carp;
use JSON::PP;

my $json = JSON::PP->new->convert_blessed;

use overload
    '%{}'      => sub ($self, @) {${$self}},
    '@{}'      => sub ($self, @) {${$self}},
    '""'       => sub ($self, @) {$json->encode(${$self})},
    'bool'     => sub ($self, @) {1},
    'fallback' => 1;

sub new ($class, $data) {
    if (not ref $data) {
        try {
            $data = $json->decode($data);
        } catch ($e) {
            croak "Unable to decode JSON: '$data'";
        };
    }
    return bless \$data, $class;
}

sub TO_JSON ($self) {
    return ${$self};
}

1;

__END__
