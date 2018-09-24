#!/usr/bin/env bash
OPTIND=1         # Reset in case getopts has been used previously in the shell.
bold=$(tput bold)
normal=$(tput sgr0)
red="\e[31m"
bold="\e[1m"
green="\e[32m"
yellow="\e[33m"
WP_URLs=('https://danzaparavivir.com' 'https://serlibreyfeliz.com')
SOUND_FILE="/path/to/sound_file"

function wordpress {
    current_version=$(curl -s https://api.wordpress.org/core/version-check/1.7/ -s | jq '.offers[] | select(.response=="upgrade") | .version' | tr -d '.' | tr -d '"')
    installed_version=$(curl -s ${1} | grep -Po "(?<=${1}/wp-content/themes/wallstreet/css/bootstrap\.css\?ver=)\d\.\d\.\d\.?" | tr -d '.')
    website_name=$(echo ${1} | grep -Po '(?<=http[s]://|www\.).*(?=\..*)')
    if [[ ${current_version} -gt "${installed_version}" ]];then
        notify-send "Wordpress Installation" ""${website_name^}" update available." -i software-update-urgent
    fi
    if [[ $(which paplay) != *'not found'* ]];then
        paplay ${SOUND_FILE}
    fi
}

function help
{
  echo -e "${red}${bold}DESCRIPTION \e[0m"
  echo -e "Check if managed software is updated."
  echo -e "   $green $bold -w  ${normal}${yellow}Wordpress: ${normal}Check if wordpress installation is up to date."
  echo -e "   $green $bold -h  ${normal}Help: ${yellow}Prints this help message."
}
if [ $# -eq 0 ];then
        help
fi
while getopts "hwab" OPTION; do
    case $OPTION in
        w)
            for url in ${WP_URLs[@]}; do
                wordpress $url
            done
            ;;
        h)
            help
            exit 0
            ;;
        ?)
            help
            exit 0
            ;;
    esac
done