#!/usr/bin/perl
# -------------------------------------------------------------------------------------------------
# Filename      : one_pin_dft.pl
# Author        : Bibin Paul
# Created On    : 2014-10-14 11:14
# -------------------------------------------------------------------------------------------------
use strict;
use warnings;
use Switch;

my $COL_SIG_SI  ;  
my $COL_SIG_SE  ;
my $COL_SIG_SRST;
my $COL_SIG_SEXP;
my $COL_SIG_SCLK;
my $csv_file ;
my @words;
my $line_index ;

my  $RST ;
my  $SE  ;
my  $SI  ;
my  $SEXP;
my  $SCLK; 
my  $case_variable ;
my  $case_variable0 ;
my  $case_variable1 ;
my  $line;
my  $COL_SIG_TIM0 ;
my  $COL_SIG_TIM1 ;
my  $SO_pos;
my  $SO_neg;

#cat mahesh_pos_neg.txt | awk '{print $3" "$4" "$5" "$6" "$7}' | tee filt_mahesh_pos_neg.txt
$csv_file = "./mahesh.csv";

$line_index = 0;

$COL_SIG_TIM0 = 0;
$COL_SIG_TIM1 = 1;
$COL_SIG_SCLK = 2;
$COL_SIG_SE   = 3;
$COL_SIG_SI   = 4;
$COL_SIG_SEXP = 5;
$COL_SIG_SRST = 6;


        if(-f "$csv_file")
        {
            open (FIP,"<$csv_file") or die( "Can't open $csv_file for READING\n");
            open (VLOG,">test_pattern_onepin.txt") or die( "Can't open test_pattern_onepin for WRITING\n");
            #todo self reset in tb
            #todo intilization from tb 
            while(<FIP>)
            { chomp;
              $line =$_;
                        $line_index = $line_index +1;
                        @words=split(" ",$line);
                        $RST =$words[$COL_SIG_SRST];
                        $SE  =$words[$COL_SIG_SE];
                        $SI  =$words[$COL_SIG_SI];
                        $SEXP=$words[$COL_SIG_SEXP];
                        $SCLK=$words[$COL_SIG_SCLK]; 
                        #print "Scan Reset: $RST,Scan Enable: $SE,Scan input: $SI,Scan output: $SEXP:\n"; 
                       
                        ############check block####################
                        if($SCLK eq  1)    {$case_variable1= $RST.$SE.$SI.$SEXP  ;$SO_pos = $SEXP;}  
                        elsif($SCLK eq 0)  {$case_variable0= $RST.$SE.$SI.$SEXP  ;$SO_neg = $SEXP;} 
                        if($case_variable0 ne $case_variable1){
                          if($line_index % 2 == 0){ #even no line
                            #print "posedge rst,se si sexp $case_variable1  and"; 
                            print "Warning: negdge $case_variable0  not equal for line $line_index at time $words[$COL_SIG_TIM0]\n";
                            chop($case_variable0); #remove SEXP
                            chop($case_variable1); #remove SEXP
                           #print " hellow wordl $case_variable0 seperator $case_variable1"; 
                            if($case_variable0 ne $case_variable1){
                              print "Error: more than 1 bit diff at line $line_index ie: notonly SO,there are other signals changing at pos & negedge Ignore if the previous pattern was RST\n"
                            }
                           } 
                          elsif($SO_pos ne $SO_neg){ #odd no line Note this can happen when scan enable is 0
                            print"Info: SO in current posedge is not retained from previous 
                            #negedge cycle at line $line_index, so can have isssu if we ignore the negedge pattern\n";
                          } 
                            #print "Debug line_index is odd $line_index";
                        }
                        ############check block####################
                        $case_variable = $RST.$SE.$SI.$SEXP  ; 
                     
          if($SCLK eq 1){    
                          ######pat gen block##########
                          switch ($case_variable) {
                            case "1100"   {print VLOG"1000_0000_0000_0000_0000\n" ;}#count 1 shift_in 
                            case "1101"   {print VLOG"1010_0000_0000_0000_0000\n" ;}#count 2 shift_in
                            case "1110"   {print VLOG"1010_1000_0000_0000_0000\n" ;}#count 3 shift_in
                            case "1111"   {print VLOG"1010_1010_0000_0000_0000\n" ;}#count 4 shift_in
                            case "1000"   {print VLOG"1010_1010_1000_0000_0000\n" ;}#count 5 capture 
                            case "101x"   {print VLOG"1010_1010_1010_0000_0000\n" ;}#count 6 mask SI 1
                            case "100x"   {print VLOG"1010_1010_1010_1000_0000\n" ;}#count 7 mask SI 0
                            else {
                                if($RST eq  0){ 
                                  #case "0???"  print VLOG"1010_1010_1010_1010_0000\n" ;#count 8 scan reset 
                                  #print "Default case with reset 0\n";
                                  print VLOG"1010_1010_1010_1010_0000\n" ;#count 8 scan reset 
                                }
                                elsif($SE eq  0){ 
                                  #case "0???"  print VLOG"1010_1010_1000_0000_0000\n" ;#count 5 capture 
                                  #print "Default case with SE 0\n";
                                  print VLOG"1010_1010_1000_0000_0000\n" ;#count 5 capture 
                                }
                                elsif($SEXP  eq  'x'){ 
                                    if($SI eq 1) {
                                      #print "default case with mask 1";
                                      print VLOG"1010_1010_1010_0000_0000\n" ;}#count 6 mask SI 1
                                    elsif($SI eq 0) {
                                      #print "default case with mask 0";
                                      print VLOG"1010_1010_1010_1000_0000\n" ;}#count 7 mask SI 0
                                    else{
                                      #tocheck 15000.00 ps  x  1  x  x  1
                                      #tocheck 30000.00 ps  0  1  x  x  1
                                      print "SI might be x $SI in line $line_index\n";
                                      print VLOG"1010_1010_1010_0000_0000\n" ;}#count 6 mask SI 1
                                }
                                  
                                elsif($SI eq 'x' & $SEXP eq '0' & $SE eq '1' & $RST eq '1'){ # count 3 
                                   #note that this pattern is after applying scan reset 
                                   print VLOG"1010_1000_0000_0000_0000\n" ;#count 3 shift_in
                                   print "test mahesh$line_index\n";
                                  }
                                else{
                                  print "Error and check the pattern line no: $line_index"; 
                                  print "Scan Reset: $RST,Scan Enable: $SE,Scan input: $SI,Scan output: $SEXP:\n";}
                              }  
                                #print "Default case with SE 0\n";
                         }

                          ######pat gen block##########
                    }
            elsif($SCLK eq 0) {
                                    if($SEXP eq 1) {
                                      #print "default case with mask 1";
                                      print VLOG"1010_1010_1010_1010_1010\n" ;
                                     }#count 10  mask SEXP 1
                                    elsif($SEXP eq 0) {
                                      #print "default case with mask 0";
                                      print VLOG"1010_1010_1010_1010_10101\n" ;
                                    }#count 11  mask SEXP 0
                                    else{
                                      #SE might be x
                                      #print "SEXP  might be x $SEXP in line $line_index\n";
                                      if($SE eq 0){
                                      print VLOG"1010_1010_1010_1010_1010101\n" ;
                                      }
                                      else {
                                        if($SE eq 'x') {print "check_point: SE is x\n";}
                                      print VLOG"1010_1010_1010_1010_101010101\n" ;}
                                    }#count  mask SEXP 1
                             }
            else {print "Error :clk equal x\n";}
    }
}   
                            #read out command
                            #todo read out command not requd for testonly mode ie: 0 
                            print VLOG"1010_1010_1010_1010_1000\n" ;#count 9
                            #todo self reset in tb
close (FIP);
close (VLOG);
		
