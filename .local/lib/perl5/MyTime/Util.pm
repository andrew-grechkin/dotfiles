package MyTime::Util;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Exporter qw(import);
our @EXPORT_OK = qw(
    from_string
    from_mysql_timestamp
    in_other_timezone
    now
    now_local
    overwrite_timezone
    timezone
);

use DateTime::TimeZone qw();
use Time::Moment       qw();

use constant {'DEFAULT_TIMEZONE_NAME' => 'Europe/Amsterdam'};
use constant {'DEFAULT_TIMEZONE'      => DateTime::TimeZone->new('name' => DEFAULT_TIMEZONE_NAME())};

sub timezone ($name) {
    return DateTime::TimeZone->new('name' => $name);
}

sub from_string ($str) {
    return Time::Moment->from_string($str, 'lenient' => 1);
}

sub from_mysql_timestamp ($ts, $zone = DEFAULT_TIMEZONE()) {
    my $tm = Time::Moment->from_string($ts . 'Z', 'lenient' => 1);
    return overwrite_timezone($tm, $zone);
}

sub now() {
    return Time::Moment->now_utc();
}

sub now_local() {
    return Time::Moment->now();
}

sub in_other_timezone ($tm, $zone) {
    $tm = Time::Moment->from_string($tm, 'lenient' => 1) unless $tm isa 'Time::Moment';
    my $offset = $zone->offset_for_datetime($tm) / 60;
    return $tm->with_offset_same_instant($offset);
}

sub overwrite_timezone ($tm, $zone) {
    $tm = Time::Moment->from_string($tm, 'lenient' => 1) unless $tm isa 'Time::Moment';
    my $offset = $zone->offset_for_local_datetime($tm) / 60;
    return $tm->with_offset_same_local($offset);
}

__END__
