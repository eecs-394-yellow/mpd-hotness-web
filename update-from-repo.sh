#!/bin/bash

. database-admin

mtime() {
    stat -f '%m' $1
}

dbexec() {
    # File should define USER, PASS, DB, and HOST variables
    mysql --user=$USER --password=$PASS --host=$HOST --database=$DB < $1
}

runchanged() {
    for dbscript in *.sql ; do
        if [[ $(cat $(gettmp $dbscript)) -ne $(mtime $dbscript) ]] ; then
            echo "$dbscript updated"
            dbexec $dbscript
        else
            echo "$dbscript not updated"
        fi
        rm $(gettmp $dbscript)
    done
}

case "$1" in
    env)
        export dbexec
    ;;
    *)
        pushd db
        echo Saving SQL 
        savemtimes
        echo Running git pull
        git pull --progress remote-readonly master
        echo Running updated SQL
        runchanged
        popd
    ;;
esac
