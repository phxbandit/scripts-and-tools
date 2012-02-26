#!/usr/bin/env python

# spiga.py v0.7 - Configurable web resource scanner
# by dual
#
# Please read spiga.conf and spiga.py -h for instructions.

import argparse, os, Queue, random, re, sys, threading, time, urllib, urlparse

# Define the number of threads to use here
NO_OF_THREADS = 5

# Define the random number of seconds to sleep
TIME_TO_SLEEP = 5

# Create queue for threads
queue = Queue.Queue()

class ThreadScan(threading.Thread):
    """Threaded scanning"""
    def __init__(self, queue):
        threading.Thread.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            # Grab resources from queue
            items          = self.queue.get()
            func_call_dirs = items[0]
            target         = items[1]
            func_action    = items[2]
            action_value   = items[3]

            # Scanner function
            if func_action == 'code':
                for i in func_call_dirs:
                    target_dir = target + "/" + i
                    (code, response) = useragent(target_dir)
                    if args.SLEEP:
                        sleep_time = random.randint(1,TIME_TO_SLEEP)
                        time.sleep(sleep_time)
                    if args.REQUESTS:
                        print target_dir
                    if str(code) == action_value:
                        print "SUCCESS -> %s" % (target_dir)
            elif func_action == 'dump':
                for i in func_call_dirs:
                    target_dir = target + "/" + i
                    (code, response) = useragent(target_dir)
                    if code == 200:
                        print "Dumping %s" % (target_dir)
                        print response
                    else:
                        print "No %s to dump" % (target_dir)
            elif func_action == 'search':
                for i in func_call_dirs:
                    target_dir = target + "/" + i
                    (code, response) = useragent(target_dir)
                    if args.SLEEP:
                        sleep_time = random.randint(1,TIME_TO_SLEEP)
                        time.sleep(sleep_time)
                    if args.REQUESTS:
                        print target_dir
                    search_str = re.search(action_value, response)
                    if search_str:
                        print "SUCCESS -> %s found in %s" % (action_value, target_dir)

            # Signals to queue job is done
            self.queue.task_done()

class myURLopener(urllib.FancyURLopener):
    """urllib 401 error handling workaround from
    http://cis.poly.edu/cs912/urlopen.txt""" 
    def http_error_401(self, url, fp, errcode, errmsg, headers, data=None):
        print "BASIC AUTH FOUND -> run with -r to see the protected resource"

url_opener = myURLopener()

def useragent(target_dir):
    """Fetch the resource"""
    try:
        ua = url_opener.open(target_dir)
    except IOError:
        print "FAIL -> domain does not exist or is not responding"
        os._exit(os.EX_NOHOST)
    code = ua.getcode()
    response = ua.read()
    return(code, response)

def check_url(url_arg):
    """Verify that the target domain is valid"""
    url = urlparse.urlparse(url_arg)
    if url.scheme == 'http' or url.scheme == 'https':
        if url.netloc != '':
            target = url.scheme + "://" + url.netloc
    else:
        print "Please use target domain like http(s)://www.example.com... exiting"
        sys.exit()
    return target

if __name__ == '__main__':
    # Initialize
    main_func_calls    = []
    main_func_dirs     = []
    func_action_names  = []
    func_action_values = []
    func_check = 0
    SLEEP      = 0

    # Parse arguments
    parser = argparse.ArgumentParser(description='spiga.py - Configurable web resource scanner')

    parser.add_argument(action='store', dest='TARGET', help='scan target domain like http(s)://www.example.com')
    parser.add_argument('-c', '--conf', action='store', dest='CONF', default='spiga.conf', help='choose conf file location')
    parser.add_argument('-r', '--requests', action='store_true', dest='REQUESTS', default=False, help='show all requests')
    parser.add_argument('-s', '--sleep', action='store_true', dest='SLEEP', default=False, help='sleep a random number of seconds between requests')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s 0.7', help='show version number and exit')

    args = parser.parse_args()

    # Verify and assign URL
    target = check_url(args.TARGET)

    # spiga.conf parsing regexes
    conf_comment  = re.compile('^#')
    conf_beg_func = re.compile('^\(\)(.*?)\s*{$')
    conf_action   = re.compile('^;(.*?)=(.*)$')
    conf_end_func = re.compile('^}$')

    # Open and read spiga.conf
    try:
        conf = open(args.CONF, 'r')
    except:
        print "No spiga.conf file present... exiting"
        sys.exit()
    conf_lines = conf.readlines()

    # Parse spiga.conf
    for tmp_line in conf_lines:
        line = tmp_line.strip()

        beg_func = re.search(conf_beg_func, line)
        if beg_func:
            func_call = beg_func.group(1)
            main_func_calls.append(func_call)
            func_call_dirs = func_call + "_dirs"
            func_call_dirs = []
            func_check = 1
            continue

        action = re.search(conf_action, line)
        if action:
            action_name = action.group(1)
            action_value = action.group(2)
            func_action_name = func_call + "_" + action_name
            func_action_names.append(func_action_name)
            func_action_values.append(action_value)
            continue

        comment = re.search(conf_comment, line)
        if comment:
            continue

        end_func = re.search(conf_end_func, line)

        if func_check:
            if end_func:
                func_check = 0
                main_func_dirs.append(func_call_dirs)
                continue
            func_call_dirs.append(line)

    # Create function and action dictionaries from lists
    dict_of_funcs   = dict(zip(main_func_calls, main_func_dirs))
    dict_of_actions = dict(zip(func_action_names, func_action_values))

    # Timestamp and opening message
    iso8601 = time.strftime("%Y-%m-%d %H:%M:%S")
    start   = time.time()
    print "\nStarting spiga.py ( https://github.com/getdual ) at %s with %s threads" % (iso8601, NO_OF_THREADS)

    # Spawn a pool of threads and pass them queue instance 
    for i in range(NO_OF_THREADS):
        t = ThreadScan(queue)
        t.setDaemon(True)
        t.start()

    # Main loop
    print "\nScanning %s..." % (target)
    for keyf in dict_of_funcs.keys():
        for keya in dict_of_actions.keys():
            keyf_in_keya = re.search(keyf, keya)
            if keyf_in_keya:
                action_regex = re.compile('%s_' % keyf)
                action_sub = re.sub(action_regex, '', keya)
                items = [dict_of_funcs[keyf], target, action_sub, dict_of_actions[keya]]
                queue.put(items)

    # Wait on the queue until everything has been processed
    queue.join()

    # Closing message
    print "\nspiga.py done: %s scanned in %s seconds" % (target, (time.time() - start))
