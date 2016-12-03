#!/usr/std/bin/perl5.6.1
###############################################################################
# %name:            c_depend_plus.pl %
# created_by:       zzssm0
# date_created:     Tue Oct  5 08:56:22 2004
# %derived_by:      zzssm0 %
# %date_modified:   Wed Jun  7 14:35:59 2006 %
# %version:         kok_pt1#3 %
###############################################################################
# executed from within SubProject_NEC_78k0.mak
# 01.ToolFiles\perl5.6.1 01.ToolFiles\MSDev\Nec_78k0\c_depend_plus.pl
#	ARGV[1] - pre-processed file to be parsed
#	ARGV[2] - list of include directories to search --> enclose in double quotes
#		  i.e., "dir1 dir2 dir3 ... dirN"
#	ARGV[3] - source filename
#	ARGV[4] - path to the auxiliary tools
#	ARGV[5] - fully qualified outputfile for dependency for ARGV[3]
#		  e.g., $(DEPEND_DIR)/<file_basename>.d
#	ARGV[6] - fully qualified outputfile for audio option command files for ARGV[3]
#		  e.g. $(DEPEND_DIR)/<file_basename>.dc
#	ARGV[7] - fully qualified filename ($<)
#	ARGV[8] - DEFAULT_NEC_78K0_CC_COMMAND_FILE (if no option file is found)
###############################################################################

$prefile = $ARGV[1];
$include_depend = $ARGV[2]; 
$filename = $ARGV[3]; 
$tools_path = $ARGV[4];
$outputfile = $ARGV[5];
$outputfile2 = $ARGV[6];
$full_filename = $ARGV[7];
$default_cmdfile = $ARGV[8];


$[ = 1;			# set array base to 1
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

$filename =~ s/\\/\//g;
$depend{0} = $filename;
$number_depends = 1;
$number_cmdfiles = 0;

$home_dir = &remove_rel_path($home_dir);

#	if( tools_path != "" && match(/\/$/,tools_path) == 0 ){
#		sub(/.$/,"&/",tools_path )
#	}

open(PRE,"$prefile")|| die "Can't open $prefile.\n";
while (<PRE>) {
    chomp;	# strip record separator

    # parse for the included files
    if (/^[ \t]*[0-9]*[ ][:][ ]#include/) {
	# convert all back slashes with forward slash
	s/\\\\/\//g;
	s/\\/\//g;

	@depend_prerequisite = split(' ', $_, 9999);
	$depend_prerequisite[4] =~ s/\"//g;
	
	# remove any <>  (system include)
	if ($depend_prerequisite[4] =~ /\</) {
	$depend_prerequisite[4] =~ s/\<//g;
	$depend_prerequisite[4] =~ s/\>//g;
	
	# build executable commandline to find the prerequisite file to look for it
	$depend_execute = $tools_path . '/' . 'find ' . '. ' . $include_depend . ' -iname ' . $depend_prerequisite[4];

	# execute commandline to get fully qualified dependent file
	$depend_file = &Getline3($depend_execute, '|');
	
	# remove any relative pathing embedded in the pathname
	$depend{$number_depends++} = &remove_rel_path($depend_file);
	
	} elsif (index($depend_prerequisite[4],$full_filename) == 0) {
	    $depend{$number_depends++} = &remove_rel_path($depend_prerequisite[4]);
	      
	} else {
		
	}
    }
    # parse for the case-insensitive 'dependent' keyword
    elsif (/^[ \t]*[0-9]*[ \t]*[:][ ]\/\*[ \t]*[dD][eE][pP][eE][nN][dD][eE][nN][tT]/) {
	# convert all back slashes with forward slash
	s/\\\\/\//g;
	s/\\/\//g;
	
	@depend_prerequisite = split(' ', $_, 9999);
	$depend_prerequisite[6] =~ s/\"//g;

	# build executable commandline to find the prerequisite file
	$depend_execute = $tools_path . '/' . 'find ' . $include_depend . ' -iname ' . $depend_prerequisite[5];
	
	# execute commandline to get fully qualified dependent file
	$depend_file = &Getline3($depend_execute, '|');
	
	# remove any relative pathing embedded in the pathname
	$depend{$number_depends++} = &remove_rel_path($depend_file);
	$cmdfile{$number_cmdfiles++} = &remove_rel_path($depend_file);
    }
}
close(PRE);

$object_name = &remove_path($filename);
$depend_name = &remove_path($filename);
$object_name =~ s/(\..*)$/.o/g;
$depend_name =~ s/(\..*)$/.d/g;

&Sort(*depend, $number_depends - 1);
&Sort(*cmdfile, $number_cmdfiles - 1);

&remove_duplicate(*depend, $number_depends - 1);
&remove_duplicate(*cmdfile, $number_cmdfiles - 1);

if ($depend{0} ne '') {
    &Pick('>', $outputfile) &&
	(print $fh "\$(OBJ_DIR)/" . $object_name . " \$(DEPEND_DIR)/" .

	  $depend_name . ': ' . $depend{0});
}
for ($i = 1; $i < $number_depends; ++$i) {
    if ($depend{$i} ne '') {
	&Pick('>>', $outputfile) &&
	    (print $fh "\$(OBJ_DIR)/" . $object_name . " \$(DEPEND_DIR)/" .

	      $depend_name . ': ' . $depend{$i});
    }
}
delete $opened{$outputfile} && close($outputfile);

if ($cmdfile{0} ne '') {
&Pick('>', $outputfile2) &&
    (print $fh $cmdfile{0});
for ($i = 1; $i < $number_cmdfiles; ++$i) {
    if ($cmdfile{$i} ne '') {
	&Pick('>>', $outputfile2) &&
	    (print $fh ' ' . $cmdfile{$i});
    }
}
} else {
&Pick('>', $outputfile2) &&
    (print $fh $default_cmdfile);
}
delete $opened{$outputfile2} && close($outputfile2);

sub Sort {
    local(*ARRAY, $ELEMENTS, $temp, $i, $j) = @_;
    for ($i = 2; $i <= $ELEMENTS; ++$i) {
	for ($j = $i;

	defined $ARRAY{($j - 1)} && $ARRAY{$j - 1} gt $ARRAY{$j}; --$j) {	#???
	    $temp = $ARRAY{$j};
	    $ARRAY{$j} = $ARRAY{$j - 1};
	    $ARRAY{$j - 1} = $temp;
	}
    }
}

sub remove_rel_path {
    local($string) = @_;

    # now remove any ./ from path
    while (($string =~ s/\/\.\//\//)) {
	;
    }

    # now remove any <pathname>/../ from path
    while (($string =~ s/\/[^\\\/]*\/\.\.//)) {
	;
    }

    $string;
}

sub remove_duplicate {
    local(*ARRAY, $ELEMENTS, $i, $unique) = @_;
    $unique = 0;
    for ($i = 1; $i <= $ELEMENTS; ++$i) {
	if ($ARRAY{$unique} eq $ARRAY{$i}) {	#???
	    $ARRAY{$i} = '';
	}
	else {
	    $unique = $i;
	}
    }
}

sub remove_path {
    local($string) = @_;
    if ($string =~ /([^\\\/]*)$/ &&

      ($RLENGTH = length($&), $RSTART = length($`)+1)) {
	$string = substr($string, $RSTART, $RLENGTH);
    }

    $string;
}

sub Getline3 {
    &Pick('',@_);
    local($_);
    if ($getline_ok = (($_ = <$fh>) ne '')) {
	chomp;	# strip record separator
    }
    $_;
}

sub Pick {
    local($mode,$name,$pipe) = @_;
    $fh = $name;
    open($name,$mode.$name.$pipe) unless $opened{$name}++;
}
