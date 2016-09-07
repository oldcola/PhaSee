#!/bin/bash

# ================================================================================================
# Mock Repertoire Builder II by Antonios Vekris is licensed under a Creative Commons 
# Attribution-ShareAlike 4.0 International License. http://creativecommons.org/licenses/by-sa/4.0/
# Github 
# ================================================================================================

START_TIME=$SECONDS

# number of peptides and peptide's length
np=1000000
ps=11
# to calculate total of random numbers to generate
tl=$((np*ps))

echo "Building a Mock repertoire of $np peptides of $ps aa length"

# find total of aa in the 'frequencies' file
ul=0
while read -r a b; do
((ul=ul+b))
done < ~/aaf.txt

echo "There is a total of $ul elements in the aaf file"
 	
# store random numbers, one per line, upper limit at $ul 
 	awk 'BEGIN { for (i = 1; i <= '"$tl"'; i++) print int('"$ul"' * rand()) > "/Users/avek/randomscolumn.tabular"}'

# report 
 	MY_TIME=$(($SECONDS - $START_TIME))
	echo "randoms' column finished at sec "$MY_TIME
	echo "Starting substitutions"
	
# substitute numbers by aa
ll=0
ul=0
while read -r a b; do
	((ll=ul))
	((ul=ul+b))
	aa=$a
	   awk '{if ($1 >= '"$ll"' && $1 < '"$ul"' ) { print "'"$aa"'" } else { print $0 }}' < ~/randomscolumn.tabular > ~/tmp.tmp
	   mv ~/tmp.tmp ~/randomscolumn.tabular
done < ~/aaf.txt

# report 
 	MY_TIME=$(($SECONDS - $START_TIME))
	echo "substitutions finished at sec "$MY_TIME
	echo "grouping now"

# group per ps (peptide's size) aa 
awk '{printf("%s%s", $0, (NR%'"$ps"' ? "" : "\n"))}' < ~/randomscolumn.tabular > ~/tmp.tmp
mv ~/tmp.tmp ~/Mock_Repertoire.tabular

MY_TIME=$(($SECONDS - $START_TIME))
echo "all done at sec $MY_TIME"
pps=$((np/MY_TIME))
echo "performance: $pps peptides per sec"