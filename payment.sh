source common.sh

component=payment
schema_load=true

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable root_rabbitmq_password is missing"
  exit 1
 fi

PHYTHON
