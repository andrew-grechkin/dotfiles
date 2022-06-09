package MyHash::Util;

use v5.36;
use utf8;
use warnings 'FATAL' => qw(utf8);
use experimental qw(builtin declared_refs defer for_list isa re_strict refaliasing try);

use Storable qw(dclone);

use Exporter qw(import);
our @EXPORT_OK = qw(
    build_data_cache
    build_reverse_indices
    compact
    clean_hash_from_key
    merge
    merge_inplace_left
    merge_inplace_both
);

sub build_data_cache ($hash_ref, %caches) {
    my %result;

    while (my ($cache_name, $value_extractor) = each %caches) {
        foreach my $key (keys $hash_ref->%*) {
            $result{$cache_name}{$key} = $value_extractor->($hash_ref->{$key}) // 'undef';
        }
    }

    return \%result;
}

sub build_reverse_indices ($hash_ref, %indices) {
    my %result;

    while (my ($index_name, $id_extractor) = each %indices) {
        foreach my $key (keys $hash_ref->%*) {
            my $id = $id_extractor->($hash_ref->{$key}) // 'undef';
            undef $result{$index_name}{$id}{$key};
        }
    }

    return \%result;
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

sub clean_hash_from_key ($data, $key_to_remove) {
    if (ref $data eq 'ARRAY') {
        __SUB__->($_, $key_to_remove) foreach $data->@*;
    } elsif (ref $data eq 'HASH' || (ref $data) =~ m/::/) {
        delete $data->{$key_to_remove};
        __SUB__->($_, $key_to_remove) foreach values $data->%*;
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
    return $rhs if !(ref $lhs eq 'HASH' && ref $rhs eq 'HASH');

    while (my ($key, $value) = each $rhs->%*) {
        $lhs->{$key} = merge_inplace_both($lhs->{$key}, $value);
    }

    return $lhs;
}

1;

__END__
