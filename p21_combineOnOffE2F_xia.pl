use strict;
use warnings;

my $CRvalue = 0.1;
my $batchnum = 7;

#my $dir = "./total combine";
my $out = "./total combine/CR$CRvalue-$batchnum-totalCombined-Linux.txt";
my $offOn;
my $onOff;
#my @lines1;
#my @lines2;
#
open(FILEOUT, "> $out") || die "cannot open $out";
#my $first = 1;
my $lineCount1 = 0;
my $lineCount2 = 0;

$offOn = "./circadian_E2F_$CRvalue/batch$batchnum/output$CRvalue\_$batchnum\_clean.txt";	
$onOff = "./onoff_combine/combined-CR$CRvalue-$batchnum-E2F-Linux.txt";
open(my $file1, "$offOn") || die "cannot open $offOn";
open(my $file2, "$onOff") || die "cannot open $onOff";
	
while(my $f1 = readline($file1))
{
	chomp $f1;
	$lineCount1++;
	if(my $f2 = readline($file2))
	{
		chomp $f2;
		print FILEOUT "$f1\t$f2\n";
		$lineCount2++;
	}	
}	
close($file1);
close($file2);
close(FILEOUT);
print "1: $lineCount1\n2: $lineCount2\n";
