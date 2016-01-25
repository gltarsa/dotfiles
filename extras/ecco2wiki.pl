#! /usr/local/bin/perl
#
# Generates outline notation based on level of indentation. 
# Useful for changing pasted text from an ECCO outline into similar
# form for a file.
#
# $Id: outliner,v 1.5 1996/11/13 20:32:41 bsmith Exp $
# written by Ben Smith from Greg Tarsa's specification -- 6/96 at DEC
#
# By default, the line length is 78 characters. You can
# set any length that you want by using a -w <length> option when you
# invoke it. For example, to have lines that are 65 characters long, you
# would invoke it like this:
#       ecco2txt -w 65 source.txt
#
# The following shell will eliminate the annoying trailing whitespace.
# You will need to be a Unix user or otherwise have the sed command for
# this to be an option.
#
#       #!/bin/sh
#       ecco2txt.pl $@ | sed 's/[ ]*[]*$//'
#
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
# 01  Sep-2004, Greg Tarsa
#     Adapted from ecco2txt.pl
#


$indent = "\t";			# the input indent string
$outdent = "   ";		# the output indent string
$suf    = "\r\n";             # the tail suffix (for MS-DOS)

# the outline prefixes -- notice that they don't have a big range
@prefix = ( 
	   ["*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*" ],
	   ["**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**", "**" ],
	   ["***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***", "***" ],
	   ["****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****", "****" ],
	   );

# initialize some variables
$curLevel = 0;			# current indent level
$prevLevel = -1;		# previous indent level- starts less than cur
@levelCounter = (0,0,0,0,0);	# counters for each level

# default settings
$wrapWidth = 64;

################################### look for command line options ##################
use Getopt::Std;		# library routines for parsing arguments
getopts("hrud:w:");
if($opt_w) { $wrapWidth = $opt_w; }
if($opt_u) { $suf ="\n"; }
if($opt_h) { printf ("   ?Options:
	-h this message
	-r raw output (reduce tabs to 4 spaces)
	-d 'list'	use each char in 'list' as level char
	-u		inhibit ^M char at end of line (Unix form)
	-w ##		wrap output at char pos ##
	\n");
	exit(1);}
#print "-------------- wrapWidth = $wrapWidth\n";

################################## main loop #######################################
while(<>) {
    chop;
    next if /^$/;
    # find the indent level by counting from begining of line
    while(s/^$indent//) { ++ $curLevel; }
    if($curLevel > $prevLevel) {
	$levelCounter[$curLevel] = 0; # reinitialize this level's counter
    } else { 
	# increment the counter for this level
	++ $levelCounter[$curLevel];
    }
    if (!$opt_r) {
	if ($opt_d) {
	    $prefix = substr($opt_d, $curLevel % length($opt_d), 1);
        }
        else {
            $prefix = ($outdent x $curLevel) .
                       $prefix[$curLevel][$levelCounter[$curLevel]];
        }
    }
    $body = $_;
    &SetFormat;			
    write;
    $prevLevel = $curLevel;
    $curLevel = 0;
}


sub SetFormat {			# uses the format statement to
				# make a tidy output
    my($prefixLength) = length("$outdent")*$curLevel + 
	length($prefix[$curLevel][$levelCounter[$curLevel]]) - 1; # 1 for the @
    my($bodyLength) = $wrapWidth - $prefixLength - 2; # 1 for the space; 1 for the @

    # first format line string
    my($fString) = "\n";	# start with a new line
    $fString    .= "@" . ">" x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "\$prefix,\$body\n";
    # subsequent format line strings
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
# added the following to accomodate longer paragraphs
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";
    $fString    .= "~" . " " x $prefixLength . " ^" . "<" x $bodyLength . $suf;
    $fString    .= "         \$body\n";

    # terminator
    $fString    .= ".\n";

    # now eval it for STDOUT
    eval("format = $fString");
}
