#!/usr/bin/env python

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
# extensions_to_be_downloaded = [".pdf"]


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
    inputs = sys.argv

    if len(inputs) < 3:
        print("Expected two arguments!\n")
        print("The first argument should be the url of the webpage from where you intent to download all pdfs.")
        print("The Second argumnet should be the path to the diectory where you want to keep the downloaded files.")
        print("Followed by a list of file types you want to download. For e.g .mkv .mp4 .pdf")
        sys.exit(2)

    elif not os.path.isdir(inputs[2].strip()):
        print("The second argument must be a path to a directory!\n")
        sys.exit(2)

    else:
        url = inputs[1].strip()
        download_path = inputs[2].strip()
        extensions = inputs[3:]
        extensions = [each.strip() for each in extensions]

        try:
            if len(extensions) == 0:
                extensions = default_extensions
            parse_and_download(url, download_path, keep_link_string_as_name=True, extensions=extensions)

        except KeyboardInterrupt:
            print("\nExiting...")
            sys.exit(1)

        except Exception as e:
            print("Something went wrong!")
            print(e)
            sys.exit(2)
