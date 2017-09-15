#!/usr/bin/perl
#`rm output.csv`;
#step 1
#`egrep "Beginpoint:|Endpoint:|*scan_mux*" ppb_hmaster_reg_timing_rep | awk '{print $1 $2}' > test1000` ;
#egrep "Beginpoint:|Endpoint:|*scan_mux*|*clk_mux*" richarson_aon_fix_rep | awk '{print $1 $2}' 
#step 2 use this script to figure out path 
print "input file is $ARGV[0]";

#open(IN1,"<nvic_being_end_scan_mux_f")||die("file not found");
open(IN1,"<$ARGV[0]")||die("file not found");
open(OUT,">>output");
use strict;
use warnings;
my $i;
my $x;
$i =0;
my $end;
my $begin;
my $mux_l;
my $mux_c;

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
         if ($x =~ /scan_mux/) {
             if ($i == 3) {
               $mux_l = $x;
               print "$begin $x\n";
               #print "dbg $i \n";
             }
             if ($i == 4) {
               $i =0;
               $mux_c = $x;
               if($mux_l ne $mux_c){
                 print "Divergent crossing @ $begin $end $mux_l $mux_c \n";
               }
               print "$end $x\n";
               print "\n";
             }
        }
 }
#initialize i to 0 incase there are no scan muxes in the path
   if ($i == 4) {
     $i =0;
   }
}

print OUT "\n\n";
