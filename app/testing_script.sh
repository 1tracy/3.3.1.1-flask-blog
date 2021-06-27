#!/bin/bash

basicendpoints=("/" "/health" "/blog")

for endpoint in "${basicendpoints[@]}"
do
    status=$(curl -s -o /dev/null -w "%{http_code}" https://1tracy.duckdns.org$endpoint)
    if [ $status -eq 200 ]
    then   
        echo $endpoint "passed."
    else
        echo $endpoint "failed."
    fi
done


# generate random username
random_user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
random_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

# test creating users
status=$(curl -X POST -d "username=$random_user&password=$random_password" https://1tracy.duckdns.org/register)
if [[ $status == "User "$random_user" created successfully" ]]
then
    echo "/register create new user passed."
else
    echo "/register create new user failed."
fi

# check existing users in register
status=$(curl -X POST -d "username=$random_user&password=$random_password" https://1tracy.duckdns.org/register)
if [[ $status == "User $random_user is already registered." ]]
then
    echo "/register existing user passed."
else
    echo "/register existing user failed."
fi

# test login endpoint
status=$(curl -X POST -d "username=$random_user&password=$random_password" https://1tracy.duckdns.org/login)
echo $status
if [[ $status == "Login Successful" ]]
then
    echo "/login successful passed."
else
    echo "/login successful failed"
fi

status=$(curl -X POST -d "username=$random_user&password=a$random_password" https://1tracy.duckdns.org/login)
if [[ $status == "Incorrect password." ]]
then
    echo "/login incorrect passed."
else
    echo "/login incorrect failed"
fi