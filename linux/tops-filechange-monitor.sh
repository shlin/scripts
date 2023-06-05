#!/bin/bash

appid="tops"
today=$(date +%Y%m%d)
fileStartup=/data/log/fileChange/$appid-$today-startup.txt
fileChange=/data/log/fileChange/$appid-$today-filechange.txt
containerList=$(docker ps --format "{{json .Names}},{{json .ID}}" | grep -e $appid | sort)

mkdir -p /data/log/fileChange

echo "::過去24小時啟動的容器::" > $fileStartup

for entry in $containerList
do
        entryName=$(echo $entry | awk -F "," '{ print $1 }' | sed s/\"//g)
        entryID=$(echo $entry | awk -F "," '{ print $2 }' | sed s/\"//g)
        #echo "$entryName => $entryID"

        entryTotalRunningTime=$(docker ps --filter id=$entryID --format {{.RunningFor}})

        if [[ "$(echo $entryTotalRunningTime | grep -e "years" -e "months" -e "weeks" -e "days" -v)" ]]; then
                echo "Container Name: $entryName => RunningTime: $entryTotalRunningTime" >> $fileStartup
        fi
done

echo "::過去24小時檔案異動清單::" > $fileChange
for entry in $containerList
do
        entryName=$(echo $entry | awk -F "," '{ print $1 }' | sed s/\"//g)
        entryID=$(echo $entry | awk -F "," '{ print $2 }' | sed s/\"//g)
        diffDir=$(docker inspect -f {{.GraphDriver.Data.UpperDir}} $entryID)
        changeList=$(find $diffDir -mtime -1)

        if [[ $changeList ]]; then
                echo -e "\n====== Name: $entryName ======" >> $fileChange
                echo "Ref. Host Path: $diffDir" >> $fileChange
                for current in $changeList
                do
                        currentShortPath=$(echo $current | sed "s|$diffDir|~|g")
                        echo -e "$(stat $current -c "%z")\t$currentShortPath" >> $fileChange
                done
        fi
done
