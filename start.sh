#!/bin/zsh

#TARGET=$1

echo -e "\e[31m
█▀▀ █░░ █▀ █▀▀ ▄▀█ ▀▀█ ▄▄ ▄█ ▄█ █▀█
██▄ █▄▄ ▄█ █▀░ █▀█ ░░█ ░░ ░█ ░█ █▄█
coded by @ELSFA7-110@automotion bughunting@\n\e[0m"

echo -e "Start Subfinder \n"

subfinder -d $1 -t 100 -o subfinder.txt

echo -e "Start Findomain \n"

findomain --quiet -t $1 -u findomain.txt

echo -e "Start crobat \n"

crobat -s $1 $DEBUG_ERROR | anew -q crobat.txt

echo -e "Start Sort \n"

cat subfinder.txt crobat.txt findomain.txt|sort -u|tee Final-subs.txt

echo -e "Start Httpx and Port Scanning \n"

cat Final-subs.txt | naabu | httpx -threads 1000 -o $1-alive-subs.txt

echo -e "handle it \n"
rm Final-subs.txt subfinder.txt crobat.txt findomain.txt

echo -e "Start nuclei \n"
nuclei -update-templates

nuclei -l $1-alive-subs.txt -s low,medium,high,critical

echo -e "Start uncover>nuclei \n"
echo $1 | uncover -e shodan,censys -silent | httpx | nuclei -s low,medium,high,critical

