#!/bin/sh
nawk '
    BEGIN { debug = 0 }
    $1 == "begin" && NF == 3 {
		# IF we encounter a valid begin w/o seeing an end, fake an end
	        if (in_prog)
		    {
		    printf "\nend\n" | prog
		    close(prog); prog = ""
		    }		

		 # increment the file number, set the "in" flag
		 file++
		 in_prog = 1
		 saved_lines = 0
	         print "file #" file

		 prog = "uudecode"
#		 prog = "cat"

	         print $0 | prog
		 if (debug) printf("debug: %s\n", $0);
	         next}
    # "end" alone on a line terminates a set
    $0 == "end" && in_prog == 1 {
		print "done file #" file
		if (debug) print "debug: done file #" file
	        in_prog = 0
	        if (saved_lines > 0 && saved_lines <= 3)
		    for (i = 0; i < saved_lines; i++)
		        print saved[i] | prog
		print $0 | prog
	        close(prog)
		prog = ""
		next}
    prog == "" { if (debug) printf("debug: skipping: %s\n", $0); next}
    in_prog == 1 { if (length($0) == 61)
		    {
                    print $0 | prog
		    if (saved_lines)
			saved_lines = 0
		    }
		 else
		    {
		    if (saved_lines < 3)
			{
			if (debug)
			    printf("debug2: saving[%d]: %s\n", saved_lines, $0);
			saved[saved_lines++] = $0
			}
		    else
		        if (debug)
			    printf("debug2 skipping: %s\n", $0);
		    }

		next}
    {if (debug) printf("debug: nexting past: %s\n", $0); next}
	' $1
