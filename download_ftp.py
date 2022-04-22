#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 11 11:11:06 2022

@author: david
"""
# https://www.educative.io/edpresso/what-is-the-html-parser-in-python
import requests
import re
# def extract(url):
#     # Get webpage
#     response = requests.get(url)
#     # Get page source
#     #print(response.text)
#     result = re.findall('<a[^>]*>', response.text)
#     print(result)
    
url = "http://ftp.ebi.ac.uk/pride-archive/2014/09/PXD000279/"

#extract(url)


from html.parser import HTMLParser

class MyHTMLParser(HTMLParser):
    """This child class defines a method to handle starttags.
    See https://docs.python.org/3/library/html.parser.html
    """
    def handle_starttag(self, tag, attrs):
        global results
        #results = []
        if tag != 'a':  # we're only interested in <a> tags
            return
        #print(attrs)
        #ls.append(attrs[0][1])
        #print(attrs[0][1])
        results.append(attrs[0][1])
        #print(ls)
        #return ls
        #print(type(attrs[0][1]))
    # def get_links(self, attr):
    #     count = 0 
    #     print(type(attr))
    #     for i in attr:
    #         count += 1
    #         #print(f"http://ftp.ebi.ac.uk/pride-archive/2014/09/PXD000279/{attrs}")
    #     print(count)

        
# def extract(url):    
#     response = requests.get(url)
#     parser = MyHTMLParser()
#     parser.feed(response.text)
#     #return parser.feed(response.text)
#     return parser
results = []   
 
response = requests.get(url)
parser = MyHTMLParser()
parser.feed(response.text)


base = "http://ftp.ebi.ac.uk/pride-archive/2014/09/PXD000279/"
for i in results:
    if "raw" in i.lower():
        print(base+i)
