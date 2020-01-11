#!/usr/bin/env python3

import argparse
import os
import platform
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
    cmd = get_cmd()
    if cmd is not None:
        print(f"Playing video: {video[0]}")
        subprocess.Popen([cmd, video[0]])
    else:
        print("Unsupported OS.")


def get_cmd():
    os_type = platform.system()
    if (os_type == "Darwin"):
        return "open"

    if (os_type == "Linux"):
        return "xdg-open"

    return None


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Randomly play a video from a given directory.')
    parser.add_argument('dir', help='path to directory containing videos.')
    args = parser.parse_args()
    play(args.dir)
