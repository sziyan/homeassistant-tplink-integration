#!/bin/bash

source /config/scripts/tplink-kasa/variables.sh
source /config/scripts/tplink-kasa/getTokenAge.sh
TOKEN=$(cat /config/scripts/tplink-kasa/kasa-token)

# source variables.sh
# source getTokenAge.sh
# TOKEN=$(cat kasa-token)

#get parameters
for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            onoff)              ON_OFF=${VALUE} ;;
            deviceid)    DEVICE_ID=${VALUE} ;;
            *)   
    esac    


done


if [ "$TOKEN_AGE" -gt "$TOKEN_EXPIRATION" ]; then
	/config/scripts/tplink-kasa/getToken.sh
fi

setDeviceStatus=$(curl -s \
-H "Content-Type:application/json" \
-X POST --data "{ \"method\" : \"passthrough\", \"params\" : { \"deviceId\" : \"$DEVICE_ID\", \"token\": \"$TOKEN\", \"requestData\" : '{ \"system\" : { \"set_relay_state\" : { \"state\" : $ON_OFF }}}'}}" "$API_URL")

#echo  "${setDeviceStatus}"

#state_on=$( jq -r  '.result.responseData."smartlife.iot.smartbulb.lightingservice".transition_light_state.on_off' <<< "${setDeviceStatus}" ) 

sensorFile=/config/scripts/tplink-kasa/devices/$DEVICE_ID.txt
rm /config/scripts/tplink-kasa/devices/$DEVICE_ID.txt
echo  "$ON_OFF" > "$sensorFile"

echo "status: $setDeviceStatus"
echo "---"
echo "sensor: $ON_OFF"
