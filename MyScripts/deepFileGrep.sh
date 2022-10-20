#!/bin/bash

# Argument 1: File name search string. The file search uses the "find" command btw..
# Argument 2: In-file search string. The in-file search uses grep.

filename="$1";
searchStr="$2";

if [ -z "$filename" -o -z "$searchStr" ]
then
	printf "Provide a filename search string and an in-file search string\n";
	printf "This script allows you to perform a search for a given string in any file whose name contains your given search string.\n";
	exit 1;
fi

for i in $(find . -name "$filename")
do
	grep -q "$searchStr" $i
	if [ $? -eq 0 ]
	then
		printf "\nFILE: $i\n";
	fi
	grep "$searchStr" $i;
done
