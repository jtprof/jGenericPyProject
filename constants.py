
#!/bin/env python3
# -*- coding: utf-8 -*-

import sys
from logging import CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET

from jpylib.core import jConstant

class constants():
    LOG_LEVELS = {"CRITICAL": CRITICAL, "ERROR": ERROR, "WARNING": WARNING, "INFO": INFO, "DEBUG": DEBUG, "NOTSET": NOTSET}

    @jConstant
    def MIN_PYTHON(self):
        """ Minimum required Python version"""
        return (3, 8)

    @jConstant
    def APLICATION_DESCRIPTION(self):
        """ Application user frendly description """
        return 'Change to proper name'

    @jConstant
    def VAR_VERBOSE(self):
        """ Argument variable name for VERBOSE flag """
        return "VERBOSE"

    @jConstant
    def VAR_REMOTE_DBG(self):
        """ Argument variable name for remote debug flag """
        return "REMOTE_DEBUG"

    @jConstant
    def VAR_LOG_LEVEL(self):
        """ Argument variable name for loggin level """
        return "LOG_LEVEL"

    @jConstant
    def VAR_LOG_FILE(self):
        """ Argument variable name for logging file """
        return "LOG_FILE"

C = constants()

if __name__ == '__main__':
    print('jPython utilities. The module should not be used stand alone.')
    sys.exit(1)
