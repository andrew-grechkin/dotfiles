package MyHash::Util;

use v5.36;
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(builtin declared_refs defer for_list refaliasing try);

use Storable qw(dclone);
use builtin  qw(blessed);

use Exporter qw(import);
our @EXPORT_OK = qw(
    build_data_cache
    build_reverse_indices
    clean_hash_from_key
    compact
    merge
    merge_inplace_both
    merge_inplace_left
);

sub build_data_cache ($data_href, %caches) {
    my \%data = $data_href;

    my %result;

    while (my ($cache_name, $value_extractor) = each %caches) {
        foreach my $key (keys %data) {
            $result{$cache_name}{$key} = $value_extractor->($data{$key}) // 'undef';
        }
    }

    return \%result;
}

sub build_reverse_indices ($data_href, %indices) {
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

sub clean_hash_from_key ($data, $key_to_remove) {
    if (ref $data eq 'ARRAY') {
        __SUB__->($_, $key_to_remove) foreach $data->@*;
    } elsif (ref $data eq 'HASH' || blessed $data) {
        delete $data->{$key_to_remove};
        __SUB__->($_, $key_to_remove) foreach values $data->%*;
    }

    return $data;
}

sub compact ($data) {
    ref $data eq 'HASH'
        or return $data;

    while (my ($key, $value) = each $data->%*) {
        if (!defined $value || (__SUB__->($value), ref $value eq 'HASH' && $value->%* == 0)) {
            delete $data->{$key};
        }
    }

    return $data;
}

sub merge ($lhs, $rhs) {
    $lhs = dclone($lhs) if ref $lhs;
    $rhs = dclone($rhs) if ref $rhs;
    return merge_inplace_both($lhs, $rhs);
}

sub merge_inplace_left ($lhs, $rhs) {
    $rhs = dclone($rhs) if ref $rhs;
    return merge_inplace_both($lhs, $rhs);
}

sub merge_inplace_both ($lhs, $rhs) {
    return $rhs unless ref $lhs eq 'HASH' && ref $rhs eq 'HASH';

    while (my ($rkey, $rvalue) = each $rhs->%*) {
        $lhs->{$rkey} = merge_inplace_both($lhs->{$rkey}, $rvalue);
    }

    return $lhs;
}

1;

__END__
