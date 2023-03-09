script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo Refer Log file more information, LOG - ${LOG}
    exit
    fi
}

echo -e "\e[31m Configure nodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[31m Install NodeJS\e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[31m Add Application User\e[0m"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
status_check

rm -rf /app/*
status_check

cd /app
unzip /tmp/catalogue.zip

cd /app
npm install
status_check

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service
status_check

systemctl daemon-reload
status_check

systemctl enable catalogue
status_check

systemctl start catalogue
status_check

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo
status_check

yum install mongodb-org-shell -y
status_check

mongo --host mongodb-dev.manishag.online </app/schema/catalogue.js
status_check








