import argparse
import os
import string
import subprocess
import sys
import unicodedata

valid_filename_chars = "-_.() %s%s" % (string.ascii_letters, string.digits)
char_limit = 255
des = """
Rename Video Files based on their titles.

Assumption:
    Video are named as per their order.
    e.g. 1.mp4, 2.mp4 etc...
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


def rename(src):
    if not os.path.isdir(src):
        print("%s is not a path to a valid directory" % (src))
        sys.exit(1)

    proposed_changes = {}
    for file in os.listdir(src):
        num, ext = os.path.splitext(file)
        try:
            num = int(num.split()[0])
        except Exception:
            print("File names should start with a number denoting its order among all the files.")
            sys.exit()

        file = os.path.join(src, file)
        command = ['mediainfo', '--Inform=General;%Movie%', file]
        process = subprocess.Popen(command, stdout=subprocess.PIPE)
        output, error = process.communicate()
        new_name = output.decode().strip()

        if new_name:
            new_name = clean_filename(new_name)
            new_name = "%02d" % num + " " + new_name + ext
            new_name = os.path.join(src, new_name)
            print("Will rename:\t%s\tto\t%s" % (os.path.basename(file), os.path.basename(new_name)))
            proposed_changes[file] = new_name

    what_to_do = input("\nEnter yes to proceed with the changes: ").strip()
    if what_to_do.lower() == "yes":
        for file in proposed_changes:
            print("Renaming:\t%s\tto\t%s" % (os.path.basename(file), os.path.basename(proposed_changes[file])))
            os.rename(file, proposed_changes[file])
    else:
        print("No changes will be made.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=des)
    parser.add_argument('src', type=str, help='Path to directory containing video files')
    args = parser.parse_args()
    rename(args.src)
