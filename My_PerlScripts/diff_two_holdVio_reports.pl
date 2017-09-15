


#!/usr/bin/perl

$in1 = $ARGV[0];
$in2 = $ARGV[1];

open (IN1, "<$in1") || die "Cannot open file for reading!!";
open (IN2, "<$in2") || die "Cannot open file for reading!!";
open (OUT1, ">unique_common_failing_flops.list") || die "Cannot open file for writing!!";
open (OUT2, ">unique_failures_in_file1.list") || die "Cannot open file for writing!!";
open (OUT3, ">unique_failures_in_file2.list") || die "Cannot open file for writing!!";

@lines1 = <IN1>;
@lines2 = <IN2>;

close (IN1);
close (IN2);

$flag1 = 0;
$flag2 = 0;

foreach $line1 (@lines1)
{

	@flop1 = split (' ', $line1);
	foreach $line2 (@lines2)
	{
	
		@flop2 = split (' ', $line2);
		if ($flop1[0] eq $flop2[0])
		{
		
			print OUT1 $line1;
			$flag1 = 1;
			last;
			
		}
		$flag1 = 0;
										
	}
	if ($flag1 == 0)
	{
	
		print OUT2 $line1;
		
	}
	
}

close (OUT2);

foreach $line2 (@lines2)
{

	@flop2 = split (' ', $line2);
	foreach $line1 (@lines1)
	{
	
		@flop1 = split (' ', $line1);
		if($flop2[0] eq $flop1[0])
		{
			
			$flag2 = 1;
			last;
			
		}
		$flag2 = 0;
						
	}
	if ($flag2 == 0)
	{
	
		print OUT3 $line2;
		
	}
	
}

close (OUT3);




#EOF


			
			
		
			
