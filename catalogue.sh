script_location=$(pwd)

set -e
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
rm -rf /app/
#useradd roboshop
mkdir -p /app

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

 cp ${script_location}/files/catalogue.service/etc/sustemd/system/catalogue.service
 systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y

mongo --host localhost </app/schema/catalogue.js