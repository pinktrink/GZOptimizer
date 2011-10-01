#!/usr/bin/perl -w
#This goes in the apache preprocessing stack before the gzip handler. I currently have no friggin idea how to do this, because I suck.
#This will optimize the html for better gzip compression.

use strict;
use warnings;

my $data = '';
my %replace;

while(<>){
	$data .= $_;
}

while($data =~ m/<[^?]([a-z-]+)\s*(.*?)(\/?>)/ig){
	my $tag = $1;
	my $tags = $2;
	my $end = $3;
	my $full = $&;
	my (%attrs, $fulltag);
	
	$end = ' />' if $end eq '/>';
	
	while($tags =~ m/([a-z-:]+)(?:=((['"]?).*?\3))?/ig){
		my $attr = $1;
		my $value = $2;
		
		$value = "=$value" if defined $value;
		
		$attrs{$attr} = $value;
		
		undef $attr;
		undef $value;
	}
	
	$fulltag = "<$tag";
	foreach my $key (sort keys %attrs){
		$fulltag .= " $key" . $attrs{$key};
	}
	$fulltag .= $end;
	
	$replace{$full} = $fulltag;
}

while (my ($k, $v) = each %replace){
	$data =~ s/$k/$v/;
}

print $data;

__END__
GOOD JOB!
