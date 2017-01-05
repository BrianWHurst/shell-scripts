#!/bin/bash
# This is a simple program used to log the status of a local machine.
# It runs in cron and creates a log files in $HOME/MyDailyComputerStatusLogFiles
# Run as root user!

# if $HOME/MyDailyComputerStatusLogFiles doesn't exist, then create it
LOGDIR=$HOME/MyDailyComputerStatusLogFiles
if
    [ ! -d "$LOGDIR" ]
then mkdir "$LOGDIR"
fi

# Variables for the SMS and email function
# in this case, var "SERVERIP is my IRC client.
SERVERIP=192.168.1.169 # (insert your IP here)

# Function to send Email alert if "$SERVERIP" cannot be pinged
function Ping_test ()
{
    ping -c 3 "$SERVERIP" > /dev/null 2>&1
    if 
        [ $? -ne 0 ]
    then
        # Using curl, send warning email:
        echo "IRC Client $SERVERIP is down!" | curl --url "smtps://smtp.gmail.com:587" --ssl-reqd \
            --mail-from "bhurstpdxsea@gmail.com" --mail-rcpt "bhurstpdxsea@gmail.com" 
    fi
}

# Variables to append the date to the log file
NOW=$(date +"%Y-%m-%d") 
LOGFILE="MyDailyComputerStatus-$NOW.log"  

# Redirect stdout to file MyDailyComputerStatus.log then redirect stderr to stdout
exec 1>"$HOME"/MyDailyComputerStatusLogFiles/"$LOGFILE" 2>&1 

until ((0)) 
do
    clear
    hostname
    uptime
    echo "-----------------------------------------"
    date
    echo "-----------------------------------------"
    who
    echo "------------------------------------------"
    ip addr show
    echo "-------------------------------------------"
    df -h /
    echo "-------------------------------------------"
    Ping_test
    # uncomment below to check for rootkits with rkhunter.
    # The printf one-liner simply delimits the output of rkhunter.
    printf "\e[41m"; for i in $(seq 1 $(tput cols)); do printf " "; done; printf "\e[0m" 
    rkhunter --report-warnings-only --cronjob 
    printf "\e[41m"; for i in $(seq 1 $(tput cols)); do printf " "; done; printf "\e[0m"
    break
done
