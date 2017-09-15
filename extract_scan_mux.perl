#!/usr/bin/perl
#`rm output.csv`;
open(IN1,"<log1.log")||die("file not found");
open(OUT1,">>output1");
open(OUT2,">>output2");

$i =0;
$scan_mux_var = "scan_mux";
$generated_var = "Cadence";
$hash_var = "#";
while($x=<IN1>)
{ chomp;

 # this part can be used to extract the scan mux 
    if ($x =~ /$scan_mux_var/) {
    print "$x";
    }

    if ($x =~ /$generated_var/) {
    print "$x";
    }
 # this part can be used to extract the scan mux 
#   if ($x =~ /$hash_var/) {
#    #if ($i == 1) {
#    #  print OUT2 "blank \n"; # print to file 2 
#    #}
#      $i =0;
#      print "$x";
#    }
#
#    if ($i == 1) {
#      print OUT1 "$x"; # print to file 1 
#    }
#    
#    if ($i == 2) {
#      print OUT2 "$x"; # print to file 2 
#    }
$i++;
}

