#!/bin/bash
# **************************************************
# Author: Pokeya
# Date: 2022-09-16
# Description: 查询网卡速率与网口个数
# **************************************************

test ${#} -ne 1 && exit 0

file=${1}

which lspci &> /dev/null
if [ ${?} -ne 0 ]; then
    echo "null" > ${file}
    exit 0
fi

host_name=$(hostname)
nic_info=$(lspci | grep "Ethernet" | awk '{if($0~/10GbE SFP+/ || $0~/10-Gigabit/){i++} else if($0~/40GbE QSFP+/){j++} else {x++}} END{{printf "10G: "i}; if(j>0){printf "; 40G: " j"\n"} else{printf "\n"}}')

echo "${host_name},${nic_info}" > ${file}

#EOF
