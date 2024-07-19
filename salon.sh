#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  echo -e "Welcome to My Salon, how can I help you?\n"

  GET_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$GET_SERVICES" | while read ID BAR NAME
  do
    if [[ $ID =~ ^[0-9]+$ ]]
    then
      echo "$ID) $NAME"
    fi
  done

  read SERVICE_ID_SELECTED

  GET_SERNAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $GET_SERNAME ]]
  then
    MAIN_MENU "WRONG ID SELECTED !!"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo $CUSTOMER_NAME
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      CUST_IN_RES=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    CID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME

    APP_INS=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $GET_SERNAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU