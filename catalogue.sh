souece common.sh

print_head "Configure nodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
echo -e "\e[31m \e[0m"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application User"
useradd roboshop &>>${LOG}
status_check

print_head "Downloading App content"
mkdir -p /app&>>${LOG}

print_head "Cleanup Old Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip&>>${LOG}
status_check

print_head "Extracting App Content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Installing NodeJS Dependencies"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}

print_head "Configure Catalogue Service File"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head
systemctl daemon-reload
status_check

print_head
systemctl enable catalogue
status_check

print_head
systemctl start catalogue
status_check

print_head
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo
status_check

print_head
yum install mongodb-org-shell -y
status_check

print_head
mongo --host mongodb-dev.manishag.online </app/schema/catalogue.js
status_check








