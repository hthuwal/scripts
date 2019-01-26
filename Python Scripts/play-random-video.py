#!/usr/bin/env python

import argparse
import os
import random
import subprocess
import sys


def play(path):
    extensions = [".mkv", ".mp4", ".m4v", ".mov", ".wmv"]
    if not os.path.isdir(path):
        print("%s is not a valid path." % (path))
        sys.exit(1)

    content = list(os.walk(path))
    all_files = []
    for each in content:
        root_dir = each[0]
        files = each[2]
        for file in files:
            base, ext = os.path.splitext(file)
            if ext.lower() in extensions:
                all_files.append(os.path.join(root_dir, file))

    video = random.sample(all_files, 1)
    subprocess.Popen(["xdg-open", video[0]])
    print(video[0])


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Randomly play a video from a given directory.')
    parser.add_argument('dir', help='path to directory containing videos.')
    args = parser.parse_args()
    play(args.dir)
