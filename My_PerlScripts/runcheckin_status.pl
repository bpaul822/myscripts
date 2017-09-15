#!/usr/bin/perl 
#Created by Bibin Paul:bibin@cadence.com
use strict;
use warnings;
`rm output.csv`;
my $verilogfiles;
my $author;
my $x;
my $y;
my $z;
my $v;
my $design_name;
my $i=1;
my $vlog_rev;
my $sdc_rev;
my $conf_rev;
my $def_rev;
my $log;

`svn up constraints/lef_io_fp/*`;

open(FH1,"<$ARGV[0]")||die("File not found");
open(OUT,">>output.csv");
#.v file ,sdc,conf and def are to be handed to pdteam
print OUT "sl.no,block,rc2enc_vlog_rev,rc2enc_sdc_rev,rc2enc_conf_rev,def_rev\n";


#data_tx_dig._default_constraint_mode_.sdc
while ($verilogfiles=<FH1>) {
    if($verilogfiles=~/(\w*).v\b/){
          $design_name = $1;  
          printf STDOUT "Processing the data of $design_name to xls file\n";
#                   printf "########$design_name is being processed ########\n";  
                    $x=  `svn status -u rc2enc/${design_name}_enc/${design_name}.v`;
                    $log=  `svn log rc2enc/${design_name}_enc/${design_name}.v`; 
                    if($x=~/(\bM\b(\s*)(\d*))|(\bC\b(\s*)(\d*))|(!(\s*)(\d*))/) {
                      $vlog_rev ="Error";
                      printf "$design_name log is not not checked in or not existing or conflict\n";
                     }
                    else{
                          
                    if($log=~/r(\d+).*?\|(.*?)\|/){
                      $vlog_rev =$1;
                      $author =$2;
                      printf "The author of verilog  file is $author and revision no is $vlog_rev\n";
                    }
                    }
                    
                    $y=`svn status -u  rc2enc/${design_name}_enc/${design_name}._default_constraint_mode_.sdc`;
                    $log=  `svn log rc2enc/${design_name}_enc/${design_name}._default_constraint_mode_.sdc`;
                    if($y=~/(\bM\b(\s*)(\d*))|(\bC\b(\s*)(\d*))|(!(\s*)(\d*))/) {
                       $sdc_rev ="Error";
                       printf "$design_name sdc is not not checked in or not existing or conflict\n";
                        }
                    else{ 
                     
                     if($log=~/r(\d+).*?\|(.*?)\|/){
                      $sdc_rev =$1;
                      $author =$2;
                      printf "The author of sdc file is $author and revision no is $sdc_rev\n";
                    } 
                    }
                    
                    $z= `svn status -u rc2enc/${design_name}_enc/${design_name}.conf`;
                    $log=  `svn log rc2enc/${design_name}_enc/${design_name}.conf`;
                     if($y=~/(\bM\b(\s*)(\d*))|(\bC\b(\s*)(\d*))|(!(\s*)(\d*))/){
                      $conf_rev ="Error";
                      printf "$design_name conf is not not checked in or not existing or conflict\n";
                     }
                    else{ 
                      if($log=~/r(\d+).*?\|(.*?)\|/){
                      $conf_rev =$1;
                      $author =$2;
                      printf "The author of conf file is $author and revision no is $conf_rev\n";
                    } 
 
                    }
                 my $temp;
                    $design_name=~/(\w+)_scan/; 
                    $temp = $1; 
                    $v= `svn status -u constraints/lef_io_fp/${temp}.def`;
                    $log=  `svn log    constraints/lef_io_fp/${temp}.def`;
                    if($v=~/(\bM\b(\s*)(\d*))|(\bC\b(\s*)(\d*))|(!(\s*)(\d*))/){
                      $def_rev ="Error";
                      printf "$design_name def is not not checked in or not existing or conflict\n";
                     }
                    else{
                    if($log=~/r(\d+).*?\|(.*?)\|/){
                      $def_rev =$1;
                      $author =$2;
                      printf "The author of def file is $author and revision no is $def_rev\n";
                    }                                                                                                                                                                                
 
                    }
        print OUT "$i,$design_name,$vlog_rev,$sdc_rev,$conf_rev,$def_rev\n";
        $i=$i+1; 
       
         }
}
print "output file: output.csv is successfully created\n";
close(FH1);
close(OUT);
