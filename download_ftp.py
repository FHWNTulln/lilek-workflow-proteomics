#!/usr/bin/env python3

"""
script for downloading raw-files from FTP server

to download files run the following command in a bash terminal

python download_ftp.py | wget -c -i- 

flag -c: try to continue aborted download
flag -i-: read the URL from stdin

@author: david
"""

import requests
import re
from html.parser import HTMLParser

# define url where data should be downloaded    
url = "http://ftp.ebi.ac.uk/pride-archive/2014/09/PXD000279/"

# create class HTML parser to get links from FTP server
class MyHTMLParser(HTMLParser):
    """This child class defines a method to handle starttags.
    See https://docs.python.org/3/library/html.parser.html
    """
    def handle_starttag(self, tag, attrs):
        global results
        #results = []
        if tag != 'a':  # we're only interested in <a> tags
            return
        results.append(attrs[0][1])

# create list with results and get urls         
results = []   
response = requests.get(url)
parser = MyHTMLParser()
parser.feed(response.text)

# print links for raw files
base = "http://ftp.ebi.ac.uk/pride-archive/2014/09/PXD000279/"
for i in results:
    if "raw" in i.lower():
        print(base+i)