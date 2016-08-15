#!/bin/bash

# This is a simple backup script using rsync that simply backs up
# a source directory and it's contents to a specified target
# directory of a the users choice. It creates a backup.log
# file in the user's home directory.
# Brian Hurst -- 05/2016
#
# functions:
# 
function ask_yes_or_no ()
{
	select yn in "Yes" "Quit"; do
		case $yn in
		Yes ) rsync -avxu --info=progress2 $SRCDIR $TARGETDIR | tee $HOME/backup.log  && sleep 1
		echo "----------------------------------------------------------------" 
		echo "Backed up $SRCDIR to $TARGETDIR ...job Done, Goodbye!"
		break ;;
	Quit ) echo "Quitting the script" ; sleep 1  
		break ;;
	* ) echo "Invalid Option"
		esac
		done
}

# The script checks to see if the source directory exists and if it contains files.
# if it exists, the user is prompted to enter a target directory.
# If it contains no files, it lets the user know that the directory is empty. 

until ((0))
	do
	read -e -p "Type in a directory to backup: " SRCDIR
	if
	[ -d "$SRCDIR" ] && (find "$SRCDIR" -maxdepth 0 -empty -exec echo {} is empty. \; ) && [ $? -eq 0 ]
	then read -e -p "source directory found, please enter a target: " TARGETDIR
	elif [[ ! -d "$SRCDIR" ]] && [[ $? -ne 0 ]]
    then echo "cannot backup this directory, it does not exist!"
	fi
	clear

# The user is then prompted for verification.
# if the user chooses option '1' rsync syncs the source dir with the target dir.
# rsync runs verbose, preserves everything, and skips any files for which the
# destination file already exists and has a date later than the source file. 

	if
	[ -d "$TARGETDIR" ]
	then echo "Target directory found. Back up $SRCDIR to $TARGETDIR?" ; ask_yes_or_no
	elif [ ! -d "$TARGETDIR" ]
	then echo "Target directory not found!"
	fi       
	break
	done

