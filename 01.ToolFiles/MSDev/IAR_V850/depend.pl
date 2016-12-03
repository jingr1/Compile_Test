###############################################################################
#
#
# -HD= home directory 
# -CD = compiler directory
# -DD = depend directory
# -DF = dependency file name
# -IF = input file name
#
###############################################################################

MAIN:
{
	&get_arguments(\@ARGV);
	&massage_dependencies($input_filename, $output_filename);
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
			s/^DF=// && do { $output_filename=$_;	next ARG; };
			s/^IF=// && do { $input_filename=$_;	next ARG; };
			s/^HD=// && do { $home_dir=$_;	next ARG; };
			s/^CD=// && do { $compiler_dir=$_;	next ARG; };
			s/^DD=// && do { $depend_dir=$_;	next ARG; };
			print "unknown option $_\n";
		}
	}
}


###################################################################################################
# massage_dependencies
#
# read a iar v850 dependency file  and prepend '$(DEPEND_DIR)/$file $OBJ_DIR)/' to each dependency
#
# Parameters:
#	<string> - $filename - input depencency file from iar tools
#	<string> - $output_filename - output dependency file
#
# Return:
#	none
#
# void get_dependencies(<string>, <string>)
###################################################################################################
sub massage_dependencies
{
	local ($filename, $output_filename) = @_;

	############################################################################
	# Read option file includes into include directories array
	############################################################################
	open PREPROCESS_FILE, "<" , "$filename" or die "Could not open $filename";
	open OUTPUT_FILE, ">", "$output_filename" or die "Could not open $output_filename\n";

	$output = $output_filename;
	$output =~ s/$depend_dir/\$(DEPEND_DIR)/;
	
	while(<PREPROCESS_FILE>) 
	{
		
			$include_file = $_;
			
			# clean up extraneous spaces
			$include_file =~ s/ //g;

			# convert all double back slashes with forward slash
			$include_file =~ s/\\\\/\//g;

			# convert all back slashes with forward slash
			$include_file =~ s/\\/\//g;

			$include_file = &remove_rel_path($include_file);
			
			$include_file =~ s/$home_dir/\$(HOME_DIR)/;
			$include_file =~ s/$compiler_dir/\$(IAR_V850_COMPILER_PATH)/;

			printf OUTPUT_FILE "%s \$(OBJ_DIR)/%s", $output, $include_file;

		
	}
	close PREPROCESS_FILE;
	close OUTPUT_FILE;
}


###################################################################################################
# remove_rel_path
#
# remove any relative pathing information stored in the string
#
# Parameters:
#	<string> - $string - string to remove any relative pathing from.
#	
# Return:
#	<string>
#
# <string> remove_rel_path( <string> )
###################################################################################################
sub remove_rel_path 
{
    local($string) = @_;

    # now remove any ./ from path
    while (($string =~ s/\/\.\//\//)) {;}

    # now remove any <pathname>/../ from path
    while (($string =~ s/\/[^\\\/]*\/\.\.//)) {;}

    $string;
}
