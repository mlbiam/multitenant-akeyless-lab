#!/bin/bash

wget -P /tmp https://github.com/charmbracelet/gum/releases/download/v0.14.5/gum_0.14.5_amd64.deb 
sudo dpkg -i /tmp/gum_0.14.5_amd64.deb

rm -rf ~/.akeyless
akeyless --init

export AKEYLESS_TOKEN="$(gum input --placeholder='Paste Akeyless Token here' --header='Akeyless Token'  --value=$AKEYLESS_TOKEN)" && echo "$AKEYLESS_TOKEN" > ~/conf/akeyless_token
export SFX=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 4 |  awk '{print tolower($0)}')

export AKEYLESS_AUTH_DATA=$(akeyless auth-method create api-key --name "lab-api-key-$SFX" --token $(< ~/conf/akeyless_token) --json 2>&1)

if [[ "$AKEYLESS_AUTH_DATA" =~ ^failed.* ]]
then
    echo "Already exists, try re-running"
    exit 1
fi

echo $AKEYLESS_AUTH_DATA > ~/conf/akeyless_accessid.json

akeyless assoc-role-am -r admin -a "/lab-api-key-$SFX" --token $(< ~/conf/akeyless_token) 


