#!/bin/bash
#
# Function: Install ansible via pip3, in GNU/Linux root user.

# pre-condition check
which ansible &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "\nAlready exists, no need to re-install.\n"
    exit 99
fi

# Install the latest ansible via pip3
which python3 &> /dev/null
if [[ $? -eq 0 ]]; then
    py_path=$(ls -l `which python3` | awk '{print $NF}' | awk -F '/' '{$NF=""; gsub(" ","/",$0); print $0}')
else
    echo "\nPlease install the python3 env first.\n"
    exit 99
fi

which pip3 &> /dev/null
if [[ $? -eq 0 ]]; then
    pip3 install ansible
else
    echo "\nPlease install the pip3 tool first.\n"
    exit 99
fi

# Install sshpass manually
which sshpass &> /dev/null
if [[ $? -ne 0 ]]; then
    yum install -y sshpass
fi

# In order to use the paramiko connection plugin or modules that require paramiko
pip3 show paramiko &> /dev/null
if [[ $? -ne 0 ]]; then
    pip3 install paramiko
    # paramiko causing Warnings due to Blowfish deprecation in cryptography 37.0.0
    pip3 uninstall -y cryptography
    pip3 install cryptography==36.0.2
fi

# Soft link ansible-related commands to the /usr/bin/ directory
which ansible &> /dev/null
if [[ $? -ne 0 ]]; then
    find ${py_path} -name "*ansible*" -type f | awk --re-interval '{match($0, /(^.*bin\/)(.*$)/, s); print "ln -s", s[0], "/usr/bin/"s[2]}' | sh
fi


# Configure the initial template
umask 0022
base_dir="/etc/ansible"
mkdir -p ${base_dir} && cd ${base_dir}
mkdir ${base_dir}/roles
touch ${base_dir}/hosts
curl -s https://raw.githubusercontent.com/ansible/ansible/stable-2.9/examples/ansible.cfg > ${base_dir}/ansible.cfg
sed -i 's/^#host_key_checking/host_key_checking/; s/^#roles_path.*=/roles_path =/' ${base_dir}/ansible.cfg
sed -i 's/^127.0.0.1.*$/127.0.0.1   localhost/' /etc/hosts

# Solve the connection error of scp/sftp
sed -i 's/^#scp_if_ssh.*$/scp_if_ssh = True/' ${base_dir}/ansible.cfg
sed -i 's/^Subsystem.*$/Subsystem sftp internal-sftp/' /etc/ssh/sshd_config
systemctl restart sshd.service


# As of Ansible 2.9, you can add shell completion of the Ansible command line utilities by installing an optional dependency called argcomplete.
pip3 install argcomplete

# Soft link argcomplete-related commands to the /usr/bin/ directory
find ${py_path} -name "*argcomplete*" -type f | awk --re-interval '{match($0, /(^.*bin\/)(.*$)/, s); print "ln -s", s[0], "/usr/bin/"s[2]}' | sh

# Configuring argcomplete
echo -e "\n# Global configuration" >> ~/.bash_profile
bash_ver=`bash --version 2>&1 | awk 'NR==1{gsub(/\(.*/,"",$4); print $4}' | cut -d '.' -f 1,2`
if [[ $(echo "${bash_ver} >= 4.2" | bc) -eq 1 ]]; then
    # Global completion requires bash 4.2.
    echo "activate-global-python-argcomplete" >> ~/.bash_profile
else
    # If you do not have bash 4.2, you must register each script independently.
    find ${py_path} -name "*ansible*" -type f | awk --re-interval '{match($0, /(^.*bin\/)(.*$)/, s); print "eval $(register-python-argcomplete", s[2]")"}' >> ~/.bash_profile   
fi
source ~/.bash_profile


# print related results
echo -e "\nView directory tree: \n"
tree ${base_dir} --noreport

echo -e "\nAnsible function local ping test.\n"
ansible localhost -m ping
# localhost | SUCCESS => {
# 	 "changed": false,
# 	 "ping": "pong"
# }

echo -e "\nAnsible version configuration info.\n"
ansible --version

#EOF
