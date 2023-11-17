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

  sleep 5

  # Shellcheck recommendation to introduce nested quotes is not worth it since we know the return will be an int.
  # shellcheck disable=SC2046
  while [ $(mysql --host="$ADDRESS" --port="$PORT" --user="$USERNAME" --password="$PASSWORD" -Bse "") -eq 0 ];
  do
    sleep 5
  done

  kill $webserver_pid
}

i_am_sad () {

  echo "Without my database I am sad." > index.html

  nohup busybox httpd -f -p 8080 &

  export webserver_pid="$!"

  sleep 5

  # Shellcheck recommendation to introduce nested quotes is not worth it since we know the return will be an int.
  # shellcheck disable=SC2046
  while [ $(mysql --host="$ADDRESS" --port="$PORT" --user="$USERNAME" --password="$PASSWORD" -Bse "") -ne 0 ];
  do
    sleep 5
  done

  kill $webserver_pid
}

while true;
do
  sleep 5

  # Shellcheck recommendation to introduce nested quotes is not worth it since we know the return will be an int.
  # shellcheck disable=SC2046
  if [ $(mysql --host="$ADDRESS" --port="$PORT" --user="$USERNAME" --password="$PASSWORD" -Bse "") -eq 0 ];
  then
    things_are_good
  else
    i_am_sad
  fi
done
