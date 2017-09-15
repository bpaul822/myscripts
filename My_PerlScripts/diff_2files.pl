#!/usr/bin/perl
#run command
#perl chain_parse.pl file2 file1

#content of file1 
##bibin 
##test

#content of fil2
##bibin 10
##paul  5
##dino  15
##quillo 55
##test  20

#diff outputt is 
##paul  5
##dino  15
##quillo  55


use strict;
use warnings;

my $in1 = $ARGV[0];
my $in2 = $ARGV[1];
my @lines1;
my @lines2;
my $val1;
my $val2;
my $count;
my @split_words;
my @split_words1;

open (IN1, "<$in1") || die( "Cannot open file for reading!!");
open (IN2, "<$in2") || die( "Cannot open file for reading!!");
#open (OUT,">diverg_output.csv");

@lines1 = <IN1>;
@lines2 = <IN2>;

close (IN1);
close (IN2);
my $diff_flag;

foreach $val1 (@lines1){
  @split_words = split ' ', $val1;#split with anynumber of whitespae in b/w
  $diff_flag = 0;
  #print "File one first word $split_words[0]\n";
    foreach $val2 (@lines2){
      @split_words1 = split ' ', $val2;
      #print "File 2 first word $split_words1[0]\n";
      if($split_words[0] eq $split_words1[0]) {
        $diff_flag = 1;
      }
    }
    if($diff_flag == 0) {
      print "$split_words[0]  $split_words[1]\n"
    }
}

