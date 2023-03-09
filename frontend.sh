script_location=$(pwd)
LOG=tmp/roboshop.log

echo -e "\e[31m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}


echo -e "\e[31m Remove Nginx Old Content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}

echo -e "\e[31m Download Frontend Contend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}

cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[31m Extract frontend content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}

echo -e "\e[31m Copy Roboshop Nginx Config File \e0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

echo -e "\e[31m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}

echo -e "\e[31m Restart Nginx \e[0m"
systemctl restart nginx &>>${LOG}


