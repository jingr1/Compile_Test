#!/usr/std/bin/perl5.6.1
###############################################################################
# %name:            asm_depend.pl %
# created_by:       zzssm0
# date_created:     Thu Aug 19 13:44:55 2004
# %derived_by:      zzssm0 %
# %date_modified:   Thu Aug 19 13:45:13 2004 %
# %version:         1 %
###############################################################################
# executed from within SubProject_NEC_V850.mak
# 01.ToolFiles\perl 01.ToolFiles\MSDev\Nec_V850\asm_depend.pl
#	ARGV[1] - list file to be parsed
#	ARGV[2] - directory hierarchy to search -> $(HOME_DIR)
#	ARGV[3] - source filename
#	ARGV[4] - path to the auxiliary tools
#	ARGV[5] - fully qualified outputfile for dependency for ARGV[3]
#		  e.g., $(DEPEND_DIR)/<file_basename>.d
###############################################################################

$lstfile = $ARGV[1];
$include_depend = $ARGV[2]; 
$filename = $ARGV[3]; 
$tools_path = $ARGV[4];
$outputfile = $ARGV[5];


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

# sed command script to do all but finding the path to the prerequisite file.
# sed -e"/^ +[0-9]+ \.include/!d;s/^ +[0-9]+ \.include \(.*\)/\1/g;s/\"//g" pcp_eppwmt_odd.lst

open(LST,"$lstfile") || die "Can't open $lstfile.\n";
while (<LST>) {
    chomp;	# strip record separator

    # parse for case-insensitive '.include' or '.binclude'
    if (/^[ \t]+[0-9]+[ \t]+(\.[iI][nN][cC][lL][uU][dD][eE])/)

      {

	$_ =~ /\".*\"/ && ($RLENGTH = length($&), $RSTART = length($`)+1);

	#Get the filename wrapped in double quotation marks
	$depend_prerequisite = substr($_, $RSTART, $RLENGTH);

	# convert all double back slashes with forward slash
	$depend_prerequisite =~ s/\\\\/\//g;

	# convert all back slashes with forward slash
	$depend_prerequisite =~ s/\\/\//g;

	#remove double quotation marks
	$depend_prerequisite =~ s/\"//g;

	# build executable commandline to find the prerequisite file
	$depend_execute = $tools_path . '/' . 'find ' . $include_depend . ' -name ' . $depend_prerequisite;
	print $depend_execute;
	# execute commandline to get fully qualified dependent file
	$depend_file = &Getline3($depend_execute, '|');
	print $depend_file;

	# remove any relative pathing embedded in the pathname
	$depend{$number_depends++} = &remove_rel_path($depend_file);
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

&remove_duplicate(*depend, $number_depends - 1);

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
