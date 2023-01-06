#!/bin/ksh
# This script is meant to be used as root on AIX in order to create a new user
# Note that you'll have to modify the new user's password manually, since the password modification doesn't work at the moment

firstname=$1
lastname=$2
username=$3
#uniquepass=$4
homedir="/home/$username"

# Required arguments
if [[ -z "$firstname" || -z "$lastname" || -z "$username" ]]
then
	#print "Arguments: firstname, lastname, username, password (optional)"
	print "Arguments: firstname, lastname, username"
	exit 1
fi

# Prevent duplicates
grep -q $username /etc/passwd

if [ $? -eq 0 ]
then
	print "$username already exists"
	exit 1
fi

useradd -c $lastname,$firstname -d "$homedir" -g 7777 $username
mkdir $homedir
chown $username $homedir

#if [[ -z $uniquepass ]]
#then
	#passwd -noverify $username changeThis1Now!
#else
	#passwd -noverify $username uniquepass
#fi

print "#### VERIFICATION ####\n"

print "1) $username passwd info should be below:\n---"
grep $username /etc/passwd

print "2) \n\nThe $homedir should exist and $username should own it:\n---"
ls -ld $homedir
