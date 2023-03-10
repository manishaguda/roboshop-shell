script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo Refer Log file more information, LOG - ${LOG}
    exit
    fi
}

print_head() {
  echo -e "\e[1m $1  \e[0m"
}

NODEJS() {
  print_head "Configure nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install NodeJS"
  echo -e "\e[31m \e[0m"
  yum install nodejs -y &>>${LOG}
  status_check

  print_head "Add Application User"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG}
    fi
  status_check

  print_head "Downloading App content"
  mkdir -p /app &>>${LOG}

  print_head "Cleanup Old Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip&>>${LOG}
  status_check

  print_head "Extracting App Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Installing NodeJS Dependencies"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}

  print_head "Configure User Service File"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  print_head "Configuring User Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable ${component} Service"
  systemctl enable user &>>${LOG}
  status_check

  print_head "Start ${component} Service"
  systemctl start user &>>${LOG}
  status_check

  print_head"configuring Mongo Repo "
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check

  print_head "Install Mongo Repo"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "Load Schema "
  mongo --host mongodb-dev.manishag.online </app/schema/user.js &>>${LOG}
  status_check

}
