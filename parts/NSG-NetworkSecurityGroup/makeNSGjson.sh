#!/bin/sh

# sample
# 優先度,NSG名,ルール名,送信・受信,送信元アドレス,発信元ポート範囲,宛先アドレス,サービス（プロトコル）,サービス（ポート）,アクション

## field1 優先度
## field2 NSG名
## field3 ルール名
## field4 送信・受信
## field5 送信元アドレス
## field6 発信元ポート範囲
## field7 宛先アドレス
## field8 サービス1（プロトコル）
## field9 サービス2（ポート）
## field10 アクション(Allow/Deny)

# change BASE_DIR_PATH for your local path
BASE_DIR_PATH=/home/azure01/csv2
TMPDIR_PATH=${BASE_DIR_PATH}/tmpdir
TMPDIR_NSG_PATH=${BASE_DIR_PATH}/tmpdir/nsg
RTN=0

# check command line
if [ "${2}" = "" ]
then
        echo "usage makeJason.sh inputfilename(csv) outputfilename(json) [debug]"
        exit
fi
# check inputfile size
if [ ! -s ${1} ]
then
        echo "usage makeJason.sh inputfilename(csv) outputfilename(json) [debug]"
        exit
fi
# make temporary directory
if [ ! -d ${TMPDIR_PATH} ]
then
        mkdir -p ${TMPDIR_PATH}
fi

# cut first line and sort/uniq by NSG name
LINE_END_COUNTER=`wc -l ${1} | awk '{ print $1 }'`
RAW_LINE=`expr ${LINE_END_COUNTER} - 1`
tail -${RAW_LINE} ${1} | sort -t , -k2 | uniq > ${TMPDIR_PATH}/INPUT_RAW.csv

# [ANY] check (sub routine)
function anycheck() {
        if [ "${1}" = "ANY" ]
        then
                RTN='*'
        else
                RTN=`echo "${1}"`
        fi
}

# making JSON files
for LINE in `cat ${TMPDIR_PATH}/INPUT_RAW.csv`
do
        # priority
        field1=`echo ${LINE} | awk -F"," '{ print $1 }'`
        # NSG name
        field2=`echo ${LINE} | awk -F"," '{ print $2 }'`
        # role name
        field3=`echo ${LINE} | awk -F"," '{ print $3 }'`
        # direction Inbound or Outbound
        field4=`echo ${LINE} | awk -F"," '{ print $4 }'`
        # source address
        field5=`echo ${LINE} | awk -F"," '{ print $5 }'`
        anycheck ${field5}
        field5=`echo "${RTN}"`
        # source port range
        field6=`echo ${LINE} | awk -F"," '{ print $6 }'`
        anycheck ${field6}
        field6=`echo "${RTN}"`
        # distination address
        field7=`echo ${LINE} | awk -F"," '{ print $7 }'`
        anycheck ${field7}
        field7=`echo "${RTN}"`
        # service protocol
        field8=`echo ${LINE} | awk -F"," '{ print $8 }'`
        anycheck ${field8}
        field8=`echo "${RTN}"`
        # service port
        field9=`echo ${LINE} | awk -F"," '{ print $9 }'`
        anycheck ${field9}
        field9=`echo "${RTN}"`
        # Allow or Deny
        field10=`echo ${LINE} | awk -F"," '{ print $10 }'`

        if [ ! -d ${TMPDIR_NSG_PATH} ]
        then
                mkdir -p ${TMPDIR_NSG_PATH}
        fi

        if [ ! -f ${TMPDIR_NSG_PATH}/${field2} ]
        then
                echo "          {" > ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"comments\": \"sample nsg template\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"type\": \"Microsoft.Network/networkSecurityGroups\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"name\": \"${field2}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"apiVersion\": \"2016-03-30\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"location\": \"[resourceGroup().location]\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                  \"properties\": {" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                     \"securityRules\": [" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                             {" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     \"name\": \"${field3}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     \"properties\": {" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"protocol\": \"${field8}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"sourcePortRange\": \"${field6}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"destinationPortRange\": \"${field9}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"sourceAddressPrefix\": \"${field5}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"destinationAddressPrefix\": \"${field7}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"access\": \"${field10}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"priority\": ${field1}," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"direction\": \"${field4}\"" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     }" >> ${TMPDIR_NSG_PATH}/${field2}
        else
                echo "                             }," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                             {" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     \"name\": \"${field3}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     \"properties\": {" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"protocol\": \"${field8}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"sourcePortRange\": \"${field6}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"destinationPortRange\": \"${field9}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"sourceAddressPrefix\": \"${field5}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"destinationAddressPrefix\": \"${field7}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"access\": \"${field10}\"," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"priority\": ${field1}," >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                          \"direction\": \"${field4}\"" >> ${TMPDIR_NSG_PATH}/${field2}
                echo "                                     }" >> ${TMPDIR_NSG_PATH}/${field2}

        fi
done


# close nsg files and marge all files , finaly make a nsg template
# making header parts
                echo "{" > ${TMPDIR_PATH}/${2}.tmp
                echo "  \"\$schema\": \"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#\"," >> ${TMPDIR_PATH}/${2}.tmp
                echo "  \"contentVersion\": \"1.0.0.0\"," >> ${TMPDIR_PATH}/${2}.tmp
                echo "  \"parameters\": {}," >> ${TMPDIR_PATH}/${2}.tmp
                echo "  \"variables\": {}," >> ${TMPDIR_PATH}/${2}.tmp
                echo "  \"resources\": [" >> ${TMPDIR_PATH}/${2}.tmp
# making nsg parts
for TMP_NSG_JSON in `ls ${TMPDIR_NSG_PATH}`
do
                echo "                             }" >> ${TMPDIR_NSG_PATH}/${TMP_NSG_JSON}
                echo "                     ]" >> ${TMPDIR_NSG_PATH}/${TMP_NSG_JSON}
                echo "                  }" >> ${TMPDIR_NSG_PATH}/${TMP_NSG_JSON}
                echo "          }," >> ${TMPDIR_NSG_PATH}/${TMP_NSG_JSON}
                cat ${TMPDIR_NSG_PATH}/${TMP_NSG_JSON} >> ${TMPDIR_PATH}/${2}.tmp
done
# making footer parts (NSG final line change "}," to "}"
sed -e '$d' ${TMPDIR_PATH}/${2}.tmp > ${TMPDIR_PATH}/${2}.tmp2
sed '$a \\t\t}' ${TMPDIR_PATH}/${2}.tmp2 >> ${TMPDIR_PATH}/${2}.tmp3
                echo "  ]" >> ${TMPDIR_PATH}/${2}.tmp3
                echo "}" >> ${TMPDIR_PATH}/${2}.tmp3

# backup in tmpdir and create outputfile
cp -p ${TMPDIR_PATH}/${2}.tmp3 ${2}

# clean temporary directory
if [ "${3}" != "debug" ]
then
        if [ -d ${TMPDIR_PATH} ]
        then
                rm -rf ${TMPDIR_PATH}
        fi
fi