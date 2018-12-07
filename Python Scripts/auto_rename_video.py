import os
import subprocess
import sys
import unicodedata
import string

src = os.path.abspath(sys.argv[1])


valid_filename_chars = "-_.() %s%s" % (string.ascii_letters, string.digits)
char_limit = 255


def clean_filename(filename, whitelist=valid_filename_chars, replace=' '):
    # replace spaces
    for r in replace:
        filename = filename.replace(r, '-')

    # keep only valid ascii chars
    cleaned_filename = unicodedata.normalize('NFKD', filename).encode('ASCII', 'ignore').decode()

    # keep only whitelisted chars
    cleaned_filename = ''.join(c for c in cleaned_filename if c in whitelist)

    # Truncate file names for windows
    if len(cleaned_filename) > char_limit:
        print("Warning, filename truncated because it was over {}. Filenames may no longer be unique".format(char_limit))
    return cleaned_filename[:char_limit]


for file in os.listdir(sys.argv[1]):
    num, ext = os.path.splitext(file)
    num = int(num)
    file = os.path.join(src, file)

    command = ['mediainfo', '--Inform=General;%Movie%', file]
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    output, error = process.communicate()

    new_name = output.decode().strip()
    if new_name:
        new_name = clean_filename(new_name)
        new_name = "%02d" % num + " " + new_name + ext
        new_name = os.path.join(src, new_name)
        print("Renaming %s to \t %s" % (os.path.basename(file), os.path.basename(new_name)))
        os.rename(file, new_name)
