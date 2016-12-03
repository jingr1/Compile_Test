# Perl %name: ghs_sh_c_depend_opt_new.pl % (%full_filespec: ghs_sh_c_depend_opt_new.pl~1:perl:kok_pt2#1 %)
# %derived_by: zzssm0 %
# %date_created: Thu Mar 13 11:55:05 2014 %
################################################################################
#
#
# -I = include directory 
# -O = option file name
# -T = tools path
# -SF = source file name
# -DF = dependency file name
# -IF = listing file to parse for includes
#
###############################################################################

our @include_directories;
our @dependencies;
our %dependencies_asoc;

MAIN:
{
	&get_arguments(\@ARGV);
	$dependencies[0]=$source_filename;
	&get_dependencies($input_filename,$current_dir,\@dependencies);
	&write_dependency_file( $input_filename, $output_filename, \@dependencies);
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
			s/^I=//  && do { my $x=scalar(@include_directories);$include_directories[x]=$_;next ARG; };
			s/^O=//  && do { &read_option_file($_,\@include_directories,scalar(@include_directories)); next ARG; };
			s/^T=//  && do { $tools_path=$_;			next ARG; };
			s/^SF=// && do { $source_filename=$_;	next ARG; };
			s/^DF=// && do { $output_filename=$_;	next ARG; };
			s/^IF=// && do { $input_filename=$_;	next ARG; };
			s/^CD=// && do { $current_dir=$_;	next ARG; };
			s/^H=//  && do { $home_directory=$_;  $home_directory = &remove_rel_path( $home_directory); next ARG; };
			print "unknown option $_\n";
		}
	}
}

###################################################################################################
# write_dependency_file
#
# write all the aquired dependencies to a file
#
# Paramters:
#		<string> - $target_filename - the filename to use for the targets
#     <string> - $output_filename - the filename to write all the dependencies
#     <array>  - @dependencies - array of filenames the target depends on.
#
# Return:
#	none
#
# void write_dependency_file(<string>, <string>, <array>)
###################################################################################################
sub write_dependency_file
{
	local ($target_filename, $output_filename, *dependencies) = @_;
	
	my $object_name = remove_path($target_filename);
	my $depend_name = remove_path($target_filename);

	$object_name =~ s/(\..*)$/.o/g;
	$depend_name =~ s/(\..*)$/.d/g;

	open OUTPUT_FILE, ">", "$output_filename" or die "Could not open $output_filename\n";

	foreach $depend_line ( @dependencies )
	{
		if( length($depend_line) > 0 )
		{
			$depend_line =~ s/\n//g;
			#$depend_line =~ s/$home_directory/\$\(HOME_DIR\)/;
			printf OUTPUT_FILE "\$(OBJ_DIR)/%s \$(DEPEND_DIR)/%s: %s\n",$object_name, $depend_name, $depend_line;
		}
	}
	
	close OUTPUT_FILE;
}

###################################################################################################
# get_dependencies
#
# read a tasking preprocessed c file to extract all the included files
#
# Parameters:
#	<string> - $filename - preprocess file containing all the depencency files
#  <array>  - @dependencies - array to store all the dependency filenames
#
# Return:
#	none
#
# void get_dependencies(<string>, <array> )
###################################################################################################
sub get_dependencies
{
	local ($filename, $dir, *dependencies) = @_;
	
	$dependencies_length = scalar(@dependencies);
	$dependencies_asoc{$dependencies[0]} = $dependencies_length++;

	############################################################################
	# Read option file includes into include directories array
	############################################################################
	open PREPROCESS_FILE, "<" , $filename or die "Could not open $filename";

	while(<PREPROCESS_FILE>) 
	{
		
			$include_file = $_;
			
                        # unable to suppress warning when .asm includes no headers (strip out)
                        $include_file =~ s/.*ccsh\: No files.*//;
                        $include_file =~ s/.*cc800\: No files.*//;

                        # filter license manager warningS
                        $include_file =~ s/.*ecomsh\:.*\n//; 
                        $include_file =~ s/.*ecom800\:.*\n//; 
                        $include_file =~ s/.*GHS_LMWHICH.*\n//; 
			
			# clean up extraneous spaces
			$include_file =~ s/ //g;

			# convert all double back slashes with forward slash
			$include_file =~ s/\\\\/\//g;

			# convert all back slashes with forward slash
			$include_file =~ s/\\/\//g;

			$include_file = &remove_rel_path($include_file);
			
	                # if current path (./), replace with current fully-qualified path
	                $include_file =~ s/^\.\//$dir\//;

    if ( "z$include_file" ne "z" ) {
      if ( ! defined($dependencies_asoc{$include_file}) )
      {
        $dependencies_asoc{$include_file} = $dependencies_length++;
        push(@dependencies, $include_file);
      }
    } 
		
	}


	close PREPROCESS_FILE;
}

###################################################################################################
# read_option_file
#
# read an option file to extract any include paths
#
# Parameters:
#	 <string> - $option_filename - name of the option file to read
#   <array>  - @ARRAY - array to store all the include paths from the option file
#
# Return:
#	none
#
# void read_option_file(<string>, <array>)
###################################################################################################
sub read_option_file
{
	local($option_filename, *ARRAY) = @_;
	
	my $x = scalar(@ARRAY);

	open OPTION_FILE, "<" , $option_filename or die "Could not open $option_file";

	while(<OPTION_FILE>) 
	{ 
		if($_ =~ /^-I/)
		{
			$_ =~ s/\n/ /;
			$_ =~ s/-[I|i]/ /;
			$ARRAY[$x++] = $_; 
		}
	}

	close OPTION_FILE or die "Bad option file\n";
}

###################################################################################################
# remove_path
#
# remove all pathing information from the string.
#
# Parameters:
#	<string> - $string - string to remove the path from
#
# Return:
#	<string>
#
# <string> remove_path(<string>)
###################################################################################################
sub remove_path 
{
    local($string) = @_;
    if ($string =~ m/([^\\\/]*)$/ ) 
	 {
		$string = substr($string, length($`), length($&));
    }

    $string;
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

