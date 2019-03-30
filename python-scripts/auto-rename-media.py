#!/usr/bin/env python

import argparse
import os
import string
import subprocess
import unicodedata

valid_filename_chars = "-_.() %s%s" % (string.ascii_letters, string.digits)
char_limit = 255
des = """
Rename a video or video files in a directory to their respective "Movie Name" from their metadata.
"""


def clean_filename(filename, whitelist=valid_filename_chars, replace=' '):
    # replace spaces
    # for r in replace:
        # filename = filename.replace(r, ' ')

    # keep only valid ascii chars
    cleaned_filename = unicodedata.normalize('NFKD', filename).encode('ASCII', 'ignore').decode()

    # keep only whitelisted chars
    cleaned_filename = ''.join(c for c in cleaned_filename if c in whitelist)

    # Truncate file names for windows
    if len(cleaned_filename) > char_limit:
        print("Warning, filename truncated because it was over {}. Filenames may no longer be unique".format(char_limit))
    return cleaned_filename[:char_limit]


def rename_video(video):
    src = os.path.dirname(video)
    video_name = os.path.basename(video)
    _, ext = os.path.splitext(video)

    command = ['mediainfo', '--Inform=General;%Movie%', video]
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    output, error = process.communicate()
    new_name = output.decode().strip()

    if new_name:
        new_name = clean_filename(new_name)
        new_name = new_name + ext
        new_name = os.path.join(src, new_name)
        print("Will rename:\n\t%s\tto\t%s" % (video_name, os.path.basename(new_name)))
    else:
        print("Unable to find Movie Name from metadata of %s\n" % video_name)

    return new_name


def rename_all_in_dir(src):
    proposed_changes = {}
    for file in os.listdir(src):
        file = os.path.join(src, file)
        new_name = rename_video(file)
        if new_name:
            proposed_changes[file] = new_name

    return proposed_changes


def rename(folder_or_video):
    proposed_changes = {}

    if os.path.isdir(folder_or_video):
        proposed_changes = rename_all_in_dir(folder_or_video)
    else:
        new_name = rename_video(folder_or_video)
        if new_name:
            proposed_changes = {folder_or_video: new_name}

    what_to_do = input("\nEnter yes to proceed with the changes: ")
    if what_to_do.lower() == "yes":
        for file in proposed_changes:
            print("Renaming:\t%s\tto\t%s" % (os.path.basename(file), os.path.basename(proposed_changes[file])))
            os.rename(file, proposed_changes[file])
    else:
        print("No changes will be made.")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=des)
    parser.add_argument('src', type=str, help='Path to a video or directory containing video files')
    args = parser.parse_args()
    rename(args.src)
