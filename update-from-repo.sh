#!/bin/bash

echo Content-Type: text/plain
echo

mtime() {
    stat -f '%m' $1
}

dbexec() {
    # File should define USER, PASS, DB, and HOST variables
    . database-admin
    mysql --user=$USER --password=$PASS --host=$HOST --database=$DB < $1
}

for dbscript in *.sql ; do
    mtime $dbscript > mtime.${dbscript/.sql}
done

git pull

for dbscript in *.sql ; do
    if [[ $(cat mtime.${dbscript/.sql}) -ne $(mtime $dbscript) ]] ; then
        echo "$dbscript updated"
        dbexec $dbscript
    else
        echo "$dbscript not updated"
    fi
    rm mtime.${dbscript/.sql}
done