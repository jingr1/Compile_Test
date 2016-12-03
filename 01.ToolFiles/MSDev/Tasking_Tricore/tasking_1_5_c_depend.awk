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

/^#line\t1/{
	# convert all back slashes with forward slash
	gsub(/\\\\/,"/",$0)
	gsub(/\\/,"/",$0)
	
	split($0,depend_prerequisite,"\t")
	gsub(/\"/,"",depend_prerequisite[3])

	if( index( depend_prerequisite[3], full_filename ) == 0 ) depend[ number_depends++ ] = remove_rel_path( depend_prerequisite[3] )
	
}

END{
	object_name = remove_path(filename)
	depend_name = remove_path(filename)
	gsub(/(\..*)$/,".o",object_name)
	gsub(/(\..*)$/,".d",depend_name)
	
	sort( depend, number_depends - 1 )

	remove_duplicate( depend, number_depends - 1 )
	
	if( depend[0] != "" ) print "$(OBJ_DIR)/"object_name " $(DEPEND_DIR)/"depend_name": "depend[0] > outputfile
	
	for( i = 1; i < number_depends; ++i ){
		if( depend[i] != "" ){
			print "$(OBJ_DIR)/"object_name " $(DEPEND_DIR)/"depend_name": "depend[i] >> outputfile
		}
	}
	close(outputfile)
}


