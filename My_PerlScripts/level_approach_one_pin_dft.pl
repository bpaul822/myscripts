#!/usr/bin/perl
use strict;
use warnings;

my $COL_SIG_SI  ;  
my $COL_SIG_SE  ;
my $COL_SIG_SRST;
my $COL_SIG_SEXP;
my $COL_SIG_SCLK;
my $csv_file ;

my  $RST ;
my  $SE  ;
my  $SI  ;
my  $SEXP;
my  $SCLK; 
my  $case_variable ;
my  $line;

$csv_file = "./.csv";

$COL_SIG_SI  = 1;
$COL_SIG_SE  = 1;
$COL_SIG_SRST= 1;
$COL_SIG_SEXP= 2;
$COL_SIG_SCLK= 3;


if(-f "$csv_file")
{
    open (fp,"$csv_file") or die( "Can't open $csv_file for READING\n");
    open (VLOG,">test_pattern_onepin.txt") or die( "Can't open test_pattern_onepin for WRITING\n");
    while(<fp>)
    { chomp;
      $line =$_;
                @words=split(",",$line);
                $RST =$words[$COL_SIG_SRST];
                $SE  =$words[$COL_SIG_SE];
                $SI  =$words[$COL_SIG_SI];
                $SEXP=$words[$COL_SIG_SEXP];
                $SCLK=$words[$COL_SIG_SCLK]; 
                
                $case_variable = $RST . $SE . $SI . $SEXP  ; 
             
                  switch ($case_variable) {
                    case "0100"   {print VLOG"1100_0000_0000_0000_0000,\n" ;}#count 1,2,3
                    case "0101"   {print VLOG"1111_0000_0000_0000_0000,\n" ;}#count 4,5,6 
                    case "0110"   {print VLOG"1111_1111_0000_0000_0000,\n" ;}#count 7,8,9 
                    case "0111"   {print VLOG"1111_1111_1111_0000_0000,\n" ;}#count 10,11,12,13 
                    case "0000"   {print VLOG"1111_1111_1111_1111_0000,\n" ;}#count 14,15,16,17 
                    case "1000"   {print VLOG"1111_1111_1111_1111_1111,\n" ;}#count 18,19,20,21 
                  }
     }
}
		
