#!/usr/bin/env python

import os
import sys

safe_extensions = [".txt"]


def clean(folder, to_be_removed, recurse=True):
    if len(to_be_removed) > 0:
        for path in os.listdir(folder):

            filename, ext = os.path.splitext(path)

            if ext not in safe_extensions:
                for string in to_be_removed:
                    filename = filename.replace(string, "").strip()

                filename = " ".join(filename.split('.')).strip()
                newpath = filename + ext

                sourcepath = os.path.join(folder, path)
                targetpath = os.path.join(folder, newpath)

                if path != newpath:
                    print("renaming: " + path + " to " + newpath)
                    os.rename(sourcepath, targetpath)

                if os.path.isdir(targetpath) and recurse:
                    clean(targetpath, to_be_removed)
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
