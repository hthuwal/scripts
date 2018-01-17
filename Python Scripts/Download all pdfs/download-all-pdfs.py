#!/usr/bin/env python

import os
import sys
import urllib2
import urlparse

try:
    from bs4 import BeautifulSoup
except ImportError:
    print "Please download and install BeautifulSoup first"
    sys.exit(0)


def parse_and_download(url, download_path, keep_link_string_as_name=True):
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
    html = urllib2.urlopen(url).read()
    # creating a BeautifulSoup object, which represents
    # the document as a nested data structure:
    soup = BeautifulSoup(html, "lxml")

    num_files = 1
    failed = 0

    # find all <a> tags with href in them (links)
    for tag in soup.findAll('a', href=True):

        # incase the link is relative to url
        link = urlparse.urljoin(url, tag['href'])

        basename = os.path.basename(link)
        extension = os.path.splitext(basename)[1]

        if extension == ".pdf":

            if tag.string is not None and keep_link_string_as_name is True:
                filepath = os.path.join(download_path, tag.string+".pdf")
            else:
                filepath = os.path.join(download_path, basename)

            if not os.path.exists(filepath):
                file = open(filepath, "wb")  # open filestream
                try:
                    print "\n%d: Downloading %s" % (num_files, basename)
                    # open a connection to this pdf
                    pdf = urllib2.urlopen(link)
                    file.write(pdf.read())
                    num_files += 1

                except Exception as e:
                    failed += 1
                    print "\nCouldn't download %s" % (basename)
                    print e
                    os.remove(filepath)

                finally:
                    file.close()  # close file stream
            else:
                print "\nSkipping %s" % (basename)
                print "File aleady exists"

    print "\n\n Successfully downloaded %d files" % (num_files - 1)
    print "\n %d files failed to download\n" % failed


if __name__ == '__main__':
    inputs = sys.argv

    if len(inputs) < 3:
        print "Expected two arguments!\n"
        print "The first argument should be the url of the webpage from where you intent to download all pdfs."
        print "The Second argumnet should be the path to the diectory where you want to keep the downloaded files."
        sys.exit(2)

    elif not os.path.isdir(inputs[2].strip()):
        print "The second argument must be a path to a directory!\n"
        sys.exit(2)

    else:
        url = inputs[1].strip()
        download_path = inputs[2].strip()
        try:
            parse_and_download(url, download_path, keep_link_string_as_name=True)

        except KeyboardInterrupt:
            print "\nExiting..."
            sys.exit(1)

        except Exception as e:
            print "Something went wrong!"
            print e
            sys.exit(2)
