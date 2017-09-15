#!/usr/bin/perl
#`rm output.csv`;
open(IN1,"<log1.log")||die("file not found");
open(OUT,">>output");

$i =1;

while($x=<IN1>)
{ chomp($x);
  if($i % 2 != 0)
  {
    $old_line = $x;
    #print "$i \n";
  }
  else { 
    #print "$old_line \n";
    #print "$x \n";
    #if ($old_line =~ /$x/)
  #{
    #print "$old_line";
    print "set_false_path -from $x -to $old_line ";
    print "\n";
  #}
  }

$i++;
}

#print OUT "\n\n";
