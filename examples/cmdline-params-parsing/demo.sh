#!/bin/bash

# Verify whether ip is a legal parameter
check_ip() {
    ipaddr=${1}
    valid_check=$(echo $ipaddr | awk -F '.' '$1<=255 && $2<=255 && $3<=255 && $4<=255{print "yes"}')
    if echo $ipaddr | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" > /dev/null; then
        if [[ ${valid_check:-no} == "yes" ]]; then
            continue
        else
            echo -e "\nPlease enter a legal ipv4 address!\n"
            exit 1
        fi
    else
        echo -e "\nPlease enter a correct ipv4 format!\n"
        exit 1
    fi
}


# Command line parameter processing
help_info="
Usage: sh ${0} [OPTION]...
Validity tool for detecting IPv4.

Mandatory arguments to short options.
  -i                with an ipv4 address.
  -h                display this help and exit.

For example:
  $ sh ${0} -i 192.168.1.100
"
err_info="Try '${0} -h' for more information."

if [[ ${#} -eq 0 ]] || [[ ${#} -gt 2 ]]; then
    echo -e "\n${err_info}\n"
    exit 99
fi

while getopts 'i:h' args
do
    case $args in
        i)
            ip=${OPTARG}
            check_ip ${ip}
        ;;
        h)
            echo "${help_info}"
            exit 0
        ;;
        *)
            echo -e "\n${err_info}\n"
            exit 99
    esac
done

#EOF
