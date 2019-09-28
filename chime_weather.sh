#!/bin/bash
# Pulls weather forecast from AccuWeather's API, outputs it to a Chime Room using a webhook.
# USAGE: chime_weather.sh <zipcode>
# Author: grdg

webhook_url="WEBHOOK URL HERE"

METRIC=1 #Should be 0 or 1; 0 for F, 1 for C


if [ -z $1 ]; then

    echo

    echo "USAGE: chime_weather.sh <zipcode>"

    echo

    exit 0;

fi

weather="$(curl --connect-timeout 30 -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=${fahrenheit}\&locCode\=$1 | perl -ne 'if (/Currently/) {chomp;/\<title\>Currently: (.*)?\<\/title\>/; print "$1"; }')"

curl -g -X POST "$webhook_url" -H "Content-Type:application/json" --data-binary '{"Content":"@Present MIA1 Weather Forecast > '"$weather"'"}'
