#!/usr/bin/env python

# spiga.py - Simple scanner for random sites
# by dual
#
# Thanks to Digicon for tweeting the Yahoo random site link
# http://twitter.com/#!/Digicon/status/87489978959003648

import re
import sys
import urllib
import time
import urlparse

def scanner(func_call_dirs, target, func_action, action_value):
    if func_action == 'code':
        for i in func_call_dirs:
            target_dir = target + "/" + i
            (code, response) = useragent(target_dir)
            print target_dir
            if str(code) == action_value:
                print "SUCCESS -> " + target_dir
    elif func_action == 'search':
        for i in func_call_dirs:
            target_dir = target + "/" + i
            (code, response) = useragent(target_dir)
            print target_dir
            search_str = re.search(action_value, response)
            if search_str:
                print "SUCCESS -> " + target_dir

def useragent(target_dir):
    try:
        ua = urllib.urlopen(target_dir)
    except IOError:
        print "FAIL -> domain does not exist or is not responding"
        sys.exit()
    code = ua.getcode()
    response = ua.read()
    return(code, response)

def rand_target():
    yahoo = urllib.urlopen('http://random.yahoo.com/bin/ryl')
    try:
	# Get redirect URL
        rand_url = yahoo.geturl()
    except IOError:
        return
    parsed_rand_url = urlparse.urlparse(rand_url)
    target = parsed_rand_url.scheme + "://" + parsed_rand_url.netloc
    return(target)

def usage():
    print "spiga.py - Simple scanner for random sites"
    print "Usage: python spiga.py [http(s)://www.example.com]"
    print "spiga.py continuously scans random sites without an argument"
    sys.exit()

if __name__ == '__main__':
    # Initialize
    main_func_calls    = []
    main_func_dirs     = []
    func_action_names  = []
    func_action_values = []
    continuous	       = 0
    func_check	       = 0

    # Check and verify argument
    if len(sys.argv) == 2:
        try:
            url = urlparse.urlparse(sys.argv[1])
        except IndexError:
            usage()
        if url.scheme == 'http' or url.scheme == 'https':
            if url.netloc != '':
                target = url.scheme + "://" + url.netloc
        else:
            usage()
    else:
        continuous = 1

    # spiga.conf parsing regexes
    conf_comment  = re.compile('^#')
    conf_beg_func = re.compile('^\(\)(.*?)\s*{$')
    conf_action   = re.compile('^;(.*?)=(.*)$')
    conf_end_func = re.compile('^}$')

    # Open and read spiga.conf
    try:
        conf = open('spiga.conf', 'r')
    except:
        print "No spiga.conf file present... exiting."
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
            action_name  = action.group(1)
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

    dict_of_funcs   = dict(zip(main_func_calls, main_func_dirs))
    dict_of_actions = dict(zip(func_action_names, func_action_values))

    # Main loop
    try:
        if continuous == 1:
            while(1):
                target = rand_target()
                if target == '':
                    next
                print "\nScanning " + target + "..."
                for keyf in dict_of_funcs.keys():
                    for keya in dict_of_actions.keys():
                        keyf_in_keya = re.search(keyf, keya)
                        if keyf_in_keya:
                            action_regex = re.compile('%s_' % keyf)
                            action_sub = re.sub(action_regex, '', keya)
                            scanner(dict_of_funcs[keyf], target, action_sub, dict_of_actions[keya])
                time.sleep(1)
        else:
            print "Scanning " + target + "..."
            for keyf in dict_of_funcs.keys():
                for keya in dict_of_actions.keys():
                    keyf_in_keya = re.search(keyf, keya)
                    if keyf_in_keya:
                        action_regex = re.compile('%s_' % keyf)
                        action_sub = re.sub(action_regex, '', keya)
                        scanner(dict_of_funcs[keyf], target, action_sub, dict_of_actions[keya])
    except KeyboardInterrupt:
        print " Interrupted by user... exiting."
        sys.exit()
