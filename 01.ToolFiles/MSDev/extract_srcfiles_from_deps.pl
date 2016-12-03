###############################################################################
#
# -d = dependency directory 
# -o = output file name
#
###############################################################################
our @alldepfiles;
MAIN:
{
	$user_friendly=0;
	&get_arguments(\@ARGV);
	
	opendir (DEPDIR,$dependency_dir) or die "Cannot open $dependency_dir.";
	@alldepfiles = readdir (DEPDIR);
	closedir (DEPDIR);
	
	print "Reading prerequistes in $dependency_dir.\n";
	$i=0;
	foreach $depfile (@alldepfiles) {
	   next unless ($depfile =~ /\.[d]$/);
	
	   open (DEPFILE, "$dependency_dir/$depfile") || die "Cannot read dependency file, $depfile.";	   
	   while (<DEPFILE>){
	   	chomp;
		($target1, $target2, $prereq) = split / /;
		$prerequisites[$i++] = $prereq;
	   }
	   close DEPFILE;
	}
	
	print "Writing sorted prerequistes to $output_filename.\n";
	&write_prerequisites($output_filename, \@prerequisites, $user_friendly);
}

###############################################################################
# get_arguments
#
#	Parse the array of arguments and assign them to the appropriate variables
#
# Parameter:
#	<array> - @arguments - an array of arguments
#
# Return:
#	none
#
# Parse for arguments
###############################################################################
sub get_arguments
{
	local (*arguments) = @_;

	ARG: while (@arguments && $arguments[0] =~ s/^-(?=.)//){
		OPT: for (shift @arguments) {
			s/^d=//  && do { $dependency_dir =$_; 	next ARG; };
			s/^o=//  && do { $output_filename=$_; 	next ARG; };
			s/^u=//  && do { $user_friendly=1; 	next ARG; };
			print "unknown option $_\n";			
		}
		
	}
}

###################################################################################################
# write_prerequisites
#
# write all the aquired prerequisites to a file
#
# Paramters:
#     <string> - $output_filename - the filename to write all the dependencies
#     <array>  - @prerequisites - array of prerequisites filenames
#
# Return:
#	none
#
# void write_prerequisites(<string>, <array>)
###################################################################################################
sub write_prerequisites
{
	local ($output_filename, *prerequisites, $user_friendly) = @_;
	
	&sort( \@prerequisites );

	&remove_duplicate( \@prerequisites);

	open OUTPUT_FILE, ">", "$output_filename" or die "Could not open $output_filename\n";

	foreach $prerequisite_file ( @prerequisites )
	{
		if( length($prerequisite_file) > 0 )
		{
			$prerequisite_file =~ s/\n//g;
			if ($user_friendly == 1) {
			   printf OUTPUT_FILE "%s\n", $prerequisite_file;
			} else {
			   printf OUTPUT_FILE "%s ", $prerequisite_file;
			}
		}
	}
	
	close OUTPUT_FILE;
}

###################################################################################################
# sort
#
# sort the dependencies in the array
#
# parameters:
#	<array> - @ARRAY - array of dependency files to sort
#	
# Return:
#	none
#
# void sort( <array> )
###################################################################################################
sub sort
{
	local(*ARRAY) = @_;

	my $ELEMENTS = scalar(@ARRAY);
	my $temp;
	my $i;
	my $j;
	
	for ($i = 1; $i <= ($ELEMENTS-1); ++$i) 
	{
		for ($j = $i; defined $ARRAY[($j - 1)] && $ARRAY[$j - 1] gt $ARRAY[$j]; --$j) 
		{	
			$temp = $ARRAY[$j];
			$ARRAY[$j] = $ARRAY[$j - 1];
			$ARRAY[$j - 1] = $temp;
		}
	}

}

###################################################################################################
# remove_duplicate
#
# remove any duplicate dependencies for the array
#
# parameters:
#	<array> - @ARRAY - array of dependency files to remove duplicates from
#	
# Return:
#	none
#
# void remove_duplicate( <array> )
###################################################################################################
sub remove_duplicate 
{
	local(*ARRAY) = @_;
	
	my $ELEMENTS = scalar(@ARRAY);
	my $unique = 0;
	my $i;

	for ($i = 1; $i <= ($ELEMENTS-1); ++$i) 
	{
		if($ARRAY[$unique] eq $ARRAY[$i]) 
		{	
			$ARRAY[$i] = '';
		}
		else 
		{
			$unique = $i;
		}
   }
}

