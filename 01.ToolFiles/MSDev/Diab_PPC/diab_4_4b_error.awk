###############################################################################
#gawk -v errorfile =<error pathname> 
#		-f <pathname to error awk file (error.awk)>
#		<file containing diab compiler output>
###############################################################################



###############################################################################
# Parse errorfile and exit with error if file contains an error
#
# Reformat file to output a Microsoft Developer Studio friendly error message
# <pathname with error>(<line number>): <error description>
#
###############################################################################
BEGIN{
	exit_error = 0
}

{
	err_line_file = $1
	err_line = $3

	gsub( /\"\,*/,"",err_line_file)
	gsub( /\:/,"",err_line)
	gsub( /\"([^\"]*)", ([^ ]*) ([^ ]*): /,"",$0)

	print err_line_file"("err_line"): "$0

	if( $1 == "error" ){
		exit_error = 1
	}
}

END{
	if( exit_error == 1 ){
		if( system( tools_path"rm "outputfile ) != 0 ){
			print "failed to remove "outputfile
		}
		exit 1
	}
}
