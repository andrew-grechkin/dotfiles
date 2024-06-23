package Auto::JSON;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

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
            croak "Unable to decode JSON: '$e'";
        };
    }
    return bless \$data, $class;
}

sub TO_JSON ($self) {
    return ${$self};
}

__END__
