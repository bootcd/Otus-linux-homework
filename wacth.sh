#!/bin/bash

MYEMAIL=""
PASSWORD=""
SMTPSERVER=""
SMTPPORT=""
#file with servicename strings divided by \n
SERVICELIST=""


function sendem {

sendEmail -o tls=yes -f michael@itlspb.ru -t $1 -s $2:$3 -xu $1 -xp $4 -u "Hello!" -m "This services: " $5 "was inactive and restarted!
}

#!/bin/bash

declare -a inactiveServices

while read service
	do
		statusString=$(service $service  status | grep Active)
		IFS=' '
		read -r -a   statusArray <<< $statusString 

		echo $(date)  "Status: "$service  ${statusArray[1]} >> /var/log/watchlog

		if [ ${statusArray[1]} != "inactive" ]
		then
			echo $(date) "Service " $service " already  running" >> /var/log/watchlog
		else
			inactiveServices[i]=$service
			i=$((i+1))
			service $service start 2 #>>/var/log/messages
			if [ $? -eq 0 ]
			then
				echo $(date) "Service " $service " started!" >> /var/log/watchlog
			fi

		fi
done < $SERVICELIST

if [[ ${#inactiveServices[@]} -ne 0 ]]
then
	servicesString=${inactiveServices[@]}
	sendem $MYEMAIL $SMTPSERVER $SMTPPORT $PASSWORD "$servicesString"
else
	exit 0
fi
