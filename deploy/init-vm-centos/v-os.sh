#!/bin/bash
#
# Function: Example Initialize the Linux Centos7.x VM.
#


# [admin] password
passwd="1qaz!QAZ"


# Declare an array to store the results
declare -a resArray


# Sudo [admin] No-password operations.
which expect &>/dev/null
if [[ $? -eq 0 ]]; then
	expect -c "
		set timeout -1;
		spawn sudo sed -i \"/^%wheel/a\ admin   ALL=(ALL:ALL)   NOPASSWD:ALL\" /etc/sudoers;
		expect {
			*password* { send \"${passwd}\r\" }
		};
		expect eof;
	" &> /dev/null
else
	# echo -e "\nPlease install the Expect tool.\n"
	# exit 0
	sudo yum install -y expect
fi
check=`sudo sed -n '/^%wheel/,/^$/p' /etc/sudoers | grep -i "^admin" | wc -l`
if [[ ${check} -gt 1 ]]; then
	sudo sed -i '/^%wheel/{n;/admin/d}' /etc/sudoers
fi
resArray[0]="， Modify sudo admin free-passwd   [success]"


# Changing [root] Password.
echo "root:${passwd}" | sudo chpasswd
resArray[1]="， Change root superuser passwd    [success]"


# Changing the host name.
if [[ `cat /etc/hostname` != "localhost" ]] || [[ `hostnamectl --transient` != "localhost" ]]; then
	sudo hostnamectl set-hostname "localhost" --static
	sudo hostnamectl set-hostname "localhost" --transient
fi
resArray[2]="， Modify default hostname         [success]"


# Create [admin] .vimrc file.
cat > ${HOME}/.vimrc <<End-of-message
set encoding=utf-8
set termencoding=utf-8
set fileencoding=chinese
set fileencodings=ucs-bom,utf-8,chinese
set langmenu=zh_CN,utf-8
End-of-message
resArray[3]="， Create admin .vimrc file        [success]"


# Add [admin] .bashrc content.
content="alias ..='cd ..'
alias .='cd .'
alias l='ls -la'
alias md='mkdir -p'
alias rm='rm -rf'
"
check=`sed -n '/User specific/,$p' ${HOME}/.bashrc | wc -l`
if [[ ${check} -le 1 ]]; then
	echo -e "${content}" >> ${HOME}/.bashrc
fi
resArray[4]="， Modify admin .bashrc file       [success]"


# Allow [root] to login remotely using SSH.
sudo grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config
if [[ $? -ne 0 ]]; then
	sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/p' /etc/ssh/sshd_config
	sudo systemctl reload sshd.service
fi
resArray[5]="， Allow root login via ssh        [success]"


# Install the common Linux command toolset.
tools="tmux zip lrzsz mlocate tree strace sysstat net-tools traceroute lsof nmap telnet mtr pv bash-completion wget curl git"
if [[ `echo "${tools}" | xargs -n 1 | wc -l` -gt `rpm -qa | egrep -iw $(echo ${tools} | sed 's/[[:space:]]/|/g') | wc -l` ]]; then
	sudo yum -y install ${tools} &> /dev/null
fi
resArray[6]="， Install common Linux tools      [success]"


# Close the iptables service.
check_status=`sudo systemctl status firewalld.service | awk '/Loaded/{print $2}'`
check_enable=`sudo systemctl is-enabled firewalld.service`
if [[ "${check_status}" != "masked" ]] || [[ "${check_enable}" != "masked" ]] || [[ `sudo iptables -nvL | grep -v "^$" | wc -l` -eq 6 ]]; then
	sudo systemctl stop firewalld &> /dev/null
	sudo systemctl mask firewalld &> /dev/null
fi
resArray[7]="， Close the iptables service      [success]"


# Show results
clear
source ${HOME}/.bashrc
IFS=$'\n'; echo -e "\n${resArray[*]}\n"


rm -- $0

#EOF
