#!/usr/bin/python

#usage  python autoPAML.py alignment.fasta tree.nexus paml.output

from __future__ import division
from Bio.Phylo.PAML import codeml
import sys

if len(sys.argv) != 4:
        print "Error.  our missing an input file, see the usage"
        quit()

cml = codeml.Codeml()
cml.read_ctl_file("codeml.ctl")
cml.alignment = sys.argv[1]
cml.tree = sys.argv[2]
cml.out_file = sys.argv[3]
cml.run()
