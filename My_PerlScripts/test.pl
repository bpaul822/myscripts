#!/usr/bin/perl 
use strict;
use warnings;
my $verilogfiles;
`rm area_report.csv`;
open(FH1,"<$ARGV[0]")||die("File not found");
open(FH2,">>area_report.csv")||die("File not found");
print FH2 "Block name: ,Synth area ,PD overheard(=raw area/.75),Comments\n";

while ($verilogfiles=<FH1>) {
  if($verilogfiles=~/(\w*).v\b/)
   {
      `./extract_area.pl  $1` ;
        printf STDOUT "calling area extract function  with $1\n";
   }
}

close FH2;
