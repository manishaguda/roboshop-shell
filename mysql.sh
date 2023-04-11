source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
  fi

print_head "Disable MySql Default Module"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Copy MySql Repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySql Server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable MySql"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start MySql"
systemctl restart mysqld &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
status_check