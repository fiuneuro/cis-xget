#!/usr/bin/env python
from pyxnat import Interface
import sys

config_file = sys.argv[1]
project = sys.argv[2]
ref = sys.argv[3]

central = Interface(config=config_file)
select_exp = '/projects/' + project +'/experiments'
exps = central.select(select_exp).get()
if ref == 'experiments':
    print " ".join([str(x) for x in exps])
elif ref == 'labels':
    print " ".join([central.select(select_exp + '/' + x).label() for x in exps])
