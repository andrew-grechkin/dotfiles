package Web::Search;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use JSON::PP     qw();
use Scalar::Util qw(looks_like_number);

use Mojo::URL       qw();
use Mojo::UserAgent qw();

use Exporter qw(import);
our @EXPORT_OK = qw(
    request_to_location
    request_to_location_nt
);

use constant {'USER_AGENT' => 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:68.6.1) Gecko/20100101 Firefox/68.6.1'};

use constant {
    'UA' => Mojo::UserAgent->new
        ->max_redirects(2)
        ->request_timeout(10)
        ->tap(sub {$_->proxy->detect})
        ->tap(sub {$_->transactor->name(USER_AGENT())}),
    'URL'  => Mojo::URL->new('https://www.google.com/search?tbm=map&tch=1'),
    'JSON' => JSON::PP->new->canonical->utf8(0)->boolean_values(false, true)->pretty->space_before(0),
};

sub request_to_location($query, $lang = 'en') {
    my \%found = request_to_location_nt($query, $lang);

    if (   $found{'name'}
        && $found{'lat'}
        && $found{'lon'}
        && looks_like_number($found{'lat'})
        && looks_like_number($found{'lon'}))
    {
        return \%found;
    }

    die sprintf("Unable to detect location for: %s\n", $query);
}

sub request_to_location_nt($query, $lang = 'en') {
    my $url = URL()->clone->tap(sub ($self) {
        $self->query->append(hl => $lang, q => $query);
    });

    my $res = UA()->get($url)->result;
    $res->is_success
        or die sprintf("Failed to retrieve '%s': %s\n", $url, join(' ', $res->code, $res->message));

    my $body   = _uncrap_payload($res->text);
    my %result = ('q' => $query, 'name' => $query, 'lat' => undef, 'lon' => undef);

    _try2(\%result, $body);
    if (!$result{'lat'} || !$result{'lon'}) {
        _try1(\%result, $body);
    }

#     if (!$result{'lat'} || !$result{'lon'}) {
#         _try3(\%result, $body);
#     }

    if ($result{'lat'} && $result{'lon'}) {
        $result{'exif_lat'}   = to_exif_lat($result{'lat'});
        $result{'exif_lon'}   = to_exif_lon($result{'lon'});
        $result{'url_osm'}    = sprintf 'https://www.openstreetmap.org/#map=15/%s/%s', @result{'lat', 'lon'};
        $result{'url_google'} = sprintf 'https://www.google.com/maps/@%s,%s,15z',      @result{'lat', 'lon'};
    }

    return wantarray ? (\%result, $body) : \%result;
}

sub to_exif_lat($lat) {
    my $sign = $lat < 0 ? 'S' : 'N';
    $lat = abs $lat;
    my $deg = int($lat);
    my $min = ($lat - $deg) * 60;
    return sprintf '%d,%.2f%s', $deg, $min, $sign;
}

sub to_exif_lon($lon) {
    my $sign = $lon < 0 ? 'W' : 'E';
    $lon = abs $lon;
    my $deg = int($lon);
    my $min = ($lon - $deg) * 60;
    return sprintf '%d,%.2f%s', $deg, $min, $sign;
}

sub _try1($result_href, $body_aref) {
    my \@body = $body_aref;

    ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)
    $result_href->@{'lat', 'lon'} = ($body[0][1][0][14][9][2], $body[0][1][0][14][9][3]);

    return $result_href;
}

sub _try2($result_href, $body_aref) {
    my \@body = $body_aref;

#     ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)

    use Data::Printer;
    foreach my $it (@body) {
        next unless ($it && ref $it);
        if (   looks_like_number($it->[0] && $it->[1] && !(ref $it->[1]))
            && $it->[2][0][3][2]
            && $it->[2][0][3][3]
            && looks_like_number($it->[2][0][3][2])
            && looks_like_number($it->[2][0][3][3]))
        {
            $result_href->{'name'} = $it->[1];
            $result_href->@{'lat', 'lon'} = ($it->[2][0][3][2], $it->[2][0][3][3]);
            last;
        }
    }

    return $result_href;
}

sub _try3($result_href, $body_aref) {
    my \@body = $body_aref;

    _recursive_search_coordinates($result_href, \@body);

    return $result_href;
}

sub _recursive_search_coordinates($result_href, $aref) {
    use Data::Dumper;
    my \@arr = $aref;
    my $size = scalar @arr;
    for (my $i = 0; $i < $size; ++$i) {
        next unless $arr[$i];

        ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)
        if (   !(ref $arr[$i])
            && looks_like_number($arr[$i])
            && ($arr[$i] - int($arr[$i]))
            && $arr[$i + 1]
            && !(ref $arr[$i + 1])
            && looks_like_number($arr[$i + 1])
            && ($arr[$i + 1] - int($arr[$i + 1]))
            && (-90 <= $arr[$i] <= 90)
            && (-180 <= $arr[$i + 1] <= 180))
        {
            say Dumper(\@arr);
        }

        if (ref $arr[$i] eq 'ARRAY') {
            __SUB__->($result_href, $arr[$i]);
        }
    }

    return;
}

sub _uncrap_payload($text) {
    my $payload = $text =~ s{\/[*]["]["][*]\/\z}{}r;

    my $json = JSON()->decode($payload);
    $json = $json->{'d'} =~ s{\A[)]\]\}'\R}{}r; ## no critic (RegularExpressions::ProhibitEscapedMetacharacters)
    $json = JSON()->decode($json);

    return $json;
}

__END__
