# kmita.py - Simple crawler that looks for kmitaadmin
# by dual
#
# http://blog.theanti9.com/2009/02/14/python-web-crawler-in-less-than-50-lines/

import re
import sys
import urllib
import urlparse

crawled = set([])

def usage():
    print "kmita.py - Simple crawler that looks for kmitaadmin"
    print "Usage: kmita.py <http(s)://www.example.com>"
    sys.exit()

def kmita(kadmin_url):
    is_admin  = urllib.urlopen(kadmin_url)
    response  = is_admin.read()
    admin_str = re.search('Kmita Website Administration', response)
    if admin_str:
        print "success: " + kadmin_url

try:
    url = urlparse.urlparse(sys.argv[1])
except IndexError:
    usage()

if url.scheme == 'http' or url.scheme == 'https':
    if url.netloc != '':
        get_url = url.scheme + "://" + url.netloc + "/"
        tocrawl = set([get_url])
else:
    usage()

#print get_url
#print tocrawl

while 1:
    try:
        crawling = tocrawl.pop()
        print "DEBUG popped url: " + crawling
    except KeyError:
        raise StopIteration

    try:
        source = urllib.urlopen(crawling)
    except:
        continue

    response = source.readlines()

    print "DEBUG added " + crawling + " to crawled"
    crawled.add(crawling)
    print crawled

    for line in response:
        link = re.search('<a.*?href=[\'|"](http.*?)[\'"].*?>', line)
        if link:
            #print "DEBUG found link: " + link.group(1)
            parsed_link = urlparse.urlparse(link.group(1))
            skip_links  = re.search('(facebook\.com|google\.com|linkedin\.com|live\.com|twitter\.com|youtube\.com)', parsed_link.netloc)
            if skip_links:
                continue
            else:
                link_url    = parsed_link.scheme + "://" + parsed_link.netloc + "/"
                print "DEBUG link url: " + link_url
                kadmin_url  = parsed_link.scheme + "://" + parsed_link.netloc + "/kmitaadmin/index.php"
                #print kadmin_url
                kmita(kadmin_url)
                if link_url not in crawled:
                    tocrawl.add(link_url)
