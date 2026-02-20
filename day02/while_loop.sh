#!/bin/bash

num=0

while [[ $num -le 10 ]];
do
	if (( $num%2==0))
	then
		echo "$num"
	fi

	((num++))
done
