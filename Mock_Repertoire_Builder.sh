#!/bin/bash

# ================================================================================================
# Mock Repertoire Builder by Antonios Vekris is licensed under a Creative Commons 
# Attribution-ShareAlike 4.0 International License. http://creativecommons.org/licenses/by-sa/4.0/
# ================================================================================================

# function to shuffle array "array"
	shuffle() {
		local i tmp size max rand
		size=${#array[@]}
		max=$(( 32768 / size * size ))
			for ((i=size-1; i>0; i--)); do
				while (( (rand=$RANDOM) >= max )); do :; done
				rand=$(( rand % (i+1) ))
				tmp=${array[i]} array[i]=${array[rand]}" " array[rand]=$tmp
			done
	}
 
# create temporary file temp; folder Desktop must be present to the user's home
# if necessary uncomment the following line
# mkdir -p /Desktop
	> ~/Desktop/temp.tabular

# STEP ONE ===============================================================================

#initiate timer
	START_TIME=$SECONDS
# using awk to store a series of random numbers in temp
# lim of i equals size of the peptides by the number of them
	awk 'BEGIN { for (i = 1; i <= 11000000; i++) print int(1001 * rand()) > "/Users/avek/Desktop/temp.tabular"}'

# echo time necessary to populate temp
	MY_TIME=$(($SECONDS - $START_TIME))
	echo "made temp in "$MY_TIME

# read from temp and rearrange the random numbers by the size of the peptides, hardcoded as 11 here, in ...(ND%11...
	awk '{printf("%s%s", $0, (NR%11 ? " " : "\n"))}' < ~/Desktop/temp.tabular > ~/Desktop/finalhalf.tabular

# echo time necessary to populate temp and rearrange in finalhalf
	MY_TIME=$(($SECONDS - $START_TIME))
	echo "made final in "$MY_TIME

# clean
	rm -f ~/Desktop/temp.tabular

# STEP TWO ===============================================================================

# initialize array and index of it
	array=()
	j=0

# populate array using aa frequencies (expressed as integers); file hardcoded as raaf12_1001
	while read -r a b; do
	   for i in $(seq 1 $b);do array[j]=$a" ";j=$j+1; done
	done < ~/Desktop/raaf12_1001.txt

# shuffle array (thrice for the fun of it)
	shuffle; shuffle; shuffle

# store length of array in space
	space=${#array[@]}

# echo the time in seconds to finish with the jobs up to now
	MY_TIME=$(($SECONDS - $START_TIME))
	echo "aa array of $space built and shuffled thrice "$MY_TIME

# STEP THREE =============================================================================

# initialize second timer (just to follow up the job)
	SED_TIME=$SECONDS

# using sed replace random numbers with aa from (shuffled) array
	for ((i=0; i<space; i++)); do
		sed -i ''  "s/[[:<:]]$i[[:>:]]/${array[$i]}/g" ~/Desktop/finalhalf.tabular # the regex [[:<:]]$i[[:>:]] should be OK in any bash
		# uncomment the two following lines for a followup in terminal
		# 	MY_TIME2=$(($SECONDS - $SED_TIME))
		# 	echo "$SECONDS	$MY_TIME2"
	done

# take out unwanted spaces
	sed 's/ \{1,\}//g' ~/Desktop/final.tabular
# rename file
	mv ~/Desktop/final.tabular ~/Desktop/peptideshalf.tabular

# report total time
	MY_TIME=$(($SECONDS - $START_TIME))
	echo "for 1 million peptides "$MY_TIME
	
	