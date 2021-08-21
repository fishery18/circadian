##This script takes the Off->On file and creates On->Off COPASI files for each parameter set
##This code is rather specific for the COPASI file I was using, since it was much faster to use a counter rather than search each line
use strict;
use warnings;

my $CRvalue = 0.1;
my $batchnum = 7;
my $folderNum = 1;
my $serumValue = 20;

my @speciesList = ("M","CD", "CE", "E", "R", "RP", "RE", "CR");
my @names = ("I1", "I2", "I3", "I4", "I5", "w1", "w2", "w3", "w4", "w5","m1", "m2", "m3", "m4", "m5");
##my @badNums = (0.5, 0.15, 0.15, 0.92, 0.92, 1, 0.03, 0.35, 0.4, 18, 18, 3.6, 0.7, 0.25, 1.5, 1.5, 0.003, 1000, 0.3, 1, 0.45, 180, 0.06, 0.06, 0.03, 0.01, 0.18);
my $fileCount = 0;

## NUM HERE
my $file = "output$CRvalue\_$batchnum\_clean.txt";
my $count = 0;
my $cpsCount = 1;
my $folderCount = 1;
##Change this to wherever your Off->On file is4
##28 is hi
#1061-1065 is m's
#1051-1060 is I's and w's
## NUM HERE
my $directory = "/home/mcbadmin/20180913_circadian_E2F/circadian_E2F_$CRvalue/batch$batchnum";
my $tester = 0;
my $subdir;

	open(FILEIN1, "$directory/$file") || die "cannot open $file";
	while(<FILEIN1>)
	{
		chomp $_;
		my @line = split(/\t/);
		if (!$line[10]) {next;}
		if ($line[10] =~ /[a-zA-Z]/|!$line[0]) {next;}
		if($line[10] eq $serumValue)
		{
			my $paras = join("\t", $line[0], $line[1], $line[2], $line[3], $line[4], "1", "0.45", "0.18", "0.35", "0.4", $line[5], $line[6], $line[7], $line[8], $line[9]);
			open(FILEIN2, "$directory/OnOffTemplate0.1.cps") || die "cannot open Xia";
			open(FILEOUT, "> /home/mcbadmin/20180913_circadian_E2F/CR$CRvalue\_$batchnum/OnOff_$cpsCount.cps") || die "cannot open OnOff_$cpsCount";
			my $lineNum = 0;
			my $paraCounter = 0;
			my $specCounter = 0;
			while(<FILEIN2>)
			{
				chomp $_;	
				if($lineNum == 1547)
				{
					##NUM HERE
					print FILEOUT "<Report reference=\"Report_21\" target=\"./OnOff_output$cpsCount.txt\" append=\"0\" confirmOverwrite=\"0\"/>\n";
				}
				elsif($lineNum > 1101 && $lineNum < 1110)
				##This block inserts the species values
				{
					my $species = $speciesList[$specCounter];
					#CHANGE THIS
                                        my $value = 0;
##                                        if($species eq "CR")
##                                        {
##                                          $value = $CRvalue/.001660539;
##                                        }
##                                        else
##					{
                                          $value = $line[12+$specCounter]/.001660539;	# Dividing by conversion factor
##                                        }
					print FILEOUT "<ModelParameter cn=\"CN=Root,Model=E2F Model,Vector=Compartments[compartment],Vector=Metabolites[$species]\" value=\"$value\" type=\"Species\" simulationType=\"reactions\"/>\n";
					$specCounter++;
				}
				elsif($lineNum > 1138 && $lineNum < 1154)
				{
					my $name = $names[$paraCounter];
					my @goodys = split(/\t/, $paras);
					my $best = $goodys[$paraCounter];
					print FILEOUT "<ModelParameter cn=\"CN=Root,Model=E2F Model,Vector=Values[$name]\" value=\"$best\" type=\"ModelValue\" simulationType=\"fixed\"/>\n"; 
					$paraCounter++;
				}
##				elsif($lineNum == 1350)
##				{
##					my $value = $CRvalue/.001660539;
##					print FILEOUT "<ModelParameter cn=\"CN=Root,Model=E2F Model,Vector=Compartments[compartment],Vector=Metabolites[CR]\" value=\"$value\" type=\"Species\" simulationType=\"reactions\"/>\n";
##				}
				else
				{
					print FILEOUT "$_\n";
				}
				##Old code that won't matter unless you generate >25K runs
				#if($cpsCount == 121500)
				#{
				#	$folderCount++;
				#	$cpsCount = 0;
				#	print "Switching to Folder$folderCount\n";
				#}
				$lineNum++;
			}
			close(FILEIN2);
			close(FILEOUT);
			$cpsCount++;
		}
		else
		{
			next;
		}
		$count++;
	}
	$fileCount++;
	close(FILEIN1);
	##NUM HERE
	print "Round1 done\n";
print $fileCount;
