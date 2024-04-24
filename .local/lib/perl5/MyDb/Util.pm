package MyDb::Util;

use v5.36;
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(builtin declared_refs defer for_list refaliasing try);

use JSON::PP qw();

use Mojo::Util qw(url_escape);

use constant {
    'JSON'          => JSON::PP->new->pretty->space_before(0)->canonical->utf8(1),
    'JSON_ONE_LINE' => JSON::PP->new->pretty->space_before(0)->canonical->utf8(1)->indent(0),
};

use Exporter qw(import);
our @EXPORT_OK = qw(
    load_connections
    load_db_config
    save_connections
);

sub load_db_config ( $path, $dsn_extractor ) {
    my %result;

    return \%result unless -r $path;

    my \%data = JSON()->decode( $path->slurp() )->{'database'};
    foreach my $handles ( values %data ) {
        foreach my $handle ( sort keys $handles->%* ) {
            my \%desc = $handles->{$handle};
            my ( undef, $dsn ) = $dsn_extractor->( $desc{'database'}, $handle );
            my \%dsn_props = $dsn->dsn_props;
            my $name       = "$desc{database}-$handle";
            my $host       = $dsn_props{'bkng_resolved_host'} // $dsn_props{'host'};
            my $port       = $desc{'port'}                    // '3306';
            my $user       = url_escape( $desc{'username'} );
            my $pass       = url_escape( $desc{'password'} );
            my $db         = url_escape( $dsn_props{'database'} );
            $result{$name} = {
                'name'           => $name,
                'host'           => $host,
                'port'           => $port,
                'user'           => $desc{'username'},
                'pass'           => $desc{'password'},
                'db'             => $dsn_props{'database'},
                'url'            => "mysql://$user:$pass\@$host:$port/$db",
                'exec-mysqldump' => <<~"EO_MYSQLDUMP",
                [client]
                host=$host
                port=$port
                user=$desc{'username'}
                password=$desc{'password'}
                complete-insert
                disable-keys
                extended-insert
                insert-ignore
                no-create-db
                no-create-info
                no-tablespaces
                set-gtid-purged=OFF
                skip-add-locks
                skip-column-statistics
                skip-lock-tables
                ssl-fips-mode=ON
                compact
                EO_MYSQLDUMP
                'exec-mysql' => <<~"EO_MYSQL",
                [client]
                host=$host
                port=$port
                user=$desc{'username'}
                password=$desc{'password'}
                EO_MYSQL
            };
        }
    }

    return \%result;
}

sub load_connections ($path) {
    my \@data = JSON()->decode( $path->slurp() );

    return \@data;
}

sub save_connections ( $path, $data_aref ) {
    $path->dirname->make_path;
    $path->spurt( JSON()->encode($data_aref) );
    return;
}

__END__
