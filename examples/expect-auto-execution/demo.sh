#!/bin/bash

PORT=22

if [[ ${#} -eq 3 ]];then
    USER=${1}
    HOST=${2}
    PASSWD=${3}
else
    echo -e "\nMissing required positional parameter.\n"
    exit 1
fi

/usr/bin/expect  << EOF
    set timeout -1
    spawn sftp -o port=$PORT $USER@$HOST
    expect {
        "(yes/no)" { send "yes\n"; exp_continue }
        "password" { send "$PASSWD\n" }
    }
    expect -re "sftp> " { send "pwd\n" }
    expect -re "sftp> " { send "ls -l\n" }
    expect -re "sftp> " { send "put ${0}\n" }
    expect -re "sftp> " { send "bye\n" }
    expect eof
EOF

#EOF
