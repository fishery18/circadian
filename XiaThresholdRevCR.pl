use strict;
use warnings;

my $CRnum = 0.5;
my $batchnum = 1;
my $middleNum = 0;
my $leftMin = 0.2;
my $leftMax = 3;
my $width = 3;
my $rightMin = 3;
my $rightMax = 19;

#POsitions in the output
my $S_pos = 10;
my $E_pos = 15;
my $E2_pos = 20;
my $t_pos = 11;
my $directory = "./results";
my $t = 1000;
my $data = "./total\ combine/CR$CRnum-$batchnum-totalCombined-Linux.txt";

my ( @line, $p, $param, $i, $j, @S, @E, @E2, $min, $max, $min2, @diff, $bi, $diff, $T, $bisw, $sl, $sr, $strong);
my ($p1, $pn1, $param1, $params2, $tops2);
my ($dS, $Ei);

my $first = 1;
my $middle;
my ($leftE2FOn, $rightE2FOn, $leftE2FOff, $rightE2FOff, $oldRightE2FOff);

open (FILEOUT1, "> $directory/biswitch_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open: biswitch_p_Xia"; 
open (FILEOUT2, "> $directory/birev_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open: birev";
open(FILEOUT3, "> $directory/bistr_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open strong";
open(FILEOUT4, "> $directory/allParasTopsCR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt");
open(FILEOUT5, "> $directory/biswitch_graph_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open biswitch graph";
open(FILEOUT6, "> $directory/birev_graph_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open birev graph";
open(FILEOUT7, "> $directory/bistr_graph_CR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open str graph";
open(FILEOUT8, "> $directory/biswitch_TopologiesCR$CRnum-$batchnum-right$rightMin-$rightMax-left$leftMin-$leftMax-width$width.txt") || die "cannot open biswitch topology";
##for(my $y = 1; $y < 11; $y++)
#{
	


$Ei = 0.1;  ##	0.1/10 (minimum to call a bistable point), in "if (abs($line[2]-$line[3]) > $Ei) {"

#use POSIX qw(log10); ## use log10 function
#$dS = (log10(20)-log10(0.01))/25;
## 28 is high
## 45-49 are m's


open (FILEIN, "$data") || die "cannot open: $data";
while (<FILEIN>) {
	chomp($_);
	@line = split(/\t/);
	if(!$_) {next;}
	if(!$line[0]) {next;}
	if ($line[0] =~ /[a-zA-Z]/|!$line[0]) {next;}	

	my $tops = undef;
	#CHANGE TO TOPOLOGY ORDER
	for($j = 5; $j < 10; $j++)
	{
		$tops .= "$line[$j]\t";
	}
	
	my $params = undef;
	#CHANGE TO PARAMETER ORDER
	for($j = 0; $j < 5; $j++)
	{
		$params .= "$line[$j]\t";
	}
	
	if($tops ne $tops2)
	{
		$bisw = undef;
		$pn1++;
		$params2 = $params;
		my $tp = $params.$tops;
		print FILEOUT4 $tp."\n";
		if (($max-$min) > 0.1) 
		{  ## 1st, being a switch 
			if ($E[0] <= $min+($max-$min)/20 && $E[$i-1] >= $max-($max-$min)/20) 
			{   ## 2nd, 5% grace region, in case not idenfical to $min and $max due to numeric instability in simulation
				{
					my $printable = $params2.$tops2;
					for ($j=0; $j<$i; $j++) {
						if($diff[$j] >= ($max-$min)/10) {$bi++;} ##Increment $bi if the difference is greater than max-min/10
						if($diff[$j] >= ($max-$min)/5) {$diff++;}
					}
					
					## 3rd, bistable criteria (minimum: 2 points have larger than 10% difference, or 1 point has larger than 20% difference
					## New bistable region width criteria, here $middle is used to measure bistable region distance?
					$middle = ($leftE2FOn+$rightE2FOn)/2 - ($leftE2FOff+$rightE2FOff)/2;
					if (($bi>=2 || $diff) && $sr > $rightMin && $sr < $rightMax && $sl > $leftMin && $sl < $leftMax && ($sr-$sl > $width)) { #Xia's criteria for REV
					##if (($bi>=2 || $diff) && $middle > 1 && $sr > $right && $sl > $leftMin && $sl < $leftMax && ($sr-$sl > $width)) { #Xia's criteria for CRY
						$bisw = 1;
						my $differ = $sr-$sl;
						my $topAmp = ($leftE2FOn+$rightE2FOn)/2;
						my $botAmp = ($leftE2FOff+$rightE2FOff)/2;
						print FILEOUT1 "$printable"."$sl\t$sr\t$differ\t$middle\t$topAmp\t$botAmp\n";	
						for($j = 0; $j <$i; $j++)
						{
							print FILEOUT5 "$S[$j]\t$E[$j]\t$E2[$j]\n";
						}
						my @topologyValues = split(/\t/, $tops2);
						my $topologySum = 81 * $topologyValues[0] + 27 * $topologyValues[1] + 9 * $topologyValues[2] + 3 * $topologyValues[3] + 1 * $topologyValues[4] + 1;
						print FILEOUT8 "$topologySum\n";
						## 4th, reversible switch
						if ($min2 <= $min+($max-$min)/20) {  ## thus the e2f levels of ON/OFF curves at the left-most point (s=0.01) are identical (actually, within the same 5% grace region)

						## 5th, proper bistable region
								## threshold for fully-ON is >(0.5~5)
							## threshold for fully-OFF is <(0.02~1)
							if (($sr > 0.5 && $sr < 5) && ($sl > 0.02 && $sl < 1) && ($sr-$sl) >= 0.4) {$strong = 1;}  

							print FILEOUT2 "$printable\t$differ\n";	
							for($j = 0; $j <$i; $j++)
							{
								print FILEOUT6 "$S[$j]\t$E[$j]\t$E2[$j]\n";
							}
						

							if ($strong) {
								print FILEOUT3 "$printable\t$differ\n";
								for($j = 0; $j <$i; $j++)
								{
									print FILEOUT7 "$S[$j]\t$E[$j]\t$E2[$j]\n";
								}
							}	
						}

					}
					
				}
			}
		}
		$tops2 = $tops;
		$i=$min=$max=$min2=$bi=$diff=$sl=$sr=$strong = undef;
		@S=@E=@E2=@diff = ();
		$first = 1;
	}
	#TIME VALUE
	if($line[$t_pos] == 1000)
	{
		#CHANGE THESE BACK
		$line[$E_pos] = sprintf "%.3f", $line[$E_pos]; ## steady-state E2F (turning-ON)
		$S[$i] = $line[$S_pos];  ## $i, each dose point
		$E[$i] = $line[$E_pos];
		$E2[$i] = $line[$E2_pos]; ## The On->Off E2F
		$diff[$i++] = abs($line[$E_pos]-$line[$E2_pos]);
		
		if (!$min || $line[$E_pos] < $min) {$min = $line[$E_pos];}
		elsif (!$max || $line[$E_pos] > $max) {$max = $line[$E_pos];}
		
		if (abs($line[$E_pos]-$line[$E2_pos]) >= $Ei) {
			if (!$sl || $line[$S_pos] < $sl) {$sl = $line[$S_pos]; $leftE2FOn = $line[$E2_pos]; $leftE2FOff = $line[$E_pos];} ## $sl, turn-OFF threshold (left-most bistable point)
			elsif (!$sr || $line[$S_pos] > $sr) {$sr = $line[$S_pos]; $rightE2FOn = $line[$E2_pos]; $rightE2FOff = $line[$E_pos];} ## $sr, turn-ON threshold (right-most bistable point)
			
			#if (!$sl || $line[1] < $sl) {$sl = 10**(log10($line[1])-$dS);} ## $sl, turn-OFF threshold, extended to the previous input point of left-most bistable point as boundary
			#elsif (!$sr || $line[1] > $sr) {$sr = 10**(log10($line[1])+$dS);} ## $sr, turn-ON threshold, extended to the next input point of the right-most bistable point as boundary
		}
		
		if (!$min2) {$min2 = $line[$E2_pos];}  ## $min2 always record the left-most point of the shutting-down curve 
		$T = 1;
	}
	if ($line[$t_pos] ne $t) {print "t not final Time\n";}
}

if (($max-$min) > 0.1) 
{  ## 1st, being a switch 
	if ($E[0] <= $min+($max-$min)/20 && $E[$i-1] >= $max-($max-$min)/20) 
	{   ## 2nd, 5% grace region, in case not idenfical to $min and $max due to numeric instability in simulation
		if($sr > .8 && $E[$i-1] > 1)
		{
			my $printable = $params2.$tops2;
			for ($j=0; $j<$i; $j++) {
			if($diff[$j] >= ($max-$min)/10) {$bi++;} ##Increment $bi if the difference is greater than max-min/10
			if($diff[$j] >= ($max-$min)/5) {$diff++;}
			}

			## 3rd, bistable criteria (minimum: 2 points have larger than 10% difference, or 1 point has larger than 20% difference
			if ($bi>=2 || $diff) {
				$bisw = 1;
				print FILEOUT1 "$printable\n";		
				## 4th, reversible switch
				if ($min2 <= $min+($max-$min)/20) {  ## thus the e2f levels of ON/OFF curves at the left-most point (s=0.01) are identical (actually, within the same 5% grace region)

				## 5th, proper bistable region
						## threshold for fully-ON is >(0.5~5)
					## threshold for fully-OFF is <(0.02~1)
					if (($sr > 0.5 && $sr < 5) && ($sl > 0.02 && $sl < 1) && ($sr-$sl) >= 0.4) {$strong = 1;}  

					print FILEOUT2 "$printable\n";	
				

					if ($strong) {
						print FILEOUT3 "$printable\n";
					}	
				}

			}
			
		}
	}
}
		
if (!$T) {print "\n********\nWARNING: time not correct !!!\n********\n";}

print "\n$pn1 parameter sets processed\n";

close (FILEIN);
##}
close (FILEOUT1);
close (FILEOUT2);
