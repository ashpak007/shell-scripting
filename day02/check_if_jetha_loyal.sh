#!/bin/bash

<< disclaimer 

This is just for infotainment purpose

disclaimer

#This is the function defination
function is_loyal() {
read -p "$1 ne mudke kise dekha: " bandi
read -p "$1 ka pyaar %: " pyaar

if [[ $bandi == 'daya bhabi' ]];
then 
	echo "$1 is loyal"
elif [[ $pyaar -gt 100 ]];
then
	echo "$1 is loyal"
else
	echo "$1 is not loyal"

fi
}

#This is the function call
is_loyal "$1"
