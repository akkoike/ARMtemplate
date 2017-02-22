#!/bin/sh

# update TimeZone
sudo timedatectl set-timezone Asia/Tokyo
NOW_DATE_JAPAN=`date +%Y%m%d`

# check custom-script.log file
CUSTOM_SCRIPT_LOG=/var/tmp/customscript.${NOW_DATE_JAPAN}.log

if [ ! -f ${CUSTOM_SCRIPT_LOG} ]
then
        sudo touch ${CUSTOM_SCRIPT_LOG}
fi

# add the timestamp in the logfile
sudo date >> ${CUSTOM_SCRIPT_LOG}

# update / upgrade standard package
sudo echo "------- [START]yum update -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum update -y
sudo echo "------- [END ${?}]yum update -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo echo "------- [START]yum upgrade -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum upgrade -y
sudo echo "------- [END ${?}]yum upgrade -y -------" >> ${CUSTOM_SCRIPT_LOG}

# install azure-cli and some OSS to need execute azure-cli
sudo echo "------- [START]yum install epel-release -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum install epel-release -y
sudo echo "------- [END ${?}]yum install epel-release -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo echo "------- [START]yum install nodejs -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum install nodejs -y
sudo echo "------- [END ${?}]yum install nodejs -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo echo "------- [START]yum install npm -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum install npm -y
sudo echo "------- [END ${?}]yum install npm -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo echo "------- [START]npm install -g azure-cli -------" >> ${CUSTOM_SCRIPT_LOG}
sudo npm install -g azure-cli
sudo echo "------- [END ${?}]npm install -g azure-cli -------" >> ${CUSTOM_SCRIPT_LOG}
sudo echo "Finished !! please check azure comandline"

# install github for linux
sudo echo "------- [START}]yum install git -y -------" >> ${CUSTOM_SCRIPT_LOG}
sudo yum install git -y
sudo echo "------- [END ${?}]yum install git -y -------" >> ${CUSTOM_SCRIPT_LOG}

sudo echo "Finished !! please check [azure] comandline and create local repository to execute [git init]" >> ${CUSTOM_SCRIPT_LOG}