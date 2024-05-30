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

sub load_db_config ( $out_path, $path, $dsn_extractor ) {
    my %result;

    return \%result unless -r $path;

    my \%data = JSON()->decode( $path->slurp() )->{'database'};
    foreach my $handles ( values %data ) {
        foreach my $handle ( sort keys $handles->%* ) {
            my \%desc = $handles->{$handle};
            my ( undef, $dsn ) = $dsn_extractor->( $desc{'database'}, $handle );
            my \%dsn_props = $dsn->dsn_props;
            my $name       = "$desc{database}-$handle";
            my $scheme     = $dsn->dbi_driver;
            my $host       = $dsn_props{'bkng_resolved_host'} // $dsn_props{'host'};
            my $port       = $desc{'port'};
            my $user       = url_escape( $desc{'username'} );
            my $pass       = url_escape( $desc{'password'} );
            my $db         = url_escape( $dsn_props{'database'} );
            my %params     = (
                'defaults-extra-file' => "$out_path/$name.$scheme.defaults",
                'database'            => $dsn_props{'database'},
            );

            $params{'socket'} = $dsn_props{'mysql_socket'} if $dsn_props{'mysql_socket'};
            $params{'host'}   = $host                      if $host;
            $params{'port'}   = $port                      if $host && $port;

            $result{$name} = {
                'name'     => $name,
                'user'     => $desc{'username'},
                'pass'     => $desc{'password'},
                'url'      => { 'scheme' => $dsn->dbi_driver, 'params' => \%params },
                'defaults' => {
                    "${scheme}dump.defaults" => <<~"EO_MYSQLDUMP",
                    [client]
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
                    "$scheme.defaults" => <<~"EO_MYSQL",
                    [client]
                    user=$desc{'username'}
                    password=$desc{'password'}
                    EO_MYSQL
                },
            };

            for my $defaults ( sort keys $result{$name}{'defaults'}->%* ) {
                $out_path->child( sprintf( '%s.%s', $name, $defaults ) )
                    ->spurt( $result{$name}{'defaults'}{$defaults} );
            }
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
