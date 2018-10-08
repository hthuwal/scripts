#!/usr/bin/env python

import os
import argparse


def clean(folder, to_be_removed, recurse=True, delim=' '):
    if len(to_be_removed) > 0:
        for path in os.listdir(folder):

            filename, ext = os.path.splitext(path)

            if not filename.startswith('.'):  # Leave the hidden files/folders
                for string in to_be_removed:
                    filename = filename.replace(string, "").strip()

                filename = delim.join(filename.split('.')).strip()
                newpath = filename + ext

                sourcepath = os.path.join(folder, path)
                targetpath = os.path.join(folder, newpath)

                if path != newpath:
                    print("renaming: " + path + " to " + newpath)
                    os.rename(sourcepath, targetpath)

                if os.path.isdir(targetpath) and recurse:
                    clean(targetpath, to_be_removed)
                    os.rename(sourcepath, targetpath)
    else:
        print("Nothing to remove!\nPlease pass as arguments(space seperated) the strings that should be removed from the names")


if __name__ == '__main__':
    if len(sys.argv) > 1 and os.path.isdir(sys.argv[1]):
        folder = sys.argv[1]
        to_be_removed = sys.argv[2:]
        clean(folder, to_be_removed)
    else:
        print("First argument should be the path to a directory")
        sys.exit()
