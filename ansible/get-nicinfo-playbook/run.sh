#!/bin/sh

base_path="."

group_tag="all"

forks=`cat ${base_path}/hosts | grep -vE "^#|^$|^\[.*\]" | wc -l`

ansible-playbook -i ${base_path}/hosts -f ${forks} -e "inventory=${group_tag}" ${base_path}/main.yml


#EOF
