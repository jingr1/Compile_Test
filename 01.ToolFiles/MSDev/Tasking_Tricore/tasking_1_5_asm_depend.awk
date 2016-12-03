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

	if( tools_path != "" && match(/\/$/,tools_path) == 0 ){
		sub(/.$/,"&/",tools_path )
	}
}

# sed command script to do all but finding the path to the prerequisite file.
# sed -e"/^ +[0-9]+ \.include/!d;s/^ +[0-9]+ \.include \(.*\)/\1/g;s/\"//g" pcp_eppwmt_odd.lst

/^[ ]+[0-9]+ \.include/{
	
	match($0, /\".*\"/)

	#Get the filename wrapped in double quotation marks
	depend_prerequisite = substr($0,RSTART,RLENGTH)
	
	# convert all double back slashes with forward slash
	gsub(/\\\\/,"/",depend_prerequisite)
	
	# convert all back slashes with forward slash
	gsub(/\\/,"/",depend_prerequisite)
	
	#remove double quotation marks
	gsub(/\"/,"",depend_prerequisite)
#	print "depend_prerequisite3-"depend_prerequisite

	# build executable commandline to find the prerequisite file
	depend_execute = tools_path"find "include_depend" -name "depend_prerequisite
	
	# execute the find command and place the result in the depend_file variable
	depend_execute | getline depend_file
	close( depend_execute )

	# remove any relative pathing embedded in the pathname
#	print "found file - "depend_file
	depend[ number_depends++ ] = remove_rel_path( depend_file )
}

END{
	object_name = remove_path(filename)
	depend_name = remove_path(filename)
		
	gsub(/(\..*)$/,add_to_output_file".o",object_name)
	gsub(/(\..*)$/,add_to_output_file".d",depend_name)
	
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


