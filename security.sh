#!/bin/sh
# This is an anti-theft startup script in progress
# Variables to append the date to the log file
NOW=$(date +"%Y-%m-%d")
LOGDIR=/tmp/.theft
LOGFILE="Locationinfo.txt-$NOW.log"
# Variables for logging 
# Print MAC Address in a nice output
MACADDR=$(ip link show eth0 | awk '/ether/ {print}')
# Enter your gateway adress below.
MYGATEWAY=192.168.1.1
# display the WAN address of localhost
MYIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
# Create the log directory then cd into it.
if
    [ ! -d "$LOGDIR" ]; then 
    mkdir "$LOGDIR" && eval cd "$LOGDIR"                            
fi

# Functions:
# Basic header with some system information
PC_info ()
{
    date +%D
    hostname
    who -b
    echo "NIC Address is: $MACADDR"
    echo " "
}

# Take a picture with /dev/video0 and find location
# using routing information
THEFT_LOCATE ()
{
    streamer -c /dev/video0 -b 16 -o "$LOGDIR"/suspect.jpeg
    echo " "
    traceroute 8.8.8.8 # Trace route to google DNS
    echo " "
    netstat -nr
    echo " "
    ping -c4 -R "$MYGATEWAY"
    echo " "
    echo "WAN IP/public address is: ${MYIP}"
    echo " "
}
# Create a tarball with the contents of the .theft directory
MKTARBALL ()
{
    tar -czvf "$LOGDIR"/theft.tar.gz "$LOGDIR"   
    echo $?
}
# Use emailer.py to email the tarball via google SMTP.
MAILER=/usr/bin/emailer.py
SEND_MAIL ()
{
    /usr/bin/python "$MAILER"
}
# Clean up /tmp
CLEAN ()
{
    eval cd.. && rm -rf "$LOGDIR"
}
# End of functions
# Redirect stdout to a file then redirect stderr to stdout
exec 1> "$LOGDIR"/"$LOGFILE" 2>&1
# If there is one or more failed login attempts by ANY
# user recorded within faillog then continue, if not, exit
# (commented out for the sake of testing.)
until 0
do
#faillog -a | awk '{print [}'
#if ($(! ! ) >= "1") ; then                    
    PC_info
    THEFT_LOCATE
    sleep 1
    MKTARBALL
    SEND_MAIL
    sleep 1
    CLEAN
    break
#else 
  # sleep 1 ; exit 0
#fi
done

