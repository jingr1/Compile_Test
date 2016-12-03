BEGIN {file=""; line[1]=""; msg=""}
{
  gsub(/\//,"\\",$0)
  if (/\:$/) {				# name of file (could be an include file) containing errors
    file=$NF
    line[1]=""; msg=""
  } else if (/^[ ]+[0-9]+:/) {		# line number information; strip off source
    split($1,line,":")
  } else if (/[W|E][ ]+[0-9]+:/) {	# error message
    msg=$0
    print file" ("line[1]") "msg;
    msg="";
  } else if (/total errors/) {		# total number of errors for source .c file
    file="";line[1]="";msg="";
  }
}
END {}