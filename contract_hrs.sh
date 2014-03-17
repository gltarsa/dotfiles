#! /bin/ksh
tmpfile=/tmp/ch$$
datafile=$HOME/unpack/auto/chours.txt
csvfile=$HOME/unpack/auto/chours.csv

# ^  88... are the data lines we want to process
grep '^  88' >> $datafile

# set cleanup trap
trap 'rm -f $tmpfile' 0 1 12 15

# sort cumulative file and weed out duplicates
sort -u $datafile | sort -k 4 -k 3n -k 1n > $tmpfile
mv -f $datafile ${datafile}.bak
mv $tmpfile $datafile

exit

# Create the csv file  (must be changed to use char fields)
echo 'Voucher,Invoice,W/E,Name,Hours,"Labor $"' > $csvfile
awk -F'	' '{$4="@ "$4; OFS="	"; print}' $datafile |
  sed '	s/	/","/g
	s/^/"/
	s/$/"/'  >> $csvfile



# following code is used if you need the files to contain the report date

tmpfile=/tmp/ch$$
datafile=$HOME/unpack/chours.txt

# obtain the three types of lines we need
# ^PAY... may contain the date as the last word
# ^[0-9]... is the date if the ^PAY line does not contain it
# ^  88... are the data lines we want to process
egrep '^  88|^PAY\$ATE|^[0-9][0-9]*-[0-9][0-9]*-[0-9][0-9]*' > $tmpfile

# set cleanup trap
trap 'rm -f $tmpfile' 0 1 12 15

# extract the date.  If last word of ^PAY... line is "Usage", then the
# date was wrapped.
date=`grep '^PAY\$ATE' $tmpfile | sed 's/.* \(.*\)[ 	]*$/\1/'`
case $date in
    "Usage") date=`grep '^[0-9][0-9]*-[0-9][0-9]*-[0-9][0-9]*' $tmpfile`
        ;;
esac
    
#add the date to every line and append the lines to the cumulative data file
grep '^  88' $tmpfile | sed "s/^/$date /" >> $datafile

# sort cumulative file and weed out duplicates
sort -u $datafile > $tmpfile
mv -f $datafile ${datafile}.bak
mv $tmpfile $datafile








