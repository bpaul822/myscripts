#!/usr/bin/env perl
use strict;
use warnings;

my $prev;
my $pattern = qr/pat/;
my $have_matches = 0;

while (my $line = readline) {

    if ($line =~ /$pattern/) {
          print $prev if $have_matches == 1;
              print $line if $have_matches;
              $have_matches++;
                  $prev = $line;
                    } else {
                          $have_matches = 0;
                            }
}
