#!/bin/bash
<<USAGE
**Purpose**
Perform backup tasks that you wish to occur daily and/or weekly. The idea is to create duplicates of important data in order to avoid accidentally deleting important local documents.
You can also add your own custom tasks to be run cyclically. If an internet connection is required for your particular task, there is code to verify this below.

**How to**
1) Move this script to your $HOME directory, and add the following to your .bash_profile so that the script runs everytime you open the terminal.
	if [ -r automateTasks.sh ]
	then
		./automateTasks.sh
	fi
2) Execute the following:
	chmod ug+x automateTasks.sh
3) To add the tasks that you would like to perform, head to the "HowTo" comment near the end of the script. There, you can specify the tasks.
4) I'd suggest not editting any other part of the script, (though you have free will). Note the "DO NOT EDIT THIS SECTION UNTIL..." labels.

**Other**
This script makes use of the .dateTracker.txt file to determine if a new round of backups needs to be performed. It tracks the date since the terminal was last opened. If the file is deleted, this script will create a new one.

**Author**
George Asante

**Options**
-r Regardless of the current date, perform the daily and weekly tasks.
-f same as -r
-h Display help text
USAGE

########DO NOT EDIT THIS SECTION UNTIL...########

# ANSI colour codes
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGREY='\033[0;37m'
GREY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

usage="\n${LIGHTPURPLE}Purpose:${NC} Perform backup tasks that you wish to occur daily and/or weekly. The idea is to create duplicates of important data in order to avoid accidentally deleting important local documents.
You can also add your own custom tasks to be run cyclically. If an internet connection is required for your particular task, there is code to verify this below.
${LIGHTPURPLE}How to:${NC} 1) Move this script to your $HOME directory, and add the following to your .bash_profile so that the script runs everytime you open the terminal.
	if [ -r automateTasks.sh ]
	then
		./automateTasks.sh
	fi
2) To add the tasks that you would like to perform, head to the 'HowTo' comment near the end of the script. There, you can specify the tasks.
3) I'd suggest not editting any other part of the script, (though you have free will). Note the 'DO NOT EDIT THIS SECTION UNTIL...' labels.
${LIGHTPURPLE}Other:${NC} This script makes use of the .dateTracker.txt file to determine if a new round of backups needs to be performed. It tracks the date since the terminal was last opened. If the file is deleted, this script will create a new one.
${LIGHTPURPLE}Author:${NC} George Asante
\n${LIGHTPURPLE}Options:${NC}\n\t-r Regardless of the current date, perform the daily and weekly tasks.\n\t-f same as -r\n\t-h Display help text\n\n"

dateTracker="$HOME/.dateTracker.txt"
currentDay=$(date "+%d")
currentMonth=$(date "+%m")
currentYear=$(date "+%Y")
currentWeek=$(date "+%W")

forceBackup="false" # Force backup

<<Function-UdateDateTracker
Description: Update the date tracking file so that it reflects the current date.
Function-UdateDateTracker
function UpdateDateTracker {
	echo "$currentYear,$currentMonth,$currentDay,$currentWeek" > $dateTracker
}

<<Function-BackupFile
Description: Backup the inputted file to a desired directory.
Arguments:
	originalFile: The original file
	backupDir: The directory to which the original file will be copied
Function-BackupFile
function BackupFile {
	originalFile=$1
	backupDir=$2

	if [ -a "$originalFile" -a -d "$backupDir" ]
	then
		printf "${PURPLE}TASK) Backing up $originalFile to $backupDir${NC}\n"
		\cp -f $originalFile $backupDir
	else
		printf "${PURPLE}TASK) Unable to back up $originalFile to $backupDir.\nVerify their existence.${NC}\n"
	fi
}

<<Function-BackupDir
Description: Zip the inputted directory.
Arguments:
	originalDir: The original directory
	backupZip: The to be created zip file
Function-BackupDir
function BackupDir {
	originalDir=$1
	backupZip=$2

	if [ -d $originalDir ]
	then
		printf "${PURPLE}TASK) Backing up $originalDir as $backupZip${NC}\n"
		{
			zip -r --quiet --symlinks "$backupZip.tmp" "$originalDir"

		if [ "$?" -eq '0' ]
		then
			\mv -f "$backupZip.tmp" "$backupZip"
		fi
		} &
	fi
}

function printForceBackupMsg {
	echo "Forcing backup"
}

# Handle options
while getopts ":hrf" opts
do
	case $opts in
		h)
			printf "$usage"
			exit 1
			;;
		r)
			forceBackup='true'
			printForceBackupMsg
			break
			;;
		f)
			forceBackup='true'
			printForceBackupMsg
			break
			;;
		\?)
			echo "Invalid option: $OPTARG"
			break
			;;
		:)
			echo "Missing an argument"
			break
			;;
	esac
done

if [ ! -r "$dateTracker" ]
then
	echo "The date tracking file, $dateTracker, has been deleted. Creating a new one."
	touch $dateTracker
	chmod go-wx $dateTracker
	UpdateDateTracker
fi

recordedDay=$(cat $dateTracker | cut -d"," -f3)
recordedMonth=$(cat $dateTracker | cut -d"," -f2)
recordedYear=$(cat $dateTracker | cut -d"," -f1)
recordedWeek=$(cat $dateTracker | cut -d"," -f4)

# The true condition, 0, is when the current date is more recent than the recorded one.
[ "$currentMonth" -gt "$recordedMonth" ] || [ "$currentMonth" -eq '1' -a "$recordedMonth" -eq '12' ]
monthStatus=$?
[ "$currentDay" -gt "$recordedDay" ] || [ "$currentDay" -eq '1' -a "$recordedDay" -gt '28' ]
dayStatus=$?

# DAILY TASKS
if [ "$currentYear" -gt "$recordedYear" ] || [ "$monthStatus" -eq '0' ] || [ "$dayStatus" -eq '0' ] || [ "$forceBackup" == 'true' ]
then
	printf "Performing DAILY TASKS:\n\n"

########...HERE.########
<<HowTo
• Below is where you can specify the files or directories that you would like to backup, and their backup location. 
• Follow the simple samples given for calling the backup functions.
• Remember to remove the comment lines around your function call for your backup to actually run.
• Both the file being backed up and the backup directory need to exist prior to running the script.
HowTo

<<FileBackup
	BackupFile "<path_to_original_file>" "<path_to_backup_directory>"
FileBackup

<<DirectoryBackup
	BackupDir "<path_to_original_file>" "<path_to_backup_directory>"
DirectoryBackup

# Add your custom script below "Add custom script here". 
<<CustomTask_RequiresInternetConnection
	testConnectFile='dailyTask-curl.out'

	printf "\nChecking internet connection.\n"
	curl www.google.ca -o $testConnectFile

	if [ -a $testConnectFile ]
	then
		#Add custom script here
		rm $testConnectFile
	else
		printf "${RED}No internet connection.${NC}\nConnect to the internet then re-attempt ./automateTasks.sh -r'\n"
	fi
CustomTask_RequiresInternetConnection

<<CustomTask
	#Add what you would like
CustomTask

########DO NOT EDIT THIS SECTION UNTIL...########

	# Greeting
	printf "${GREEN}Hey hey big fella!\n\n'Hate begets hate, but love is infectious.${NC}'\n\n"

	UpdateDateTracker
fi

# WEEKLY TASKS
if [ "$currentWeek" -gt "$recordedWeek" ] || [ "$currentWeek" -eq '0' -a "$recordedWeek"  -eq '53' ] || [ "$forceBackup" == 'true' ]
then
	printf "Performing the WEEKLY TASKS:\n\n"

########...HERE.########

# Follow the same format used in the DAILY TASKS section

########DO NOT EDIT ANYTHING ELSE########
	UpdateDateTracker
fi
