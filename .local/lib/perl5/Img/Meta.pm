package Img::Meta;

use v5.40;
use autodie;
use open ':locale';
use utf8;
use warnings     qw(FATAL utf8);
use experimental qw(class declared_refs defer refaliasing);

use Mojo::Template qw();

use Exporter qw(import);
our @EXPORT_OK = qw(
    xmp_render
);

use constant {
    'METADATA_TMPL_COORD' => <<~ 'EO_METADATA_COORD',
        % my %info = @_;
        <?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?>
        <x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.99'>
        <rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>

         <rdf:Description rdf:about=''
          xmlns:dc='http://purl.org/dc/elements/1.1/'>
          <dc:description>
           <rdf:Alt>
            <rdf:li xml:lang='x-default'><%= $info{description} // '' %></rdf:li>
           </rdf:Alt>
          </dc:description>
         </rdf:Description>
        % if ($info{location_lat} && $info{location_lon}) {

         <rdf:Description rdf:about=''
          xmlns:exif='http://ns.adobe.com/exif/1.0/'>
          <exif:GPSLatitude><%= $info{location_lat} %></exif:GPSLatitude>
          <exif:GPSLongitude><%= $info{location_lon} %></exif:GPSLongitude>
         </rdf:Description>
        % }

         <rdf:Description rdf:about=''
          xmlns:tiff='http://ns.adobe.com/tiff/1.0/'>
          <tiff:ImageDescription>
           <rdf:Alt>
            <rdf:li xml:lang='x-default'><%= $info{description} // '' %></rdf:li>
           </rdf:Alt>
          </tiff:ImageDescription>
         </rdf:Description>
        </rdf:RDF>
        </x:xmpmeta>
        <?xpacket end='w'?>
        EO_METADATA_COORD
};

use constant {'TMPL' => Mojo::Template->new};

sub xmp_render($payload_href) {
    my %payload = ($payload_href->%*);
    return TMPL()->render(METADATA_TMPL_COORD(), %payload);
}

__END__
