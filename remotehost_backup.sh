#!/bin/bash
# backup the home directory of a remote host to the
# home directory of localhost with rsync and cron.

# Variables:
# address up remote host for ping test.
RIPADDR=192.168.1.XXX
# Remote source directory 
RHOST=192.168.1.XXX:/home/
# Destination directory is $HOME by default.
DESTDIR="$HOME/REMOTE_BACKUP"

# functions
# See if the remote host is online.
function Ping_test ()
{
ping -c 3 "$RIPADDR" > /dev/null 2>&1
if  [ $? -eq 0 ] 
    then
    echo "Performing backup..." | tee "$DESTDIR"/backup.log
else
    echo "Cannot backup that directory, remote host is down." | tee "$DESTDIR"/FAIL.log;
    printf "\e[41m"; for i in $(seq 1 $(tput cols)); do printf " "; done; printf "\e[0m" # Delinitates output (for no good reason)
fi
}
# if backup directory don't exist, then create it
function CREATE_DESTDIR ()
{
if
    [ ! -d "$DESTDIR" ]; then mkdir "$DESTDIR"
fi
}
# End of functions
# rsync $HOME of remote host
until ((0))
do
     CREATE_DESTDIR
     Ping_test; sleep 3 
     rsync -avzxu --info=progress2 "$RHOST" "$DESTDIR" | tee "$DESTDIR"/backup.log
     break
done
