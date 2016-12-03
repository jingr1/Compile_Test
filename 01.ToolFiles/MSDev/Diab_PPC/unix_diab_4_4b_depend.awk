###############################################################################
#gawk -v filename=<filename of compiled file (gcclmx_mat.c)>
#		-v outputfile=<depend file pathname> 
#		-v errorfile =<error pathname> 
#		-f <pathname to depend awk file (depend.awk)>
#		<file containing all header pathname>
###############################################################################

function sort( ARRAY, ELEMENTS, temp, i, j ){
	for( i = 2; i<= ELEMENTS; ++i ){
		for( j = i; ( j - 1 ) in ARRAY && ARRAY[j-1] > ARRAY[j]; --j ){
			temp = ARRAY[j]
			ARRAY[j] = ARRAY[j-1]
			ARRAY[j-1] = temp
		}
	}
}

function remove_rel_path( string ){

	# now remove any ./ from path
	while( sub(/\/\.\//,"/",string)){}

	# now remove any <pathname>/../ from path
	while( sub(/\/[^\/]*\/\.\./,"",string )){}
	
	return string
}

function remove_duplicate( ARRAY, ELEMENTS, i, unique ){
	unique = 0
	for( i = 1; i <= ELEMENTS; ++i ){
		if( ARRAY[unique] == ARRAY[ i ] ){
			ARRAY[i]=""
		}
		else{
			unique = i
		}
	}
}

function remove_path( string ){
	if( match(string, /([^\/]*)$/) ){
		string = substr(string,RSTART,RLENGTH)
	}
	
	return string
}

BEGIN{
	gsub(/\\/,"/",filename)
	depend[0] = filename
	number_depends = 1

	home_dir = remove_rel_path( home_dir )

	if( tools_path != "" && match(/\/$/,tools_path) == 0 ){
		sub(/.$/,"&/",tools_path )
	}
}
$0 !~ /^[:blank:]*\"/{
	# convert all back slashes with forward slash
	gsub(/\\/,"/",$1)

	depend[ number_depends++ ] = remove_rel_path( $1 )

	sort( depend, number_depends - 1 )
}

#$0 ~ /^[:blank:]*\".*\"\,[:blank:]*line[:blank:]*[:digit]+\:.*/{

$0 ~ /^[:blank:]*\".*\"\,.*/{
   print $0 >> errorfile
   close(errorfile)
}

END{
	object_name = remove_path(filename)
	depend_name = remove_path(filename)
	gsub(/(\..*)$/,".o",object_name)
	gsub(/(\..*)$/,".d",depend_name)
	
	remove_duplicate( depend, number_depends - 1 )

	for( i = 0; i < number_depends; ++i ){
		if( depend[i] != "" ){
			print "$(OBJ_DIR)/"object_name " $(DEPEND_DIR)/"depend_name": "depend[i] >> outputfile
		}
	}

	close(outputfile)

###############################################################################
# Parse errorfile and exit with error if file contains an error
#
# Reformat file to output a Microsoft Developer Studio friendly error message
# <pathname with error>(<line number>): <error description>
#
###############################################################################

	exit_error = 0
	
	while((getline < errorfile ) > 0 ){
	
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

	if( exit_error == 1 ){
		if( system( tools_path"rm -f "outputfile ) != 0 ){
			print "failed to remove "outputfile
		}
		exit 1
	}
}


