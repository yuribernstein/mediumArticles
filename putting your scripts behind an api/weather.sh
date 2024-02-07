#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <zip_code> [country_code]"
    echo "Example: $0 90210 US"
    exit 1
fi

ZIP_CODE=$1
COUNTRY_CODE=${2:-us} # Default to 'us' if no country code is provided
API_KEY="YOUR API KEY"
API_URL="http://api.openweathermap.org/data/2.5/weather?zip=$ZIP_CODE,$COUNTRY_CODE&appid=$API_KEY&units=metric"

RESPONSE=$(curl -s "$API_URL")

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch weather data."
    exit 1
fi

echo "Weather for ZIP Code $ZIP_CODE in $(echo $RESPONSE | jq '.name'):"
echo "Temperature: $(echo $RESPONSE | jq '.main.temp')°C"
echo "Conditions: $(echo $RESPONSE | jq -r '.weather[0].description')"
echo "Humidity: $(echo $RESPONSE | jq '.main.humidity')%"
echo "Wind Speed: $(echo $RESPONSE | jq '.wind.speed') m/s"

