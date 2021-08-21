use strict;
use warnings;

my $CRvalue = 0.5;
my $batchnum = 2;
##my $amount = 50;
my $pathmodel;
my $counter = 0;
for(my $i = 0; $i <= 100; $i+=1)
{
$pathmodel .= "./CR$CRvalue\_$batchnum/OnOff_$i.cps ";
}
system "./CopasiSE -c $pathmodel";
print "DONE\n";
