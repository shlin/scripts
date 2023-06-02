#!/bin/bash

containerList=`docker ps --format "{{json .Names}}:{{json .ID}}" | sort `

for container in $containerList
do
        echo $container
done
