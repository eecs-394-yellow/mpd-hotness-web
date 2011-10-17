#!/bin/bash

. database-admin

mtime() {
    stat -f '%m' $1
}

dbexec() {
    # File should define USER, PASS, DB, and HOST variables
    mysql --user=$USER --password=$PASS --host=$HOST --database=$DB < $1
}

gettmp() {
    echo /tmp/mtime.${1/.sql}
}

getchanged() {
    git log --name-only -n1 | sed -n -e '1,/^ *$/d' -e '\@^db/@p'
}

runchanged() {
    for dbscript in $(getchanged) ; do
        echo "$dbscript updated"
        dbexec $dbscript
    done
}

case "$1" in
    env)
        export dbexec
    ;;
    *)
        echo Running git pull
        echo
        git pull --progress remote-readonly master
        echo Running updated SQL
        echo
        runchanged
    ;;
esac
