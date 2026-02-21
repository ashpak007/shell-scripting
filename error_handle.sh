#!/bin/bash

create_directory() {
	mkdir demo
}

create_directory

if ! create_directory; then
	echo " The code is being exited as the directory already exists"
	exit 1
fi

echo "This should not work because the code is interrupted" 
