package MyDb::Util;

use v5.36;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(declared_refs defer refaliasing signatures);

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

sub load_db_config ($out_path, $path, $dsn_extractor) {
    my %result;

    return \%result unless -r $path;

    my \%data = JSON()->decode($path->slurp())->{'database'};
    foreach my $handles (values %data) {
        foreach my $handle (sort keys $handles->%*) {
            my \%desc = $handles->{$handle};
            my (undef, $dsn) = $dsn_extractor->($desc{'database'}, $handle);
            my \%dsn_props = $dsn->dsn_props;
            my $name       = "$desc{database}-$handle";
            my $scheme     = $dsn->dbi_driver;
            my %params     = (
                'defaults-extra-file' => "$out_path/$name.$scheme.defaults",
                'database'            => url_escape($dsn_props{'database'}),
            );

            if ($dsn_props{'mysql_socket'}) {
                $params{'socket'} = $dsn_props{'mysql_socket'};
            } else {
                my $host = $dsn_props{'bkng_resolved_host'} // $dsn_props{'host'};
                my $port = $desc{'port'};

                $params{'host'} = $host if $host;
                $params{'port'} = $port if $host && $port;
            }

            $result{$name} = {
                'name'     => $name,
                'user'     => url_escape($desc{'username'}),
                'password' => url_escape($desc{'password'}),
                'url'      => {'scheme' => $dsn->dbi_driver, 'params' => \%params},
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
                        no-tablespaces
                        set-gtid-purged=OFF
                        skip-add-locks
                        skip-column-statistics
                        skip-extended-insert
                        skip-lock-tables
                        compact
                        EO_MYSQLDUMP
                    "$scheme.defaults" => <<~"EO_MYSQL",
                        [client]
                        user=$desc{'username'}
                        password=$desc{'password'}
                        EO_MYSQL
                },
            };

            for my $defaults (sort keys $result{$name}{'defaults'}->%*) {
                $out_path->child(sprintf('%s.%s', $name, $defaults))
                    ->spurt($result{$name}{'defaults'}{$defaults});
            }
        }
    }

    return \%result;
}

sub load_connections ($path) {
    my \@data = JSON()->decode($path->slurp());

    return \@data;
}

sub save_connections ($path, $data_aref) {
    $path->dirname->make_path;
    $path->spurt(JSON()->encode($data_aref));

    return;
}

__END__
