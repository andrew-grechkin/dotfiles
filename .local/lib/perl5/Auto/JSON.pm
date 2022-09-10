package Auto::JSON;

use v5.36;
use warnings     qw(FATAL utf8);
use experimental qw(builtin declared_refs defer for_list refaliasing try);

use Carp     qw(croak);
use JSON::PP qw();

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
