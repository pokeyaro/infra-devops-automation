#!/bin/bash

symbols=`perl -e "print '#' x 50;"`


# Change the input and output function content
# according to your actual scenario
input() {
    clear

    echo "${symbols}"
    read -p "Please enter ipaddr: " ip
    read -p "Please enter netmask: " netmask
    read -p "Please enter gateway: " gateway
    echo -e "\n${symbols}\n"

    # add a line break for read command
    read -rep $'[y] Confirm to continue | [n] Re-enter | [q] Quit\n' select
}

output() {
    echo -e "${symbols}\n"
    echo -e "Result:\n  ip: ${ip}\n  netmask: ${netmask}\n  gateway: ${gateway}\n"
}


# Main function
main() {
    # Cycle options menu
    while true
    do
        input
        case ${select} in
            'y')
                break
            ;;
            'n')
                continue
            ;;
            'q')
                exit 0
            ;;
            *)
                echo -e "\nInput Error !\n"
                sleep 1
            ;;
        esac
    done

    # Print result
    output
}
main

#EOF
