#!/usr/bin/env python

import argparse
import os
import sys
import requests
from requests.compat import urljoin
from tqdm import tqdm
import math

try:
    from bs4 import BeautifulSoup
except ImportError:
    print("Please download and install BeautifulSoup first")
    sys.exit(0)

default_extensions = [".pdf"]


def parse_and_copy_links(url, out_file, extensions=default_extensions):
    with open(out_file, "w") as f:
        # open and read the url
        html = requests.get(url).text

        # creating a BeautifulSoup object, which represents
        # the document as a nested data structure:

        soup = BeautifulSoup(html, "lxml")

        for tag in soup.findAll('a', href=True):
            # incase the link is relative to url
            link = urljoin(url, tag['href'])

            basename = os.path.basename(link)
            extension = os.path.splitext(basename)[1]

            if extension in extensions:
                f.write("%s\n" % (link))


def parse_and_download(url, download_path, keep_link_string_as_name=True, extensions=default_extensions):
    '''
    open, parse a url and try to download all pdfs on that page

    Arguments:
        url -- url from where you want to download pdfs
        download_path -- location where to keep downloaded files

    Keyword-arguemnts:
        keep_link_string_as_name -- if false keep link basename as file name
        else keep the link string as filename(default is true)
    '''

    # open and read the url
    html = requests.get(url).text

    # creating a BeautifulSoup object, which represents
    # the document as a nested data structure:

    soup = BeautifulSoup(html, "lxml")

    num_files = 1
    failed = 0

    # find all <a> tags with href in them (links)
    for tag in soup.findAll('a', href=True):

        # incase the link is relative to url
        link = urljoin(url, tag['href'])

        basename = os.path.basename(link)
        extension = os.path.splitext(basename)[1]

        if extension in extensions:

            if tag.string is not None and keep_link_string_as_name is True:
                filepath = os.path.join(download_path, tag.string.strip(extension) + extension)
            else:
                filepath = os.path.join(download_path, basename)

            if not os.path.exists(filepath):
                try:
                    print("\n%d: Downloading %s" % (num_files, basename))

                    # Streaming, so we can iterate over the response.
                    r = requests.get(link, stream=True)

                    # Total size in bytes.
                    total_size = int(r.headers.get('content-length', 0))
                    block_size = 1024
                    wrote = 0
                    with open(filepath, 'wb') as f:
                        for data in tqdm(r.iter_content(block_size), total=math.ceil(total_size // block_size), unit='KB', unit_scale=True):
                            wrote = wrote + len(data)
                            f.write(data)

                except Exception as e:
                    failed += 1
                    print("\nCouldn't download %s" % (basename))
                    print(e)
                    if os.path.exists(filepath):
                        os.remove(filepath)
            else:
                print("\nSkipping %s" % (basename))
                print("File aleady exists")

    print("\n\n Successfully downloaded %d files" % (num_files - 1))
    print("\n %d files failed to download\n" % failed)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Extract/Download Links')
    parser.add_argument('url', type=str, help='Url of the Webpage from where you intent to download/extract links.')
    parser.add_argument('destination', type=str, help='Destination: Should be a directory. Or a FileName if -e is used')
    parser.add_argument('-e', action='store_true', help='Extract all the relevant links to \
        output file. (Default action is to download them in the output folder)')
    parser.add_argument('extensions', type=str, nargs='*', default=default_extensions, help='Space seperated list of file types to be extracted/downloade. For e.g. .mkv .mp4 .pdf')
    args = parser.parse_args()

    try:
        if args.e:
            print("Extracting all links ending in: %s\n" % " ".join(args.extensions))
            parse_and_copy_links(args.url, args.destination, extensions=args.extensions)
        elif not os.path.isdir(args.destination):
            print("For default action, The second argument must be a path to a directory!\n")
            sys.exit(2)
        else:
            print("Downloading all links ending in: %s\n" % " ".join(args.extensions))
            parse_and_download(args.url, args.destination, keep_link_string_as_name=True, extensions=args.extensions)
    except KeyboardInterrupt:
        print("\nExiting...")
        sys.exit(1)
    except Exception as e:
        print("Something went wrong!")
        print(e)
        sys.exit(2)
