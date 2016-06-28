#!/bin/bash
_scriptName=$(basename ${0})

__usage() {
   if [ -n "${1}" ]; then
    echo $1
    echo
   fi

    echo "Usage: ${_scriptName} -w [warning percentage] -c [critical percentage] -e [email]"
    echo "Example: ${_scriptName} -w 70 -c 90 -e ejvdeguzman@chikka.com"

   exit

} # __usage()

__checkMemory() {
TOTAL_MEMORY=$(free | grep Mem: | awk '{print $2}')
USED_MEMORY=$(free | grep Mem: | awk '{print $3}')
USED_MEMORY_PERCENTAGE=$((($USED_MEMORY*100)/$TOTAL_MEMORY))
NOW=$(date +"%Y%m%d\%H:%M:%S")
_CPU=$(top -b -n1 | head -17 | tail -10)
if [ "$USED_MEMORY_PERCENTAGE" -ge "$_critical" ]; then


        echo "Sending message $_CPU to $_email" | mail -s $NOW $_email
        exit 2

elif [ "$USED_MEMORY_PERCENTAGE" -ge "$_warning" ] ; then
        exit 1

else



        exit 0
fi

}

#GETTING PARAMETERS

while getopts "e:c:w:h" OPT; do
        case $OPT in
        "e") _email=$OPTARG;;
        "w") _warning=$OPTARG;;
        "c") _critical=$OPTARG;;
        "h") __usage=$OPTARG;;
        esac
done

#check if my input , pag wala display usage
if [ $OPTIND -eq 1 ]; then

  __usage "Input Error: No args passed"
fi

#check if complete ung requirements , pag kulang display ung usage
if [ -z $_email ] || [ -z $_warning ] || [ -z $_critical ]; then
        __usage "Input error: Incomplete Requirements"
fi

#
if [ $_warning -gt $_critical ]; then

        __usage "Threshold error: warning must not be greater than critical"

fi

__checkMemory
