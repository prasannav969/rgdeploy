#!/bin/bash
[ -z $RG_HOME ] && RG_HOME=/opt/deploy/sp2
baseurl=`cat "$RG_HOME/config/config.json" | jq -r '.baseURL'| sed -e 's#/$##'`
token=`cat "$RG_HOME/config/notification-config.json" | jq -r '.tokenID[0]'`

if [ -z $baseurl ]; then
    echo " Base URL is not configured in config.json. Exiting"
    exit 1
fi
is_app_running='No'
#Check if web application is up and running
for i in {0..3}
  do
    echo "Checking if app is running at $baseurl"
    echo "Checking if web application is up and running"
    status_code=$(curl -sL -w "%{http_code}\n" "$baseurl" -o /dev/null)
    if [ "$status_code" -ne 200 ]; then
      echo "Application is not up, responded with status $status_code"
    else
      echo "Application is up and running, status code response is $status_code"
      is_app_running='Yes'
      break
    fi
    sleep 5
  done

if [ "$is_app_running" == 'No' ]; then
    echo "The Research Gateway application is not running. Use start_server.sh to start it"
    exit 1
fi

echo "Congratulations! You have successfully setup your RLCatalyst Research Gateway"
echo "Please enter a few details to create the first admin user in the system"
read -p "First Name:" firstname
read -p "Last Name:" lastname
read -p "Email (required):" emailid

if [ -z $emailid ]; then
    echo "Email id is required. Cannot create user. Exiting"
    exit 1
fi
instanceid=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
data="{\"username\":\"rgadmin\",\"first_name\":\"$firstname\",\"last_name\":\"$lastname\",\"email\":\"$emailid\",\"password\":\"RgAdmin@$instanceid\",\"level\":2}"
#echo $data | jq -r

message=`curl --location --request POST "$baseurl/user/signup" --header "token: $token" --header "Content-Type: application/json" --data-raw $data | jq -r '.message'`
if [ $message == "success" ]; then
    echo "Admin user created. You should receive an email to verify your email address. Please click on the link to change your password"
else
    echo "Error: Could not create user. Please contact support"
fi