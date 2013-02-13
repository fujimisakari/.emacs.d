use strict;
use warnings;

# Read an org file and create lists by context (tag)
# Written by Charles Cave  charles.cave (at) gmail.com
# 28th June 2006

my $orgfile = shift;
defined($orgfile) or die "syntax is orghip.pl orgfilename\n";

open(my $org, "<", $orgfile) or die "Cannot open $orgfile\n";
my %lists = ();
my $now = localtime();

while (<$org>) {
  my $line = $_;
  chomp($line);
  if ($line =~ /^\*+\s*(.*?):([A-Za-z]+):/) {
      my $hdng = "$1";
      my $tag  = $2;
      if ( defined($lists{$tag}) ) {
          $lists{$tag} = $lists{$tag}."\n".$hdng;
      } else {
          $lists{$tag} = $hdng;
      }
  }
}

print "Date Printed: $now\n";

process_context("PROJECT");

process_context("OFFICE");
process_context("HOME");
process_context("COMPUTER");
process_context("DVD");
process_context("READING");

# print any remaining contexts
foreach my $key (sort keys %lists) {
    process_context($key);
}

sub process_context {
   my $context = shift;
   print "\n\n$context:\n";
   foreach my $item( split(/\n/, $lists{$context}) ) {
       print "[ ] $item\n";
   }
   delete $lists{$context};
}
