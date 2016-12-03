#!/usr/std/bin/perl5.6.1
###############################################################################
# %name:            asm_depend_plus.pl %
# created_by:       zzssm0
# date_created:     Tue Oct  5 08:55:34 2004
# %derived_by:      zzssm0 %
# %date_modified:   Wed Jun  7 14:35:43 2006 %
# %version:         kok_pt1#3 %
###############################################################################
# executed from within SubProject_NEC_78k0.mak
# 01.ToolFiles\perl 01.ToolFiles\MSDev\Nec_78k0\asm_depend_plus.pl
#	ARGV[1] - list file to be parsed
#	ARGV[2] - list of include directories to search --> enclose in double quotes
#		  i.e., "dir1 dir2 dir3 ... dirN"
#	ARGV[3] - source filename
#	ARGV[4] - path to the auxiliary tools
#	ARGV[5] - fully qualified outputfile for dependency for ARGV[3]
#		  e.g., $(DEPEND_DIR)/<file_basename>.d
#	ARGV[6] - fully qualified outputfile for audio option command files for ARGV[3]
#		  e.g. $(DEPEND_DIR)/<file_basename>.dc
#       ARGV[7] - DEFAULT_NEC_78K0_ASM_COMMAND_FILE (if no option file is found)
###############################################################################

$lstfile = $ARGV[1];
$include_depend = $ARGV[2]; 
$filename = $ARGV[3]; 
$tools_path = $ARGV[4];
$outputfile = $ARGV[5];
$outputfile2 = $ARGV[6];
$default_cmdfile = $ARGV[7];


$[ = 1;			# set array base to 1
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

$filename =~ s/\\//g;
$depend{0} = $filename;
$number_depends = 1;
$number_cmdfiles = 0;

#if( tools_path != "" && match(/\/$/,tools_path) == 0 ){
#	sub(/.$/,"&/",tools_path )
#}

open(LST,"$lstfile") || die "Can't open $lstfile.\n";
while (<LST>) {
    chomp;	# strip record separator

    # parse for case-insensitive '.include' or '.binclude'
    if (/^[;][ \t]+(\$[iI][nN][cC][lL][uU][dD][eE]|\.[bB][iI][nN][cC][lL][uU][dD][eE])/)

      {
	#Get the filename wrapped in parentheses
	s/\$include//;
	@depend_prerequisite = split(' ', $_, 9999);

	# convert all double back slashes with forward slash
	$depend_prerequisite[2] =~ s/\\\\/\//g;

	# convert all back slashes with forward slash
	$depend_prerequisite[2] =~ s/\\/\//g;

	#remove parentheses
	$depend_prerequisite[2] =~ s/\(//g;
	$depend_prerequisite[2] =~ s/\)//g;
	if ($depend_prerequisite[2] ne "") {
	# build executable commandline to find the prerequisite file
	$depend_execute = $tools_path . '/' . 'find ' . '. ' . $include_depend . ' -iname ' . $depend_prerequisite[2];

	# execute commandline to get fully qualified dependent file
	$depend_file = &Getline3($depend_execute, '|');

	# remove any relative pathing embedded in the pathname
	$depend{$number_depends++} = &remove_rel_path($depend_file);
	}
    }

    # parse for case-insensitive 'dependent' keyword
    elsif (/^[ \t]+[;][dD][eE][pP][eE][nN][dD][eE][nN][tT]/)

      {

	#Get the filename wrapped in parentheses
	@depend_prerequisite = split(' ', $_, 9999);

	# convert all double back slashes with forward slash
	$depend_prerequisite[2] =~ s/\\\\/\//g;

	# convert all back slashes with forward slash
	$depend_prerequisite[2] =~ s/\\/\//g;

	#remove parentheses
	$depend_prerequisite[2] =~ s/\(//g;
	$depend_prerequisite[2] =~ s/\)//g;
	
	# build executable commandline to find the prerequisite file
	$depend_execute = $tools_path . '/' . 'find ' . '. ' . $include_depend . ' -iname ' . $depend_prerequisite[2];
	
	# execute commandline to get fully qualified dependent file
	$depend_file = &Getline3($depend_execute, '|');

	# remove any relative pathing embedded in the pathname
	$depend{$number_depends++} = &remove_rel_path($depend_file);
	$cmdfile{$number_cmdfiles++} = &remove_rel_path($depend_file);
    }
} 
close (LST);

$object_name = &remove_path($filename);
$depend_name = &remove_path($filename);

($s_ = '"'.($add_to_output_file . '.o').'"') =~ s/&/\$&/g,

  $object_name =~ s/(\..*)$/eval $s_/ge;
($s_ = '"'.($add_to_output_file . '.d').'"') =~ s/&/\$&/g,

  $depend_name =~ s/(\..*)$/eval $s_/ge;

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

    # now remove the 1st ./ from path
    while (($string =~ s/^\.\///)) {
	;
    }
    
    # now remove any other ./ from path
    while (($string =~ s/\/\.\///)) {
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
