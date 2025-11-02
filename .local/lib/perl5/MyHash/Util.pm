package MyHash::Util;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Carp     qw(croak);
use JSON::PP qw();
use Storable qw(dclone);

use constant {
    'JSON'          => JSON::PP->new->canonical->utf8(1)->boolean_values(false, true)->pretty->space_before(0),
    'JSON_ONE_LINE' => JSON::PP->new->canonical->utf8(1)->boolean_values(false, true)->pretty(0)->indent(0),
};

use Exporter qw(import);
our @EXPORT_OK = qw(
    build_data_cache
    build_reverse_indices
    clean_hash_from_key
    compact
    decode_json_recursive_inplace
    merge
    merge_inplace_both
    merge_inplace_left
);

sub build_data_cache($data_href, %caches) {
    my \%data = $data_href;

    my %result;

    while (my ($cache_name, $value_extractor) = each %caches) {
        foreach my $key (keys %data) {
            $result{$cache_name}{$key} = $value_extractor->($data{$key}) // 'undef';
        }
    }

    return \%result;
}

sub build_reverse_indices($data_href, %indices) {
    my \%data = $data_href;

    my %result;

    while (my ($index_name, $id_extractor) = each %indices) {
        foreach my $key (keys %data) {
            my $id = $id_extractor->($data{$key}) // 'undef';
            undef $result{$index_name}{$id}{$key};
        }
    }

    return \%result;
}

sub clean_hash_from_key($data, $key_to_remove) {
    if (ref $data eq 'ARRAY') {
        __SUB__->($_, $key_to_remove) foreach $data->@*;
    } elsif (ref $data eq 'HASH' || blessed $data) {
        delete $data->{$key_to_remove};
        __SUB__->($_, $key_to_remove) foreach values $data->%*;
    } else {
        # keep data as is
    }

    return $data;
}

sub compact($data) {
    ref $data eq 'HASH'
        or return $data;

    while (my ($key, $value) = each $data->%*) {
        if (!defined $value || (__SUB__->($value), ref $value eq 'HASH' && $value->%* == 0)) {
            delete $data->{$key};
        }
    }

    return $data;
}

sub decode_json_recursive_inplace($data) {
    if (!ref $data) {
        try {
            my $decoded = JSON()->decode($data);
            $data = $decoded;
            if (ref $decoded) {__SUB__->($data)}
        } catch ($e) {
            ## not an encoded json
        };
    } elsif (ref $data eq 'HASH') {
        $_ = __SUB__->($_) foreach values $data->%*;
    } elsif (ref $data eq 'ARRAY') {
        $_ = __SUB__->($_) foreach $data->@*;
    } else {
        croak 'invalid data type';
    }
    return $data;
}

sub flatten($data, $acc = {}, $prefix = undef) {
    ref $data eq 'HASH'
        or return $data;

    foreach my $key (keys $data->%*) {
        my $prefix = $prefix ? join '.', $prefix, $key : $key;
        my $value  = $data->{$key};
        if (ref $value eq 'HASH') {
            __SUB__->($value, $acc, $prefix);
        } else {
            $acc->{$prefix} = $value;
        }
    }

    return $acc;
}

sub merge($lhs, $rhs) {
    $lhs = dclone($lhs) if ref $lhs;
    $rhs = dclone($rhs) if ref $rhs;
    return merge_inplace_both($lhs, $rhs);
}

sub merge_inplace_left($lhs, $rhs) {
    $rhs = dclone($rhs) if ref $rhs;
    return merge_inplace_both($lhs, $rhs);
}

sub merge_inplace_both($lhs, $rhs) {
    return $rhs unless ref $lhs eq 'HASH' && ref $rhs eq 'HASH';

    while (my ($rkey, $rvalue) = each $rhs->%*) {
        $lhs->{$rkey} = __SUB__->($lhs->{$rkey}, $rvalue);
    }

    return $lhs;
}

__END__
