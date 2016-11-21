README

--------------------------------------------------------------------
## you need to install Azure-CLi
# install Azure-Cli (please enter bellow command line)

	hostname$ sudo su -
	hostname# yum update
	hostname# yum upgrade -y
	hostname# yum install epel-release
	hostname# yum install nodejs
	hostname# yum install npm
	hostname# npm install -g azure-cli
	hostname# exit
	hostname$ azure help

--------------------------------------------------------------------
## Set your Microsoft Account when you login the terminal (CentOS)
# change config-mode to ARM
	azure config mode arm

# check the my account list with subscription-id
	azure account list
# set your subscription-id
	azure account set subscription-id

--------------------------------------------------------------------
## How to use ARM templates (change the <***> record for your environment)
# create azure resource group from Azure-Cli
	azure group create <resource group name> japaneast

# export ARM templates and download json file in template directory 
	azure group export <resource group name> ./template

# validate(check) json files before deploy your resource group 
	azure group template validate <resource group name> -f ./template/<filename>.json

# deploy your resource group from json file (incremental deploy)
	azure group deployment create <resource group name> -f ./template/<filename>.json

# deploy your resource group from json file (Complete deploy **CAUTION**)
	azure group deployment create --mode Complete <resource group name> -f ./template/<filename>.json

