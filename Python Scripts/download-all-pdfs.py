# using beautiful soup for webpage parsing
import sys

try:
    from bs4 import BeautifulSoup
except ImportError:
    print "Please download and install BeautifulSoup first"
    sys.exit(0)

