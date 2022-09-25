#!/bin/bash
#Desc: 若Ansible主机列表中存在ping无法正常通讯的情况, 将该行信息进行注释

if [[ ${#} -ne 1 ]]; then
    echo -e "\nIncorrect positional parameter.\n"
    exit 99
fi

test -f ${1} && inventory=${1} || exit

count=`cat ${inventory} | grep -v "^#|^$" | grep -v "^\[" | wc -l`

hosts=`ansible -i ${inventory} all -m ping -f ${count} -e "ansible_python_interpreter=/usr/bin/python3" | awk '/UNREACHABLE/{print $1}'`

for i in `echo "${hosts}" | xargs -n 1`
do
    sed -i "/${i}/s/^/# /" ${inventory}
done

#EOF
