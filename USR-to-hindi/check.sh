#!/bin/sh

if [ $# -gt 1 ]
then
	grep ":"$1"<cat:"$2 hi_expanded
elif [ $# -eq 1 ]
then
	grep ":"$1"<" hi_expanded
else
	echo "Provide a word to search."
fi
