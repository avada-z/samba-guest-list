#!/usr/bin/bash
rm targets.txt &>/dev/null
LOCIP=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo "Scanning range, default is 192.168.1.1-254, your local is $LOCIP: "
read RANGE
echo "Ports to use (default is 445): "
read PORT
echo "Select nmap timing, from 0 (slower) to 5 (fastest): "
read TIM
echo "Searching for hosts"
if [[ $RANGE == "" ]]
then
RANGE="192.168.1.1-254"
fi
if [[ $PORT == "" ]]
then
PORT="445"
fi
echo scanning $RANGE with port $PORT and speed timing $TIM
nmap $RANGE -p $PORT -T$TIM -oG - | awk '{print $2}' | sed '1d;$d' | uniq -d > targets.txt
echo "Hosts found: "
cat targets.txt
while IFS= read -r line; do
    echo trying $line
	smbclient -g --no-pass -L \\$line
done < targets.txt
rm targets.txt &>/dev/null