#! /bin/sh
#
# Filter to remove an Exchange Forward header from an incoming message.
sed '	1,/------- Blind-Carbon-Copy/{
	    1,/-----Original Message-----/d
	    /^From:/{
		    s/\[mailto:/</
		    s/]/>/
		    }
	    /^Sent:/s//Date:/
	}'