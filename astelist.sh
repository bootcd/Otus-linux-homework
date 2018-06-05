#!/bin/bash

#variables block

#path to Master.csv asterisk file.
#Example /var/log/asterisk/cdr-csv/Master.csv
MASTERPATH=""

#path for output journal file
JOURNALPATH=""

function dateResolver {
local tempString=${1//" "/""}
local tempString=${tempString//-/""}
local tempString=${tempString//:/""}
local resultString=${tempString//\"/""}
echo $resultString
#exit 0
}

function incCallNumber {

	result=$(($1+1))
	echo $result
}

function wrongParametr {

	echo "Unknown parameter. Usage: ./astelist -d yyyy-mm-dd -t hh:mm:ss hh:mm:ss"
}

function timeValidation {

if [[ ${#1} -ne 8 ]]
then
	echo $1 "is not valid for use"
	wrongParametr
	exit 0
fi
	hour=${1:0:2}
	minutes=${1:3:2}
	seconds=${1:6:2}  

if [ $hour -gt 23 ] || [ $minutes -gt 59 ] || [ $seconds -gt 59 ]
then
	echo "Wrong parameters near -t"
	exit 0
fi
}

if [[ "$1" = "" ]];
then
	echo "Wrong date parametr!  Usage: ./astelist -d yyyy-mm-dd -t hh:mm:ss hh:mm:ss"
	exit 0
fi

while [ -n "$1" ]
do
	x=$1
	case "$x" in
	
	-d)if [[ ${#2} -ne 10 ]]
	then
		wrongParametr
		exit 0
	fi
	month=${2:5:2}
	day=${2:8:2}
	if [ $month -gt 12 ] || [ $day -gt 31 ]
	then
		wrongParametr
		exit 0
	fi
	dateParam="$2"
	startTimeParam="00:00:00"
	endTimeParam="23:59:59"
	shift;;
	
	-t)timeValidation $2
	timeValidation $3
	startTimeParam="$2"
	if [[ $3 = "" ]]
	then
		endTimeParam="23:59:59"
	else
		endTimeParam="$3"
	fi
	break;;

	*) wrongParametr
	exit 0;;
	esac
	shift
done

echo "Please wait..."

startDateString=$dateParam$startTimeParam
endDateString=$dateParam$endTimeParam
numericStartDate=$(dateResolver $startDateString)
numericEndDate=$(dateResolver $endDateString)
numericDateParam=$(dateResolver $dateParam)

declare -a outgoingCalls
declare -a incomingCalls

while read LINE
do
	IFS=","
	read -r -a callRecordArray <<< "$LINE"

who=$(dateResolver ${callRecordArray[1]})
where=$(dateResolver ${callRecordArray[2]})
when=${callRecordArray[11]//\"/""}
callDate=${callRecordArray[11]:1:10}
long=${callRecordArray[15]//\"/""}
status=${callRecordArray[16]//\"/""}


numericCallDate=$(dateResolver $callDate)
timeStamp=$(dateResolver ${callRecordArray[11]})

if [[ $numericCallDate -le $numericDateParam ]]
then
	if [[ $callDate = $dateParam ]]
	then
		if [ $timeStamp -ge $numericStartDate ] && [ $timeStamp -le $numericEndDate ]
		then 
			echo $who","$where","$when","$long","$status >> $JOURNALPATH
    			if [[ $who =~ ^[0-9]{8,21} ]]
    			then
       				 incomingCalls[$who]=$(incCallNumber ${incomingCalls[who]})
    			else
        		outgoingCalls[$who]=$(incCallNumber ${outgoingCalls[who]})
   	 		fi

		fi

	fi
	else
		break
fi    
done < $MASTERPATH

echo "###################################"
echo "########## Incoming Calls #########"
echo "###################################"

for value in ${!incomingCalls[@]}
do
	echo "External number "$value did ${incomingCalls[$value]} "calls"
done

echo "###################################"
echo "########## Outgoing Calls #########"
echo "###################################"

for value in ${!outgoingCalls[@]}
do
	echo "Internal number "$value did ${outgoingCalls[$value]} "calls"
done
