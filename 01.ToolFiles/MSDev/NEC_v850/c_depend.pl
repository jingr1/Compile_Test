#!/usr/std/bin/perl5.6.1
###############################################################################
# %name:            c_depend.pl %
# created_by:       zzssm0
# date_created:     Mon Jun 14 11:31:06 2004
# %derived_by:      zzssm0 %
# %date_modified:   Fri Sep  1 11:35:46 2006 %
# %version:         kok_pt1#2 %
###############################################################################
# executed from within SubProject_NEC_V850.mak
# 01.ToolFiles\perl5.6.1 01.ToolFiles\MSDev\Nec_V850\c_depend.pl
#	ARGV[1] - pre-processed file to be parsed
#	ARGV[2] - list of include directories to search --> enclose in double quotes
#		  i.e., "dir1 dir2 dir3 ... dirN"
#	ARGV[3] - source filename
#	ARGV[4] - path to the auxiliary tools - NOT USED
#	ARGV[5] - fully qualified outputfile for dependency for ARGV[3]
#		  e.g., $(DEPEND_DIR)/<file_basename>.d
#	ARGV[6] - fully qualified outputfile for audio option command files for ARGV[3] -- NOT USED
#		  e.g. $(DEPEND_DIR)/<file_basename>.dc
#	ARGV[7] - fully qualified filename ($<)
###############################################################################

$prefile = $ARGV[1];
$include_depend = $ARGV[2]; 
$filename = $ARGV[3]; 
$tools_path = $ARGV[4];
$outputfile = $ARGV[5];
$outputfile2 = $ARGV[6];
$full_filename = $ARGV[7];


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
    if (/^# /) {
	# convert all back slashes with forward slash
	s/\\\\/\//g;
	s/\\/\//g;

	@depend_prerequisite = split(' ', $_, 9999);
	$depend_prerequisite[3] =~ s/\"//g;
	
	if (($depend_prerequisite[3] !~ /</) && ($depend_prerequisite[3] ne $full_filename)) {
	    $depend{$number_depends++} = &remove_rel_path($depend_prerequisite[3]);
	      
	}
    }
}
close(PRE);

$object_name = &remove_path($filename);
$depend_name = &remove_path($filename);
$object_name =~ s/(\..*)$/.o/g;
$depend_name =~ s/(\..*)$/.d/g;

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
