#!/usr/bin/make -rRsf

SHELL=/bin/bash -o pipefail

#USAGE:
#
#	run_orthofinder.mk GENOMEDIR=/home/ubuntu/genomes/ CPU=16
#

MAKEDIR := $(dir $(firstword $(MAKEFILE_LIST)))
DIR := ${CURDIR}
GENOMEDIR :=
CPU=16



#Orthofinder
#sco.sh pull put list of SCO's
#sco2cds.sh get the CDS's for those
#autoPAML.sh run PAML branch site model


prep: setup scripts
main: orthofinder sco sco2cds autoPAML
sco:SCOs.txt

subsamp_reads:${SAMP}.subsamp_1.fastq ${SAMP}.subsamp_2.fastq

.DELETE_ON_ERROR:

setup:
	mkdir -p ${DIR}/error_profiles
	mkdir -p ${DIR}/assemblies

orthofinder:
	python orthofinder.py -f ${GENOMEDIR} -t ${CPU}

SCOs.txt:
	bash ./sco.sh

sco2cds:
	bash ./sco2cds.sh

autoPAML:
	bash ./autoPAML.sh -t ${CPU}
