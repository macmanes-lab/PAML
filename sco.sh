#!/bin/bash

# To run, you must be in the `Results` folder produced by OrthoFinder
#
#  bash ./sco.sh
#

#This script takes the output from OrthoFinder, contained in the OrthologousGroups.txt file, and pulls out the single copy orthologes
#The only thing you have to change is the number of species in your OrthoFinder run, so, change NSPECIES from 2 to whatever number is appropriate

#The only little issue is that you have to have your species names in some cogent way, so that each species is uniquely recognizable
#My protein names are like `Haliaeetus_albicilla_N`, where N is an integer.
#To disambiguate `Haliaeetus_albicilla` from `Haliaeetus_leucocephalus` I need 12 characters, which is why `awk '{print substr($0,0,12)}'` is 12 and not something else.
#look at `Results*/WorkingDirectory/SpeciesIDs.txt` to figure this out.


NSPECIES=47  #change this to however many species you are comparing.
TRUNC=12


###
### No Editing below here
###
min=$(expr $NSPECIES / 2 + 2)
equal=$(expr $NSPECIES + 1)
input=OrthologousGroups.txt
END=$(wc -l $input | awk '{print $1}')
START=1
LIMIT=$(expr $NSPECIES + 2)

rm SCOs.txt 2> /dev/null

for i in $(eval echo "{$START..$END}") ; do
    sed -n ''$i'p' $input | awk '!$var' var="$LIMIT" | awk '!array[$0]++'  | tr -s ' ' \\n | awk '{print substr($0,0,tr)}' tr="$TRUNC" | sort -u | wc -l > 1.txt;
    sed -n ''$i'p' $input | awk '!$var' var="$LIMIT" | awk '!array[$0]++'  | tr -s ' ' \\n | awk '{print substr($0,0,tr)}' tr="$TRUNC" | wc -l > 2.txt;
    if [ $(cat 1.txt) -eq $(cat 2.txt) ] && [ $(cat 1.txt) -gt "$min" ]; then sed -n ''$i'p' $input >> SCOs.txt; fi ;
done

rm 1.txt 2.txt 
