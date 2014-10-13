#! /usr/bin/perl
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
# 05  Aug-2014, Greg Tarsa
#     Add option for producing Markdown-compatible output
#
# 04  25-Oct-99, Greg Tarsa
#     Added *many* extra format lines to ensure that long paragraphs
#     do not get truncated.  This may be an ongoing problem.
#
# 03  18-Feb-98, Greg Tarsa
#     Added ^M to the end of every line, except when -u is specified.
#
# 02  2-May-97, Greg Tarsa
#     Added '-d str' option to allow specification of prefix chars
#
# 01  20-Apr-97, Greg Tarsa
#     Added '-r' option for "raw output"
#


$indent = "\t";			# the input indent string
$outdent = "   ";		# the output indent string (three spaces per level)
$suf    = "\r\n";             # the tail suffix (for MS-DOS)

# the outline prefixes -- notice that they don't have a big range
@prefix = ( 
  [(a..z)],
  [(1..100)],
  [(a..z)],
  [(1..100)], 
  [(a..z)],
  [(1..100)],
  [(a..z)],
  [(1..100)],
  [(a..z)],
  [(1..100)]
);
# put period after the elements of the first two
grep(s/(.*)/$1./, @{$prefix[0]});
grep(s/(.*)/$1./, @{$prefix[1]});
# put parenthesis after the elements of the next two
grep(s/(.*)/$1)/, @{$prefix[2]});
grep(s/(.*)/$1)/, @{$prefix[3]});
# put period after the elements of the next two
grep(s/(.*)/$1./, @{$prefix[4]});
grep(s/(.*)/$1./, @{$prefix[5]});
# put parenthesis after the elements of the next two
grep(s/(.*)/$1)/, @{$prefix[6]});
grep(s/(.*)/$1)/, @{$prefix[7]});
# put period after the elements of the next two
grep(s/(.*)/$1./, @{$prefix[8]});
grep(s/(.*)/$1./, @{$prefix[9]});


# initialize some variables
$curLevel = 0;			# current indent level
$prevLevel = -1;		# previous indent level- starts less than cur
@levelCounter = (0,0,0,0,0);	# counters for each level

# default settings
$wrapWidth = 64;

################################### look for command line options ##################
use Getopt::Std;		# library routines for parsing arguments
getopts("hrumd:w:");
if($opt_w) { $wrapWidth = $opt_w; }
if($opt_u) { $suf ="\n"; }
if($opt_h) { printf ("   ?Options:
    -h  this message
    -d  'list'	use each char in 'list' as level char
    -u	inhibit ^M char at end of line (Unix form)
    -m  output is in Markdown-compatible form
    -r  raw output (reduce tabs to 4 spaces)
    -w ##		wrap output at char pos ##
    \n");
  exit(1);}
# Markdown: use 2 spaces per level; inhibit wrap; use MD-compat bullets
if($opt_m) { $outdent = "  "; $wrapWidth = 4011; $opt_d = "-*o"}
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
    ++ $levelCounter[$curLevel];  # increment the counter for this level
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
