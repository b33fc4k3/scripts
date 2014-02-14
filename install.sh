#!/bin/bash

# Adding ¨/scripts recursively to $PATH
scriptpath=$(find . -type d -printf ":$PWD/%P")
echo -e "Adding scriptpath to \$PATH !"
echo -e "This ..."
echo $scriptpath
echo -e "to that ..."
echo $PATH
echo "And now together"
echo "$PATH$scriptpath"

#export PATH=$PATH$scriptpath
