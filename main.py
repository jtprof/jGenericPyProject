#!/bin/env python3
# -*- coding: utf-8 -*-
"""This is a new project template.

CHANGE ME as soon as copy to real project!
"""

__version__ = '0.1'
__author__ = 'Dmitry Togushev'

import sys
import os
import logging
import argparse
from datetime import datetime as dt

from constants import C
from jPyLibs.jGenericLib import str2bool

def main(**kwargs):
    pass
    print("Hellow word!")

if __name__ == '__main__':
    argslist = [
        {'flagname1': '-v', 'flagname2': '--verbose', 'action': 'store_true', 'nargs': '?', 'const': True, 'default': False, 'type': str2bool, 'choices': None, 'required': False, 'help': 'Verbose mode', 'metavar': None, 'dest': 'verbose'},
        {'flagname1': '-d', 'flagname2': '--remote-debug', 'action': 'store_true', 'nargs': '?', 'const': True, 'default': False, 'type': str2bool, 'choices': None, 'required': False, 'help': 'Start internal service for remote', 'metavar': None, 'dest': 'remote_debug'},
        {'flagname1': '-L', 'flagname2': '--log-level', 'action': 'store_true', 'nargs': '?', 'const': True, 'default': "INFO", 'type': str, 'choices': [key for key in C.LOG_LEVELS], 'required': False, 'help': 'Log level', 'metavar': None, 'dest': 'loglevel'},
        {'flagname1': '-l', 'flagname2': '--log-file', 'action': 'store_true', 'nargs': '?', 'const': True, 'default': None, 'type': str, 'choices': None, 'required': False, 'help': 'Log file name. Show log to console if empty.', 'metavar': None, 'dest': 'logfile'},
        ]
    
    aparse = argparse.ArgumentParser(description = 'Application title:\t{app_desc}\nApplication path:\t{app_path}\nPython version used:\t{py_ver}\nPython execute path:\t{py_ex_path}\nPython library path:\t{py_path} '.format(\
            app_desc=C.APLICATION_DESCRIPTION, \
            py_ver=sys.version_info, \
            py_path=sys.path, \
            app_path=os.getcwd(), \
            py_ex_path=os.path.dirname(sys.executable) \
                ), \
        epilog="Python {}.{} or later required".format(C.MIN_PYTHON[0], C.MIN_PYTHON[1]), \
        formatter_class=argparse.RawDescriptionHelpFormatter)

    for a in argslist:
        aparse.add_argument(a['flagname1'], a['flagname2'], help = a['help'], dest = a['dest'], type = a['type'], default = a['default'], required = a['required'], choices = a['choices'], const = a['const'], nargs = a['nargs'])
        #aparse.add_argument(**a)

    args  = aparse.parse_args()

    if sys.version_info < C.MIN_PYTHON:
        aparse.print_help(file=None)
        sys.exit(1)

    if args.logfile is not None:
        logging.basicConfig(filename=args.logfile, datefmt='%Y.%m.%d %H:%M:%S', format=f'%(asctime)s %(levelname)-8s %(message)s')
    else:
        logging.basicConfig(datefmt='%Y.%m.%d %H:%M:%S', format=f'%(asctime)s %(levelname)-8s %(message)s')
    logging.getLogger().setLevel(C.LOG_LEVELS[args.loglevel])

    if args.remote_debug:
        import debugpy
        debugpy.listen(('0.0.0.0', 5678))
        debugpy.wait_for_client()

    main(**vars(args))
