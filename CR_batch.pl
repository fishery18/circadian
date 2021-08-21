use strict;
use warnings;
use IPC::System::Simple qw(system systemx capture);

my $CRvalue = 0.1;
my $batchnum = 7;
my @ARGS;
##my $limit = 1215;
for(my $x = 0; $x <= 3160; $x++)
{
	systemx($^X, "/home/mcbadmin/20180913_circadian_E2F/XiaSim/CR$CRvalue\_$batchnum/hpc_simulation_$x.pl", @ARGS);
	##sleep 60;
}
