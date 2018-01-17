# using beautiful soup for webpage parsing
import os
import sys
import urllib2
import urlparse

try:
    from bs4 import BeautifulSoup
except ImportError:
    print "Please download and install BeautifulSoup first"
    sys.exit(0)


def parse_and_download(url, download_path=os.getcwd()):

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
            filepath = os.path.join(download_path, basename)

            file = open(filepath, "wb")
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
                file.close()

    print "\n\n Successfully downloaded %d files" % (num_files - 1)
    print "\n %d files failed to download\n" % failed


if __name__ == '__main__':
    inputs = sys.argv

    if len(inputs) == 1:
        # TODO print help message
        pass

    else:
        url = inputs[1].strip()

        try:
            parse_and_download(url)

        except KeyboardInterrupt:
            print "\nExiting..."
            sys.exit(1)

        except Exception as e:
            print "Something went wrong!"
            print e
            sys.exit(2)
