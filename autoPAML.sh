#! /bin/bash

usage=$(cat << EOF
   # This script runs a pipeline that takes a fasta file and BAMfiles and tests for selection:
   #

   autoPAML.sh [options]
   Options:
      -t <v> : *required* Number of threads to use.
      -l <v> : *required* Code for foreground lineage (must work in regex)
EOF
);

while getopts l:t: option
do
        case "${option}"
        in
		t) TC=${OPTARG};;
		l) LI=${OPTARG};;		
        esac
done

##Align

for inputaln in $(ls *fasta); do
    F=$(basename "$inputaln" .fasta)
    if [ $(ps -all | grep 'prank\|codeml\|raxmlHPC' | wc -l | awk '{print $1}') -lt $TC ] ;
    then
        if [ ! -f $F.out ] ;
        then
            echo 'processing' $inputaln
            awk '{print $1}' $inputaln > tmp && mv tmp $inputaln
            prank -d="$inputaln" -translate -F -o=$F &&
            perl /share/pal2nal.v14/pal2nal.pl $F.best.pep.fas $F.best.nuc.fas -output fasta -nogap -nomismatch > $F.clean || true &&
            raxmlHPC-PTHREADS -f a -m GTRGAMMA -T 2 -x $RANDOM -N 100 -n $F.tree -s $F.clean -p $RANDOM &&
            sed -i -r 's/$LI_[0-9]{2,}-RA:[0-9]{1,}.[0-9]{2,}/& #1/g' RAxML_bestTree.$F.tree
            python autoPAML.py $F.clean RAxML_bestTree.$F.tree $F.out &&
            python autoPAMLresults.py $F.out | tee -a paml.results &
        else
            echo 'next'
        fi
    else
        until [ $(ps -all | grep 'prank\|codeml\|raxmlHPC' | wc -l | awk '{print $1}') -lt $TC ] ;
        do
            echo 'waiting for' $inputaln
            sleep 25s;
        done
        if [ ! -f $F.out ] ;
        then
            awk '{print $1}' $inputaln > tmp && mv tmp $inputaln
            prank -d="$inputaln" -translate -F -o=$F &&
            perl /share/pal2nal.v14/pal2nal.pl $F.best.pep.fas $F.best.nuc.fas -output fasta -nogap -nomismatch > $F.clean || true &&
            raxmlHPC-PTHREADS -f a -m GTRGAMMA -T 2 -x $RANDOM -N 100 -n $F.tree -s $F.clean -p $RANDOM &&
            python autoPAML.py $F.clean RAxML_bestTree.$F.tree $F.out &&
            python autoPAMLresults.py $F.out | tee -a paml.results &
        else
            echo 'moving on'
        fi
    fi
done
