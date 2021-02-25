
#!/bin/env python3
# -*- coding: utf-8 -*-

import sys
from logging import CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET

from jPyLibs.jGenericLib import jConstant

class constants():
    @jConstant
    def MIN_PYTHON():
        return (3, 8)

    @jConstant
    def APLICATION_DESCRIPTION():
        return 'Change to proper name'
    
    @jConstant
    def LOG_LEVELS():
        return {"CRITICAL": CRITICAL, "ERROR": ERROR, "WARNING": WARNING, "INFO": INFO, "NOTSET": NOTSET}

C = constants()

if __name__ == '__main__':
    print('jPython utilities. The module should not be used stand alone.')
    sys.exit(1)
