#!/bin/bash

arg=`cat ./config.ini | egrep -v "^#|^$" | awk -F '=' '/PY_MAJOR_VER/{print $NF}'`

sh ./tools/install_python.sh ${arg}

#EOF
