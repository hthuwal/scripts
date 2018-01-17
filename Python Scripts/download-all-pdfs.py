# using beautiful soup for webpage parsing
import sys
import urllib2

try:
    from bs4 import BeautifulSoup
except ImportError:
    print "Please download and install BeautifulSoup first"
    sys.exit(0)

inputs = sys.argv

if len(inputs) == 1:
    # TODO print help message
    pass
else:
    url = inputs[1].strip()

    try:
        request = urllib2.Request(url)
        html = urllib2.urlopen(request)
        # TODO html parsing

    except KeyboardInterrupt:
        print "\nExiting..."
        sys.exit(1)

    except Exception as e:
        print "Something went wrong!"
        print e
        sys.exit(2)
