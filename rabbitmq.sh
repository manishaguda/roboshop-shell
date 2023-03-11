source common.sh


if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable root_rabbitmq_password is missing"
  exit
  fi


print_head "Configure Erlang Yum Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check


print_head "Configure RabbitMQ Yum Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install RabbitMQ & Erlang"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable RabbitMQ Server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start RabbitMQ Server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Add Application Configure"
rabbitmqctl add_user roboshop roboshop123 &>>${LOG}
status_check


print_head "Add Tags To Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check


print_head "Add Permission To Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check