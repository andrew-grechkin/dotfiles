use v5.40;
use experimental qw(class declared_refs defer refaliasing);

class BTQueue::Config {
    use File::Spec qw();

    field $foreground : reader : param = false;
    field $config_dir : param : reader;
    field $runtime_dir : param : reader;
    field $temp_dir : param : reader;

    field $socket_path : reader;

    ADJUST {
        $socket_path = File::Spec->catfile($runtime_dir, 'btq.sock');
        $temp_dir    = File::Spec->catfile($temp_dir,    'btq');

        try {
            mkdir $temp_dir
                or die sprintf("unable to create a temp dir ([%d] %s): %s\n", int($!), $!, $temp_dir);
        } catch ($err) {
            ## temp dir is already there, all good;
        }

        return $self;
    }
}

__END__
