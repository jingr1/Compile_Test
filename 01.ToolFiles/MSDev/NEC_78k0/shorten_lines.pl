#!/usr/std/bin/perl5.6.1
###############################################################################
# %name:            shorten_lines.pl %
# created_by:       zzssm0
# date_created:     Tue Oct  5 08:57:58 2004
# %derived_by:      zzssm0 %
# %date_modified:   Wed Jun  7 14:37:56 2006 %
# %version:         kok_pt1#2 %
###############################################################################
# executed from within SubProject_NEC_78k0.mak
# 01.ToolFiles\perl 01.ToolFiles\MSDev\Nec_78k0\shorten_lines.pl
#	ARGV[1] - input file to be parsed
#	ARGV[2] - output file chopped at 72 characters/line
###############################################################################
$infile = $ARGV[0];
$outfile = $ARGV[1];
print "$infile; $outfile;\n";

open(IN,"$infile") || die "Can't open $infile.\n";
open(OUT,">$outfile") || die "Can't open $outfile.\n";

while (<IN>) {
    chomp;	# strip record separator
    $shortened_line = substr($_,0,170);
    print OUT "$shortened_line\n";
}
close(IN);
close(OUT);