#!/bin/bash


ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

 TIMESTAMP=$(date +%F-%H-%M-%S)
 LOGFILE="/tmp/$0-$TIMESTAMP.log"

 echo "script started executing at $TIMESTAMP" &>> $LOGFILE

 VALIDATE (){
    if [ $1 -ne 0 ]
    then 
    echo -e "$2 ..... $R failed $N"
    else
    echo -e "$2 ......$G success $N"
    fi
 } 

 if [ $ID -ne 0 ]
            then 
                echo -e " $R error :: please run this script with root access $N"
                exit 1
            else
                echo "you are root  user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "disable nodejs catalogue "
 
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "enable nodejs:18 catalogue "

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "dnf install catalogue "

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then 
useradd roboshop 
VALIDATE $? "roboshop user creation  "
else 
echo -e " Roboshop user already exit $Y skipping $N "
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "/app  "

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "/tmp/catalogue.zip   "

cd /app  &>> $LOGFILE
VALIDATE $? "/tmp/catalogue.zip   "

unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "/tmp/catalogue.zip  unzip "

npm install  &>> $LOGFILE
VALIDATE $? "installing the npm "

cp   /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "configuration catalogue "

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon-reload catalogue "

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enable catalogue catalogue "

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "start catalogue catalogue "

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "mongo.repon catalogue "

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "install mongodb-org-shell catalogue "

mongo --host 54.174.138.230 </app/schema/catalogue.js
VALIDATE $? "loading catalogue data to mogodb "
