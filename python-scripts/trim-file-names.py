#!/usr/bin/env python

import os
import argparse

USUAL_CRAP = ['720p', 'WEBRip', '2CH', 'x265', 'HEVC-PSA', 'WEB-DL', '1080p', '10bit', '6CH', 'BrRip', ]


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
    parser = argparse.ArgumentParser(description='Trim all file/folder names by \
        removing specific substrings and replacing all \'.\' by delim except the last.')
    parser.add_argument('directory', type=str, help='Path to directory whose content\'s name needs to be trimmed.')
    parser.add_argument('-s', '--substrings', type=str, nargs='+', help='The substrings that you want to remove from filenames.')
    parser.add_argument('-a', action='store_true', help='Append the substrings to be removed default list.')
    parser.add_argument('-d', '--delim', type=str, default=' ', help='Delimiter used to replace all \'.\'. Default is space.')
    parser.add_argument('-r', action='store_true', help='Recurse into the subdirectories.')
    args = parser.parse_args()

    if not args.substrings:
        args.substrings = USUAL_CRAP
    elif args.a:
        args.substrings += USUAL_CRAP

    if os.path.isdir(args.directory):
        clean(args.directory, args.substrings, args.r, args.delim)
    else:
        print("Error: %s is not a valid directory." % (args.directory))
