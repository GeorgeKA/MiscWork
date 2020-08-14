#!/bin/bash
<<DESCRIPTION
The purpose of this script is to maintain a ledger of all of the documents that are opened using your chosen editor. This (currently) does not allow you to open your editor with syntax other than:
	<editor> <file>
This does not allow you to use any options. I will personally get around this by using b "\" to directly use vim. It is not a trivial task to have getopts parse arguments when the names of those arguments are unknown.
DESCRIPTION

inputFile="$1"
ledgerFile="$HOME/.vim/ledger.txt"
editor="/usr/bin/vim"

if [[ "$inputFile" != "" ]]
then
	if [ ! -a "$ledgerFile" ]
	then
		touch $ledgerFile
	fi

	printf "File: %s\nDate: %s\nPath: %s\n\n" "$inputFile" "$(date)" "$(pwd)" >> $ledgerFile

	$editor $inputFile
else
	printf "Enter existing or new file name"
fi
