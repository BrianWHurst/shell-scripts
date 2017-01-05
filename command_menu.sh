#!/bin/bash
############################################################################
# Brian Hurst
# 05/31/2016
# This program creates a menu with user controls.
# it includes checks to make sure that the user inputs the data properly
#############################################################################
# Functions
#
function return_menu()			# function to return to the main menu
{
    echo "Press any key to return to command menu"
    read -n1 
    clear
}
#
#
clear
USERIN=[" "]
until [ "$USERIN" = "9" ] ; do 		# The program will exit only if option [9] is pressed
    echo "=============================================================="
    echo -e "\n	Welcome to Brian's Main Menu	\n"
    echo "  [1.] Display users currently logged on"
    echo "  [2.] Display a calender for a specific month and year"
    echo "  [3.] Display current directory path "
    echo "  [4.] Change directory"
    echo "  [5.] Long listing of visible files in current directory"
    echo "  [6.] Display current time, date, and calendar"
    echo "  [7.] Start the vi editor"
    echo "  [8.] Email a file to a user"
    echo "  [9.] Quit"
    echo -e "\n"
    echo "============================================================="
    echo -e "\n"
    read -p "select a menu option to run a command: " answer
    echo
    #
    clear
    case "$answer" in 			# Interprets user input from menu screens and ecxecutes the corrisponding command

        1)	
            # Display users who are currently logged into the system

            who | awk '{print $1}' | more
            echo -e "\n"
            echo "================================================================"
            return_menu
            ;;
        2)	

            # display a specific month and year
            # repeats prompt if the user enters incorrect values
            # (checks month range from 1-12, year range from 1900-2060

            until ((0))
            do
                read -e -p "What month would you like to see? (mm) " calmonth
                if
                    [ "$calmonth" -lt 01 ] || [ "$calmonth" -gt 12 ];then
                    echo "Invalid range, try again " 
                elif
                    read -e -p "What year would you like to see? (yyyy) " calyear
                    [ "$calyear" -lt 1900 ] || [ "$calyear" -gt 2030 ];then
                    echo "Invalid range, try again "
                else
                    cal $calmonth $calyear					# when user inputs the correct values, the loop breaks and returns
                    break							# to the main menu
                fi
            done
            return_menu

            ;;

        3)	
            # Display current directory path

            pwd
            return_menu

            ;;
        4)	
            # change the directory path
            # within the shell script
            # eval takes the result of 'cd' and inputs it into the shell script

            read -e -p "Please enter the directory path: " chdir
            eval cd $chdir
            pwd
            return_menu

            ;;
        5)	
            # Display contents of working directory (long listing)

            ls -ltr . | more
            return_menu
            ;;

        6)	# This displays current time, date, calender

            date
            cal
            return_menu

            ;;
        7)	
            # open a specified file in the vi editor
            # checks to see that a regular file exists
            # checks to make sure that it contains ASCII text
            # if file does not contain ASCII text it prompts the user again
            # if file does not exist, it as created as a new file

            until ((0))
            do
                read -e -p "Type in a filename to open it in the vi editor: " vifile
                if
                    [ -r $vifile ] && (file $vifile | grep -i ASCII ) && [ $? -eq 0 ]
                then vi $vifile
                else echo "cannot open this file, file must contain ASCII text!"
                fi
                if
                    [ ! -r $vifile ]
                then vi $vifile
                fi
                break
            done
            return_menu

            ;;

        8)
            # Emailer
            # email the contents of a file to a specific user on the system
            # checks for user in: /etc/passwd first. if $sendto doesn't exist, it prompts again
            # prompts for subject and an ASCII file to read from
            # If file contains ASCII text, then the mail command will run
            # If the specified file is binary or file does not exist, program notifies the user

            until ((0))
            do 
                read -e -p "Enter a recipient's username: " sendto				# email recipient var
                awk -F ":" '{print $1}' /etc/passwd | grep -x "$sendto"
                if
                    [ $? -ne 0 ]
                then echo "$sendto does not exist, please try again"
                else	
                    read -p "Enter a subject line: " subject			# subject var
                    read -p "Enter a file to read from: " mailfile
                    if [ -r $mailfile ] && (file $mailfile | grep -i ASCII ) && [ $? -eq 0 ]
                    then
                        mail -s "$subject" $sendto <$mailfile 
                    elif
                        [ $? -ne 0 ]
                    then
                        echo "file does not exist or does not contain ASCII text!"  
                    fi
                    break
                fi
            done
            return_menu

            ;;
        9)
            # exit the program by pressing 9 

            echo "Thank you for using Brian's command menu"
            sleep 2
            clear
            break

            ;;
        *)
            echo "Not a valid menu selection, try again: $answer"
    esac

done
