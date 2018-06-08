#!/usr/bin/env python

import os
import os.path as op
import sys


def main():
    if len(sys.argv) == 1:
        dirpath = os.getcwd()
    elif op.exists(sys.argv[1]):
        dirpath = sys.argv[1]

    cmd = "subliminal download -l en %s" % (dirpath)
    os.system(cmd)


if __name__ == '__main__':
    main()
