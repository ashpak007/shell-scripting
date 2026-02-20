#!/bin/bash

<< disclaimer 

This is just for infotainment purpose

disclaimer

read -p 'Jetha ne mudke kise dekha: ' bandi
read -p "Jetha ka pyaar %: " pyaar

if [[ $bandi == 'daya bhabi' ]];
then 
	echo "Jetha is loyal"
elif [[ $pyaar gt 100 ]];
then
	echo "jetha is loyal"
else
	echo "Jetha is not loyal"

fi
