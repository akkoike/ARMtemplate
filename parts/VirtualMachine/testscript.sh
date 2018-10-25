#!/bin/sh


timedatectl set-timezone Asia/Tokyo

sh /var/tmp/hoge.sh

echo "hogehoge"

touch /var/tmp/hogehoge.txt

cat /var/tmp/nnn.txt

echo $?
