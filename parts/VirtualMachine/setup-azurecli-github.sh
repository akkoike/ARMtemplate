#!/bin/sh

# update TimeZone
timedatectl set-timezone Asia/Tokyo
NOW_DATE_JAPAN=`date +%Y%m%d`

# check custom-script.log file
CUSTOM_SCRIPT_LOG=/var/tmp/customscript.${NOW_DATE_JAPAN}.log

if [ ! -f ${CUSTOM_SCRIPT_LOG} ]
then
        touch ${CUSTOM_SCRIPT_LOG}
fi

# add the timestamp in the logfile
date >> ${CUSTOM_SCRIPT_LOG}

# update / upgrade standard package
echo "------- [START]yum update -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum update -y
echo "------- [END ${?}]yum update -y -------" >> ${CUSTOM_SCRIPT_LOG}
echo "------- [START]yum upgrade -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum upgrade -y
echo "------- [END ${?}]yum upgrade -y -------" >> ${CUSTOM_SCRIPT_LOG}

# install azure-cli and some OSS to need execute azure-cli
echo "------- [START]yum install epel-release -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum install epel-release -y
echo "------- [END ${?}]yum install epel-release -y -------" >> ${CUSTOM_SCRIPT_LOG}
echo "------- [START]yum install nodejs -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum install nodejs -y
echo "------- [END ${?}]yum install nodejs -y -------" >> ${CUSTOM_SCRIPT_LOG}
echo "------- [START]yum install npm -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum install npm -y
echo "------- [END ${?}]yum install npm -y -------" >> ${CUSTOM_SCRIPT_LOG}
echo "------- [START]npm install -g azure-cli -------" >> ${CUSTOM_SCRIPT_LOG}
npm install -g azure-cli
echo "------- [END ${?}]npm install -g azure-cli -------" >> ${CUSTOM_SCRIPT_LOG}
echo "Finished !! please check azure comandline"

# install github for linux
echo "------- [START}]yum install git -y -------" >> ${CUSTOM_SCRIPT_LOG}
yum install git -y
echo "------- [END ${?}]yum install git -y -------" >> ${CUSTOM_SCRIPT_LOG}

echo "Finished !! please check [azure] comandline and create local repository to execute [git init]" >> ${CUSTOM_SCRIPT_LOG}