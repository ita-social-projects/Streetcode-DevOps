#!/bin/bash


path="/etc/environment"


currentToken=$(grep '^INSTAGRAM_TOKEN=' "$path" | cut -d'=' -f2 | tr -d '"')


newToken=$(curl -s "https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&access_token=${currentToken}" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)


if [ -z "$newToken" ]; then
  echo "Failed to retrieve new access token."
  exit 1
fi


awk -v newToken="${newToken}" '/^INSTAGRAM_TOKEN=/{gsub(/=.*/, "=\"" newToken "\"")}1' "$path" > tmpfile && mv tmpfile "$path"



echo "New INSTAGRAM_TOKEN: $newToken"


echo "OLD token: $currentToken"
