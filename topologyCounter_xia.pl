use strict;
use warnings;

my $CRnum = 0.5;
my $p21num = 2;
my $left = 0.2;
my $leftMax = 3;
my $right = 3;
my $rightMax = 19;
my $w = 3;
open(FILEIN, "./results/biswitch_TopologiesCR$CRnum-$p21num-right$right-$rightMax-left$left-$leftMax-width$w.txt") || die "cannot open in";
open(FILEOUT, "> ./results/CR$CRnum-$p21num-totalTopologiesCount$p21num-right$right-$rightMax.txt") || die "cannot open out";


my @counter;
while(<FILEIN>)
{
	chomp $_;
	$counter[$_]++;
}
my $out;
my $counts;
for(my $x = 1; $x < 244; $x++)
{
	my $value = $counter[$x];
	print FILEOUT "$x\t$value\n";
}	
close(FILEOUT);
close(FILEIN);
