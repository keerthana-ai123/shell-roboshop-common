#!/bin/bash 

source ./common.sh
app_name=redis

check_root

dnf module disable $app_name -y &>>$LOG_FILE
VALIDATE $? "Disabling Default $app_namedis"
dnf module enable $app_name:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling $app_name 7"
dnf install $app_name -y &>>$LOG_FILE
VALIDATE $? "Installing $app_name"

#sed -i 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf

sed -i 's/127.0.0.1/0.0.0.0/g; /protected-mode/s/.*/protected-mode no/' /etc/$app_name/$app_name.conf

VALIDATE $? "Allowing Remote Connections To $app_name"

systemctl enable $app_name &>>$LOG_FILE
VALIDATE $? "Enabling $app_name" 
systemctl start $app_name &>>$LOG_FILE
VALIDATE $? "Starting $app_name"

print_total_time