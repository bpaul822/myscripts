#!/usr/bin/perl 
use strict;
use warnings;
my $y;
my $z;
my $design_name = $ARGV[0];
my $path = "reports/gates/$ARGV[0]_area_report";
open(FH1,"<$path")||die("File not found");
open(FH2,">>area_report.csv")||die("File not found");

while (<FH1>) {
  if($_=~m//){
  
  }

 
  if ($_=~m/\b$ARGV[0]\s+(\d+)\s+(\d+)\s+(\d+)/) {   
    print FH2 "$ARGV[0],";
    print FH2 " $2," ;
    # round off to one  places
    printf FH2 " %.f,", $2/.75;
  $z=`grep "Timing slack.*:.*-[0-9]" rc_logs/$ARGV[0].synth.log`;
   
  if(!$z){
    print FH2 "Design meets timing,\n" ;
  }    
  else{
    print FH2 "Design has timing violation,\n" ;
  }   
  
   
 }
}
close (FH1);
close (FH2);

