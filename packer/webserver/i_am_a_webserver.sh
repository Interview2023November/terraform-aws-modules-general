#!/bin/bash

# This script mocks a web server which requires a mysql backend.
# A positive or negative response is given to indicate whether we have our backend.

export ADDRESS=$1
export PORT=$2
export USERNAME=$3
export PASSWORD=$4

things_are_good () {

  echo "I can reach the database, things are good." > index.html

  nohup busybox httpd -f -p 8080 &

  export webserver_pid="$!"

  mysql --host=$ADDRESS --port=$PORT --user=$USERNAME --password=$PASSWORD -Bse ""

  while [ $? -eq 0 ];
  do
    sleep 5
    mysql --host=$ADDRESS --port=$PORT --user=$USERNAME --password=$PASSWORD -Bse ""
  done

  kill $webserver_pid
}

i_am_sad () {

  echo "Without my database I am sad." > index.html

  nohup busybox httpd -f -p 8080 &

  export webserver_pid="$!"

  mysql --host=$ADDRESS --port=$PORT --user=$USERNAME --password=$PASSWORD -Bse ""

  while [ $? -ne 0 ];
  do
    sleep 5
    mysql --host=$ADDRESS --port=$PORT --user=$USERNAME --password=$PASSWORD -Bse ""
  done

  kill $webserver_pid
}

while true;
do
  sleep 5

  mysql --host=$ADDRESS --port=$PORT --user=$USERNAME --password=$PASSWORD -Bse ""

  if [ $? -eq 0 ];
  then
    things_are_good
  else
    i_am_sad
  fi
done
