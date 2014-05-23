#!/usr/bin/perl -w
#JMD(11.10.2013): merge boards.txt into zorro.ids
use strict;
use Data::Dumper;
use Getopt::Std;

my %O = ( 'd' => 0 );
getopts("d",\%O);

my %boards = ();
my %zorro = ();
my %name = ();
my $product;
my $product_name;
my $manufacturer;
my $manufacturer_name;

# read boards.txt
open( BOARDS, "boards.txt" ) || die "can't open boards.txt file: $!";
while(<BOARDS>) {
    print if($O{'d'});
    if(/^Manufacturer (\d+):\s*(.*\S)/) {
	$manufacturer = sprintf("%04x",$1);
	$manufacturer_name = $2;
	$name{$manufacturer} = $manufacturer_name;
	print "found: manufacturer=$manufacturer manufacturer_name=$manufacturer_name\n" if($O{'d'});
    }
    if(/^\s+\d+: (.*\w)\s+ID: (\d+)/) {
	$product_name = $1;
	$product = sprintf("%04x",$2);
	$product =~ s/(..)(..)/$2$1/;
	$boards{$manufacturer}{$product} = $product_name;
	print "found: manufacturer=$manufacturer product=$product product_name=$product_name\n" if($O{'d'});
    }
}
close(BOARDS);

print Dumper(\%boards) if($O{'d'});

# read zorro.ids

# create new keys
foreach my $m (sort keys %boards) {
    foreach my $p (sort keys %{$boards{$m}}) {
	if(!defined($zorro{$m}{$p})) {
	    $zorro{$m}{$p} = $boards{$m}{$p};
	}
    }
}

# create new zorro.ids
foreach my $m (sort keys %zorro) {
    print "$m  $name{$m}\n";
    foreach my $p (sort keys %{$zorro{$m}}) {
	print "        $p  $zorro{$m}{$p}\n";
    }
}
