#!/usr/bin/env bash
red='\e[31m'
green="\e[32m"
yellow="\e[33m"
normal=$(tput sgr0)

working_dir="/home/sample_user"

function cleanup
{
 rm -rf ${working_dir}latest.zip ${working_dir}wordpress 
}

if [ "$EUID" -ne 0 ];then
    echo -e "[${red}-${normal}] Please run with root privileges"
    cleanup
    exit
fi
echo -e "[${green}+${normal}] Downloading latest wordpress installation ..."
wget -q https://wordpress.org/latest.zip
echo -e "[${green}+${normal}] Unziping ..."
unzip -q latest.zip
latest_version=$(cat wordpress/wp-includes/version.php | sed -n -e 's/^.*$wp_version = //p')
rootpath="/var/www/"

websites=("/var/www/serlibreyfeliz.com" "/var/www/danzaparavivir.com" "/var/www/afrotantra.net" "/var/www/love-me.me" "/var/www/befreeandhappy.com")
for website in ${websites[@]};do
    website_version=$(cat $website/wp-includes/version.php | sed -n -e 's/^.*$wp_version = //p')
    if [[ "$latest_version" ==  "$website_version" ]];then
        echo -e "[${green}+${normal}] ${website#${rootpath}} is up to date."
    else
        echo -e "[${yellow}+${normal}] Updating ${website#${rootpath}}."
        while true; do
            read -p "Did you disable the plugins?: " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done

        rm -rf $website/wp-includes $website/wp-admin
        cp -R wordpress/wp-includes $website/
        cp -R wordpress/wp-admin $website/
        cp -R wordpress/wp-content/* $website/wp-content/
        cp wordpress/index.php $website/
        cp wordpress/license.txt $website/
        cp wordpress/readme.html $website/
        cp wordpress/wp-activate.php $website/
        cp wordpress/wp-blog-header.php $website/
        cp wordpress/wp-comments-post.php $website/
        cp wordpress/wp-config-sample.php $website/
        cp wordpress/wp-cron.php $website/
        cp wordpress/wp-links-opml.php $website/
        cp wordpress/wp-load.php $website/
        cp wordpress/wp-login.php $website/
        cp wordpress/wp-mail.php $website/
        cp wordpress/wp-settings.php $website/
        cp wordpress/wp-signup.php $website/
        cp wordpress/wp-trackback.php $website/
        cp wordpress/xmlrpc.php $website/
        echo -e "[${green}+${normal}] ${website#${rootpath}} is up to date."
    fi
done
cleanup
