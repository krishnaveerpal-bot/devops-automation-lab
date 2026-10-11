#!/bin/bash

echo "==== Disk Uasage Report ===="

date
echo

df -h

echo

echo "==== File System Above 80% Uasage ===="

df -P -h |awk 'NR>1 {
    usage=$5
	gsub("%","",usage)
	if (usage+0 >=80) {
		print "Warning: " $6 " is " " usage "% full"
		}
		
}
	
