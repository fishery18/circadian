use strict;
use warnings;

my $CRvalue = 0.5;
my $batchnum = 7;

my $onOff = "./onoff_combine/combined-OnOff-CR$CRvalue-$batchnum.txt";
my $out = "./onoff_combine/combined-CR$CRvalue-$batchnum-E2F-Linux.txt";
open(FILEIN2, "$onOff") || die "cannot open $onOff";
open(FILEOUT, "> $out") || die "cannot open $out";
my $count = 0;
while(<FILEIN2>)
{
	chomp $_;
	my @line = split(/\t/);
	if ($line[0] =~ /[a-zA-Z]/|!$line[0]) {next;}
	my @split2 = split(/\t/);
	my $e2f = $split2[15];
	print FILEOUT $e2f."\n";
	$count++;
}
close(FILEIN2);
close(FILEOUT);
print "E2F: $count\n";




