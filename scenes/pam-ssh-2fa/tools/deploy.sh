#!/bin/bash

currentdir=`dirname $(readlink -f $0)` 
basedir=`dirname $currentdir`"/" 


# only for centos7
os_ver=`awk 'BEGIN { FS="\""; OFS="" } /PRETTY_NAME/{ val=$(NF-1) } END { split(val, a, fs=" "); print(tolower(a[1]), a[3]) }' /etc/os-release`
test ${os_ver} == "centos7" && echo "Start Tasks." || exit 99


# global variable
auth_filename="auth-2fa.py"
pam_so="pam_python.so"


# install
if [[ $(rpm -qa | egrep -ic "pam|pam-devel") -ne 2 ]]; then
    yum -y install pam pam-devel
fi

if [[ $(rpm -qa git wget | wc -l) -ne 2 ]]; then
    yum -y install git wget
fi

cp -a ${basedir}/src/${pam_so} /lib64/security/${pam_so}

ldconfig -v 2> /dev/null | grep -i "libpython2.6.so.1.0"

if [[ $? -ne 0 ]]; then
    wget http://www.python.org/ftp/python/2.6.6/Python-2.6.6.tgz
    tar -xvf Python-2.6.6.tgz
    cd Python-2.6.6/
    ./configure --prefix=/usr/local/python26 --enable-shared
    make && make altinstall
    ln -s /usr/local/python26/lib/libpython2.6.so.1.0 /usr/lib/libpython2.6.so.1.0
    /sbin/ldconfig -v
    cd -
    rm -rf Python-2.6.6.tgz Python-2.6.6/
fi


# code
cp -a ${currentdir}/${auth_filename} /lib64/security/${auth_filename}


# sshd pam
line=`awk '/^auth/ { c=NR } END { print c }' /etc/pam.d/sshd`

content="auth       requisite    ${pam_so} ${auth_filename}"

sed -i "${line}a${content}" /etc/pam.d/sshd


# sshd_config
sed -i '/^ChallengeResponseAuthentication.*$/d;
       s/^#ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication yes/' \
/etc/ssh/sshd_config

systemctl restart sshd.service


#EOF
