#!/bin/bash

conf="user_conf/"

os_version=$(awk 'BEGIN { FS="\""; OFS="" } \
                 /PRETTY_NAME/{ val=$(NF-1) } \
                 END { split(val, a, fs=" "); print(tolower(a[1]), a[3]) }' \
            /etc/os-release)

login_user=`whoami`

echo -e "\nCurrent System: '${os_version}'  |  Current User: '${login_user}'\n"

test -d ${conf} \
  && (echo "The following files will be updated (replaced):"; ls -A ${conf}) \
  || (echo "File directory does not exist."; exit 99)

read -rep $'\nWhether to overwrite and execute (y/n) ' action

case ${action} in
    'y'|'Y')
        # Remove system environment files
        ls -A ${conf} | awk '{system("mv ~/"$0" /tmp/"$0".bak")}' &> /dev/null

        # Using new configuration files
        cp -a ${conf}.[^.]* $HOME

        # Version compatible: replace .bash_profile with .profile
        if [[ -f $HOME/.profile ]]; then
            mv $HOME/.profile /tmp/.profile.bak
            mv $HOME/.bash_profile $HOME/.profile
        fi
        echo -e "\nJob Completed!\n"
    ;;
    'n'|'N')
        echo -e "\nJob Canceled!\n"
    ;;
    *)
        echo -e "\nInput Error!\n"
        exit 99
    ;;
esac

exit 0
#EOF
