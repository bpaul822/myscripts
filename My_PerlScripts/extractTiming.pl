#!/usr/bin/perl
#
# Extracts hold viol data from all_dr_violations.rep
#I have modified extractTiming.pl script to populate the STA RC corner, TNS, No of violations, WNS in all the modes.(Scan shift, Capture, functional)
#You can run by  using 
#perl extractTiming.pl <STA path till rep>   > test.csv
#Eg:perl extractTiming.pl /net/adsntap.adsdesign.analog.com/wilm_cicpi5/muska/ggrant/sos_ggrant/dig_impl/muska/sta/rep.tapeout.new_corners > output.csv
#  (Script path: /proj/muska/bpaul/sos_bpaul/dig_impl/muska/atpg_Cortex_only_hold_viol_fsf_masked_dyn_alone_dyn_coverage_debug_itr2/run)
#perl extractTiming.pl /net/adsntap.adsdesign.analog.com/wilm_cicpi5/muska/ggrant/sos_ggrant/dig_impl/muska/sta/rep.tapeout.new_corners/scan_shift_fsf_m3cv_125_rcworst/drv.all_viol.rep min

my $all_files_in_dir = 0;
my $dirname;
my $filename;
my $item;
my $delay_global;

#$all_files_in_dir = `ls /net/adsntap.adsdesign.analog.com/wilm_cicpi5/muska/ggrant/sos_ggrant/dig_impl/muska/sta/rep.tapeout.new_corners/func*/drv.all_viol.rep -d | sort` ;

$all_files_in_dir = `ls $ARGV[0]/*/drv.all_viol.rep -d | sort` ;


#print "test is $all_files_in_dir\n";
my @words = split /\n/, $all_files_in_dir;
#print "test array is  @words";
#print "test array is  $words[1]";

#print "Hold violations in this database\n" ;
foreach $item (@words){
  Hello($item,min);
           }
print "\n\n\n";
#print "Setup violations in this database\n" ;
foreach $item (@words){
  Hello($item,max);
           }

sub Hello {
#my $viol_in   = $ARGV[0];
#my $delay     = $ARGV[1];

my $viol_in   = $_[0];
my $delay     = $_[1];
my $delay_global     = $_[1];

my $func_out  = "$viol_in\.func.$delay";
my $scans_out = "$viol_in\.scan_shift.$delay";
my $scanc_out = "$viol_in\.scan_capture.$delay";
my @words = split /\//, $viol_in;
my @rev_words = reverse @words;
my $scans_mode = 0;
my $scanc_mode = 0;
my $func_mode = 0;


#print "test @words";

#print "$rev_words[2]/";
#print "$rev_words[1]\n";

if ($rev_words[1] =~ /scan_shift.*/) {
  $scans_mode = 1; 
  #print " amazing $rev_words[2]\n";
}

if ($rev_words[1] =~ /scan_cap.*/) {
  $scanc_mode = 1; 
  #print " amazing $rev_words[2]\n";
}
  
if ($rev_words[1] =~ /func.*/) {
  $func_mode = 1; 
  #print " amazing $rev_words[2]\n";
}

#print "$ARGV[0]\n";
$stop = "max";

if ($delay eq "max") {
  $stop = "min";
}

# Setup hashes
my %func_slack = ();
my %scans_slack = ();
my %scanc_slack = ();

open (VIOLS, $viol_in);

open (FUNC_OUT, ">$func_out");
open (SCANS_OUT, ">$scans_out");
open (SCANC_OUT, ">$scanc_out");

my $dump = 0;

while (<VIOLS>) {

  if (m/Path Groups: $stop\_delay/g) {
    $dump = 0;
  } elsif (m/Path Groups: $delay\_delay/g) {
    $dump = 1;
  } elsif ($dump == 1 && m/(\S+)\s+\S+\s+(\S+)\s+VIOLATED\s*(\S+)\n/g) {
    my $endpoint = $1;
    my $slack    = $2;
    my $view     = $3;
    if ($view =~ "^func") {
      if ($func_slack{$endpoint} > $slack) {
        $func_slack{$endpoint} = $slack;
      }
    } elsif ($view =~ "^scan_capture") {
      if ($scanc_slack{$endpoint} > $slack) {
        $scanc_slack{$endpoint} = $slack;
      }
    } elsif ($view =~ "^scan_shift") {
      #print " one is $slack\n";
      #print " two is $scans_slack{$endpoint}\n";
      if ($scans_slack{$endpoint} > $slack) {
        $scans_slack{$endpoint} = $slack;
      }
    }
  }
}
 
#I can tell you that the syntax of that statement implies that %var1 is a
#hash, $var2 is a scalar, the element of %var1 indexed by $var2 is
#$var1{$var2} and is a reference to an array, and @{$var1{$var2}} is the
#dereferenced array.
# Dump out worst case endpoint and slack for each mode
#  my %table;
#$table{'schmoe'} = 'joe';
#$table{7.5}  = 2.6;
#In this example, our hash, called, %table, has two entries.
#The key 'schmoe' is associated with the value 'joe', and the key 7.5 is associated with the value 2.6.

my $func_tns = 0;
my $scans_tns = 0;
my $scanc_tns = 0;
my $func_wns = 0;
my $scans_wns = 0;
my $scanc_wns = 0;
my $i=0;
foreach my $ep (sort {$func_slack{$a} <=> $func_slack{$b}} keys %func_slack) {
  $func_tns = $func_tns - $func_slack{$ep};
  $i++;
  if ($i == 1) {
  #print "wns is $func_slack{$ep}\n";
  $func_wns = $func_slack{$ep};
  }
  print FUNC_OUT "$ep $func_slack{$ep}\n";
}

my $i=0;
foreach my $ep (sort {$scanc_slack{$a} <=> $scanc_slack{$b}} keys  %scanc_slack) {
  $scanc_tns = $scanc_tns - $scanc_slack{$ep};
  $i++;
  if ($i == 1) {
  #print "wns is $scanc_slack{$ep}\n";
  $scanc_wns = $scanc_slack{$ep};
  }
  print SCANC_OUT "$ep $scanc_slack{$ep}\n";
}

my $i=0;
foreach my $ep (sort {$scans_slack{$a} <=> $scans_slack{$b}} keys  %scans_slack) {
 $scans_tns = $scans_tns - $scans_slack{$ep};
  $i++;
  if ($i == 1) {
  #print "wns is $scans_slack{$ep}\n";
  $scans_wns = $scans_slack{$ep};
  #print "wns is $scans_wns\n";
}
  #print "$scans_tns";
 print SCANS_OUT "$ep $scans_slack{$ep}\n";
}

my $func_ct = scalar keys %func_slack;
my $scanc_ct = scalar keys %scanc_slack;
my $scans_ct = scalar keys %scans_slack;

#print "TNS report (no. unique endpoints) - $delay\n";
#print "---------------------------------------\n";
if($func_mode){
print "func:$delay:$rev_words[1],-$func_tns,$func_ct,$func_wns\n";
}
if($scans_mode){
print "scan_shift:$delay:$rev_words[1],-$scans_tns,$scans_ct,$scans_wns\n";
}
if($scanc_mode){
print "scan_capture:$delay:$rev_words[1],-$scanc_tns,$scanc_ct,$scanc_wns\n";
}

#TNS report (no. unique endpoints) - min
#---------------------------------------
#func         - 0 (0)
#scan_shift   - 30.9132 (209)
#scan_capture - 0 (0)


close(VIOLS);
close(FUNC_OUT);
close(SCANS_OUT);
close(SCANC_OUT);
}

#TNS report (no. unique endpoints) - min
#---------------------------------------
#func         - 0 (0)
#scan_shift   - 30.9132 (209)
#scan_capture - 0 (0)
`find *.csv -type f -exec sed -i 's/m1cv/1.32_3.3/g' {} +`;
`find *.csv -type f -exec sed -i 's/m2cv/1.32_1.6/g' {} +`;
`find *.csv -type f -exec sed -i 's/m3cv/1.32_3.6/g' {} +`;

#sort -u -t' ' -k3,3 file
#-u - print only the unique lines.
#-t - specify the delimiter. Here in this example, I just use the space as delimiter.
#  -k3,3 - sort on 3rd field.
#`sort -u -t',' -k2,2 out.csv`;

`cat output.csv | sort -k2n -t',' | sort -u -k1,1 -o output.csv`;

#`find *.csv -type f -exec sed -i 's/_cworst//g' {} +`;
#`find *.csv -type f -exec sed -i 's/_rcworst//g' {} +`;
#`find *.csv -type f -exec sed -i 's/_cbest//g' {} +`;
#`find *.csv -type f -exec sed -i 's/_rcbest//g' {} +`;
#`find *.csv -type f -exec sed -i 's/_typical//g' {} +`;


