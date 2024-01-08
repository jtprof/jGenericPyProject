#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""This is a new project template.

CHANGE ME as soon as copy to real project!
"""

__version__ = '0.7'
__author__ = 'Dmitry Togushev'

import sys
import os
import logging
import argparse
import debugpy

from jpylib.core import str2bool
from jpylib.core import EnvDefault

from constants import C

def action(**kwargs):
    """ Actions """
    logging.info("Hellow word!")
    for key, value in kwargs.items():
        logging.info("Param: %s = %s",  key, value )

def main():
    """ Main func """
    aparse = argparse.ArgumentParser(description = f'Application title:\t{C.APLICATION_DESCRIPTION}\n\
        Application path:\t{os.getcwd()}\n\
        Python version used:\t{sys.version_info}\n\
        Python execute path:\t{os.path.dirname(sys.executable)}\n\
        Python library path:\t{sys.path} ',
        epilog=f"Python {C.MIN_PYTHON[0]}.{C.MIN_PYTHON[1]} or later required",
        formatter_class=argparse.RawDescriptionHelpFormatter)

    aparse.add_argument('-v', '--verbose', help = 'Verbose mode', type = str2bool, action = EnvDefault, envvar = C.VAR_VERBOSE, default = False, required = False, choices = None, const = True, nargs = '?', dest = C.VAR_VERBOSE)
    aparse.add_argument('-d', '--remote-debug', help = 'Start internal service for remote', type = str2bool, action = EnvDefault, envvar = C.VAR_REMOTE_DBG, default = False, required = False, choices = None, const = True, nargs = '?', dest = C.VAR_REMOTE_DBG)
    aparse.add_argument('-L', '--log-level', help = 'Log level', type = str, action = EnvDefault, envvar = C.VAR_LOG_LEVEL, default = 'INFO', required = False, choices = list(C.LOG_LEVELS), const = True, nargs = '?', dest = C.VAR_LOG_LEVEL)
    aparse.add_argument('-l', '--log-file', help = 'Log file name. Show log to console if empty.', type = str, action = EnvDefault, envvar = C.VAR_LOG_LEVEL, default = None, required = False, choices = None, const = True, nargs = '?', dest = C.VAR_LOG_FILE)

    args  = vars(aparse.parse_args())

    if sys.version_info[0] < C.MIN_PYTHON[0] or sys.version_info[1] < C.MIN_PYTHON[1]:
        aparse.print_help(file=None)
        sys.exit(1)

    if args[C.VAR_LOG_FILE] is not None:
        logging.basicConfig(filename=args[C.VAR_LOG_FILE], datefmt='%Y.%m.%d %H:%M:%S', format='%(asctime)s %(levelname)-8s %(message)s')
    else:
        logging.basicConfig(datefmt='%Y.%m.%d %H:%M:%S', format='%(asctime)s %(levelname)-8s %(message)s')
    logging.getLogger().setLevel(C.LOG_LEVELS[args[C.VAR_LOG_LEVEL]])

    if args[C.VAR_REMOTE_DBG]:
        debugpy.listen(('0.0.0.0', 5678))
        debugpy.wait_for_client()

    action(**args)

if __name__ == '__main__':
    main()
