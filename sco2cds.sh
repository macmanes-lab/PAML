#!/bin/bash

# To run, you must be in the `Results` folder produced by OrthoFinder
#
#  bash ./sco2cds.sh
#

#Give the name of the input file - this should be produced by sco.sh and filtered however you want to, e.g., to contain only certaint OrthoGroups



input=LASU_SCOs.txt

###
### No Editing below here
###

START=1
END=$(wc -l $input | awk '{print $1}')

mkdir OGs
for i in $(eval echo "{$START..$END}") ; do
    for j in $(sed -n ''$i'p' $input | awk '!array[$0]++'  | tr -s ' ' \\n) ; do
        grep --no-group-separator --max-count=1 -w -hA1 $j combined.fasta >> OGs/$(sed -n ''$i'p' $input | awk -F : '{print $1}').fasta;
    done
done
