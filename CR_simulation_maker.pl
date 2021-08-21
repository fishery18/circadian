##This script creates scripts that'll run the On->Off COPASI files
##On Windows, there is a character limit on the command line, which is why I have to break it up into multiple scripts
use strict;
use warnings;

my $batchnum = 7;
my $CRvalue = 0.5;
my $amount = 100;
my $loop = 3160;
for(my $x = 0; $x < $loop; $x++)
{
	open(FILEOUT, "> /home/mcbadmin/20180913_circadian_E2F/XiaSim/CR$CRvalue\_$batchnum/hpc_simulation_$x.pl") || die "cannot open hpc_simulation_$x.pl";
	print FILEOUT "use strict;\n";
	print FILEOUT "use warnings;\n";
	print FILEOUT "my \$amount = $amount;\n";
	print FILEOUT "my \$pathmodel;\n";
	print FILEOUT "my \$counter = ".$x*$amount;
	print FILEOUT ";\nfor(my \$i = 0; \$i < \$amount; \$i++)\n"; 
	print FILEOUT "{\nmy \$y = \$counter + \$i;\n";
	print FILEOUT "\$pathmodel .= \"/home/mcbadmin/20180913_circadian_E2F/CR$CRvalue\_$batchnum/OnOff_\$y.cps \";\n}\n";
	print FILEOUT "system \"./CopasiSE -c ./.. \$pathmodel\";";
	#print FILEOUT "\nprint \"1\\n\";\n";
	close(FILEOUT);
}
