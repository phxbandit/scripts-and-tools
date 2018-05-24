#!/bin/bash

# 30backups.sh - Creates and keeps the latest 30 web and SQL backups
# VVinston Phelix

# Number of backups
num=30

thedate="$(date +'%Y%m%dT%H%M')"

# Define web resources
websrc="/root/webdumps/"
webdest="/media/disk/webdumps"
webname="webdump-$thedate.tar.gz"

# Define SQL resources
sqlsrc="/root/sqldumps/"
sqldest="/media/disk/sqldumps"
sqlname="sqldump-$thedate.sql"

# Create snapshots
tarit() {
    #printf "\nCreating web and SQL backups...\n\n"
    cd /var/www/ && tar czf "$websrc$webname" html
    mysqldump -u root --all-databases > "$sqlsrc$sqlname" && gzip "$sqlsrc$sqlname"
}

# Remove backups past $num
purge() {
    curweb=$(ls -1Atr "$websrc" | wc -l)
    if [ "$curweb" -gt "$num" ]; then
        numdelweb=$(($curweb-$num))
        for i in $(ls -1Atr "$websrc" | head -$numdelweb); do
            #echo "Removing $websrc/$i"
            rm -f "$websrc/$i"
        done
    fi

    cursql=$(ls -1Atr "$sqlsrc" | wc -l)
    if [ "$cursql" -gt "$num" ]; then
        numdelsql=$(($cursql-$num))
        for j in $(ls -1Atr "$sqlsrc" | head -$numdelsql); do
            #echo "Removing $sqlsrc/$j"
            rm -f "$sqlsrc/$j"
        done
    fi
}

# Rsync content
syncit() {
    #printf "\nSyncing web content...\n\n"
    #rsync -av --delete --exclude=".*" "$websrc" "$webdest"
    rsync -av --exclude=".*" "$websrc" "$webdest"

    #printf "\nSyncing SQL dumps...\n\n"
    #rsync -av --delete --exclude=".*" "$sqlsrc" "$sqldest"
    rsync -av --exclude=".*" "$sqlsrc" "$sqldest"
}

tarit
purge
syncit

#printf "\nDone\n\n"
