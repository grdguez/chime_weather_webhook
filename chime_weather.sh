#!/bin/bash
# Pulls weather forecast from AccuWeather's API, outputs it to a Chime Room using a webhook.
# USAGE: chime_weather.sh <zipcode>
# Author: grdg

webhook_url="WEBHOOK URL HERE"

zipcode="$1"
zip_num=${#zipcode}
# Prompt user if zipcode omitted
if [[ -z $zipcode ]]; then
	read -p "Enter your zipcode: " zipcode
elif [[ $zip_num < 5 ]]; then
	echo -e "Error: Insufficient digits in zipcode \n"
fi

#if [ -z $1 ]; then
#    echo
#    echo "USAGE: ./weather.sh zipcode"
#    echo
#    exit 0;
#fi

weather="$(curl --connect-timeout 30 -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=${fahrenheit}\&locCode\=$1 | perl -ne 'if (/Currently/) {chomp;/\<title\>Currently: (.*)?\<\/title\>/; print "$1"; }')"

curl -g -X POST "$webhook_url" -H "Content-Type:application/json" --data-binary '{"Content":"@Present Weather Forecast > '"$weather"'"}'
