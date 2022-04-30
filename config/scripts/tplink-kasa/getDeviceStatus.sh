#!/bin/bash

source /config/scripts/tplink-kasa/variables.sh
source /config/scripts/tplink-kasa/getTokenAge.sh
TOKEN=$(cat /config/scripts/tplink-kasa/kasa-token)
# source variables.sh
# source getTokenAge.sh
# TOKEN=$(cat kasa-token)
DEVICE_ID=$1

# generate_post_data()
# {
#   cat <<EOF
# {
# 	"method": "passthrough",
# 	"params": {
# 		"deviceId": "$DEVICE_ID",
# 		"requestData": {
# 			"system": {
# 				"get_sysinfo": null
# 			}
# 		},
# 		"token": "$TOKEN"
# 	}
# }
# EOF
# }

generate_post_data()
{
  cat <<EOF
{ \"method\" : \"passthrough\", \"params\" : { \"deviceId\" : \"$DEVICE_ID\", \"token\": \"$TOKEN\", \"requestData\" : '{ \"system\" : { \"get_sysinfo\" : null }}'}}
	
EOF
}


if [ "$TOKEN_AGE" -gt "$TOKEN_EXPIRATION" ]; then
	/config/scripts/tplink-kasa/getToken.sh
fi
# if [ "$TOKEN_AGE" -gt "$TOKEN_EXPIRATION" ]; then
# 	getToken.sh
# fi

deviceStatus=$(curl -s \
-H "Content-Type:application/json" \
-X POST --data "{ \"method\" : \"passthrough\", \"params\" : { \"deviceId\" : \"$DEVICE_ID\", \"token\": \"$TOKEN\", \"requestData\" : '{ \"system\" : { \"get_sysinfo\" : null }}'}}" "$API_URL")

echo  "$1 status: ${deviceStatus}"

#echo  "status: $(generate_post_data)"
