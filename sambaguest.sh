#!/usr/bin/bash
rm targets.txt &>/dev/null
echo "Scanning range (default is 192.168.1.1-254): "
read RANGE
echo "Ports to use (default is 445): "
read PORT
echo "Searching for hosts"
if [[ $RANGE == "" ]]
then
RANGE="192.168.1.1-254"
fi
if [[ $PORT == "" ]]
then
PORT="445"
fi
echo scanning $RANGE with port $PORT
nmap $RANGE -p $PORT -oG - | awk '{print $2}' | sed '1d;$d' | uniq -d > targets.txt
echo "Hosts found: "
cat targets.txt
while IFS= read -r line; do
    echo trying $line
	smbclient -g --no-pass -L \\$line
done < targets.txt
rm targets.txt &>/dev/null