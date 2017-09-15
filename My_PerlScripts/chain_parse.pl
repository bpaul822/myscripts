#!/usr/bin/perl
#This script used to check divergence in scan-chain in DFT
open(IN1,"<$ARGV[0]")||die("file not found");
#open(IN1,"<in")||die("file not found");
open(OUT,">diverg_output.csv");
open(OUT1,">skew_output.csv");

use strict;
use warnings;
my $i;
my $x;
$i =0;
my $flag;
my @muxwords;
my @begwords;
my @endwords;
my $old_line;
my $scan_mux;
my $scan_mux1;
my $scan_mux2;
my $gen_count =0;
my @scan_mux_concac;
my @lp_old_arr;
my @rev_lp_old_arr;
my @lp_arr;
my @rev_lp_arr;
my @cp_arr;
my @rev_cp_arr;
my @cppr_arr;
my @rev_cpp_arr;
my %begin_end_assoc_arr = ();
print OUT "Launch/Capture Scan Mux,No of crossings \n";

while($x=<IN1>)
{ chomp $x;

   $i++;
   if ($x =~ /Endpoint:.*/) {
       @endwords = split / /, $x;
       #print "$endwords[3] \n";
   } elsif ($x =~ /Beginpoint:.*/) {
       @begwords = split / /, $x;
       #print "$begwords[1] \n";
   } elsif ($x =~ /\/Q   ..DF/) { 
       #print "$x \n";
       #print "$old_line";
       @lp_old_arr = split ' ', $old_line;#split with anynumber of whitespae in b/w
       @rev_lp_old_arr = reverse @lp_old_arr;
       #print "cp_q dly $rev_lp_old_arr[2] \n";
       @lp_arr = split ' ', $x;#split with anynumber of whitespae in b/w
       @rev_lp_arr = reverse @lp_arr;
       #print "lp dbg $rev_lp_arr[2]\n";
   } elsif ($x =~ /\/CP   ..DF/) { 
       #print "$x \n";
       @cp_arr = split ' ', $x;#split with anynumber of whitespae in b/w
       @rev_cp_arr = reverse @cp_arr;
       #print "cp dbg $rev_cp_arr[2]\n";
   } elsif ($x =~ /CPPR Adjustment/) { 
       @cppr_arr = split ' ', $x;#split with anynumber of whitespae in b/w
       @rev_cpp_arr = reverse @cppr_arr;
       #print "cppr is $rev_cpp_arr[0]\n";
   } elsif ($x =~ /Generated on.*/) { 
       $gen_count++;
       $flag = 1;
       if($gen_count > 1){
          #print "$x \n";
          my $conc_end_beg = $endwords[3] . $begwords[1];
          my $conc_muxl_muxc = $scan_mux1 . $scan_mux2;
          #adding more values to the same key could be achieved using conactination of individual values 
          #$begin_end_assoc_arr{$conc_end_beg} = (abs($rev_cp_arr[2] - $rev_lp_old_arr[2]) - $rev_cpp_arr[0]) . "append_value"; 
          print "dbg capture clk lat $rev_cp_arr[2]:launch clk lat $rev_lp_old_arr[2]: cppr of the path $rev_cpp_arr[0]\n";
          #$begin_end_assoc_arr{$conc_end_beg} = (abs($rev_cp_arr[2] -  $rev_lp_old_arr[2]) - $rev_cpp_arr[0]); 
          $begin_end_assoc_arr{$conc_end_beg} = ($rev_cp_arr[2] -  $rev_lp_old_arr[2] - $rev_cpp_arr[0]); 
          push @scan_mux_concac,$conc_muxl_muxc;
          #print "my key is $conc_end_beg \n"; 
          #print "my value is $begin_end_assoc_arr{$conc_end_beg} \n"; 
       }
   } elsif ($x =~ /Other End Path.*/) {
       #print "$x \n";
       $flag = 2;
   } 
   else {
     if ($x =~ /scan_mux/) {
       $scan_mux = $x;
       @muxwords = split / /, $x;
          if ($flag == 1) {
            $scan_mux1 = $muxwords[6];
          #print "first mux is $scan_mux1\n";
          }
          else {
            $scan_mux2 = $muxwords[6];
          #print "second mux is $scan_mux2\n";
          }
     }
   }
     if($flag == 1){
     $old_line = $x;}
}

my $val;
foreach $val (keys %begin_end_assoc_arr)
{print OUT1 "$val,$begin_end_assoc_arr{$val} \n";
}

my $val1;
my $val2;
my $count;
foreach $val1 (@scan_mux_concac){
  $count = 0;
     foreach $val2 (@scan_mux_concac){
       if($val1 eq $val2) {
        $count++;}
      }
      print OUT "$val1,$count \n";
}

`sort -u diverg_output.csv -o diverg_output.csv`;
`sort -k2n -t','  diverg_output.csv -o diverg_output.csv`;
`sort -k2n -t','  skew_output.csv -o skew_output.csv`;
#print OUT1 "Beginpoint_Endpoint,Skew\n";
`sed  -i '1i Beginpoint_Endpoint,Skew\n' skew_output.csv`;
foreach $val (@scan_mux_concac)
{#print "$val \n";
}
