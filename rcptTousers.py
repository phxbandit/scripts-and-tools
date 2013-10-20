#!/usr/bin/python

import re
import socket
import sys

smtpReply = re.compile('550')

if len(sys.argv) != 3:
    print "Usage: rcptTousers.py <host> <username>"
    sys.exit(0)

# Create a socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect to the server
connect=s.connect((sys.argv[1],25))

# Receive the banner
banner=s.recv(1024)
#print banner

# Send HELO
s.send('HELO example.com\r\n')
helo = s.recv(1024)
#print helo

# MAIL FROM
s.send('MAIL FROM:administrator@example.com\r\n')
mailFrom = s.recv(1024)
#print mailFrom

# RCPT TO to find users
s.send('RCPT TO:' + sys.argv[2] + '\r\n')
rcptTo = s.recv(1024)
#print rcptTo
ifFail = re.search(smtpReply, rcptTo)
if ifFail:
    pass
    #print sys.argv[2]
else:
    print 'SUCCESS: ' + sys.argv[2]

# Close the socket
s.close()
