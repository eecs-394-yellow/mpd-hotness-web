#!/usr/bin/env python
import os
os.umask(022)

import cgitb
cgitb.enable(display=0, logdir='/home/public/logs', format='text')

os.system('chmod 666 /home/public/logs/*')

import cgi
import json
import os.path
import pprint
import re
import subprocess
import sys

ADMIN_FILE = 'database-admin'

def read_dbadmin(file):
    return dict(re.findall(r'(\w+)=(\w+)', file.read()))

def exec_sql(db_conf, fname):
    os.system(('mysql -u %(USER)s -h %(HOST)s --password=%(PASS)s %(DB)s <' % db_conf) + fname)

def do_pull(db_conf, fname):
    os.system('git pull --progress remote-readonly master 2>&1')

def find_changed():
    sp = subprocess.Popen(['git', 'log', '--name-only', '-n1'], stdout=subprocess.PIPE)
    files = sp.stdout.read()
    files = re.split(r'\n\s*\n', files, 2)[2]
    return [f for f in files.split() if f.startswith('db/')]

def get_postdata(file):
    data = file.read()
    payload = cgi.parse_qs(data)['payload'][0]
    return json.loads(payload)

def most_recent_commit(commits):
    return max(commits, key=lambda x: x[u'timestamp'])

def main():
    print 'Content-type: text/html'
    print
    logdump = open('update-test.txt', 'w')
    os.chdir('../protected/geonotes-web')
    db_conf = read_dbadmin(open(ADMIN_FILE))
    data = get_postdata(sys.stdin)
    most_recent = most_recent_commit(data[u'commits'])
    added, removed, modified = most_recent[u'added'], most_recent['removed'], most_recent['modified']
    print >>logdump, added, removed, modified
    bleh
    
main()
