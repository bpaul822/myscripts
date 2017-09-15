#!/usr/bin/perl
#`rm output.csv`;
#`egrep "Beginpoint:|Endpoint:|*scan_mux*" ppb_hmaster_reg_timing_rep | awk '{print $1 $2}' > test1000` ;

#open(IN1,"<nvic_being_end_scan_mux_f")||die("file not found");
open(IN1,"<ppb_hmaster_reg_timing_rep_mux_f")||die("file not found");
#open(IN1,"<1000")||die("file not found");
open(OUT,">>output");
use strict;
use warnings;
my $i;
my $x;
$i =0;
my $end;
my $begin;

while($x=<IN1>)
{ chomp $x;

$i++;
if ($x =~ /Endpoint.*/) {
#u  print "$x my end\n";
  $end = $x; 
#  print "dbg $i, $end \n";
} elsif ($x =~ /Beginpoint.*/) {
 #u print "$x my begin\n";
  $begin = $x;
#  print "dbg $i, $begin \n";
} else {
   if ($i == 3) {
     print "$begin $x\n";
     #print "dbg $i \n";
   }
   if ($i == 4) {
     print "$end $x\n";
#     print "dbg $i \n";
     $i =0;
   print "\n";
   }
  #print "print $x my mux\n";
}

}

print OUT "\n\n";
