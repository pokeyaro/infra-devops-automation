#!/bin/bash

function check_pip(){
    pip3 --version 2> /dev/null | grep -iq "python 3"
    if [ $? -ne 0 ]; then
        echo -e "\nPlease install pip3 first!\n"
        exit 99
    fi
}
check_pip

######################
# Python Virtual Env #
######################

virtual_env="venv"

# Install python virtual package.
echo "1. Install virtualenvwrapper module."
pip3 install virtualenvwrapper -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# Config the virtual env .bashrc file.
echo "2. Add virtual info to .bashrc file."
base_path=`find / -name "virtualenvwrapper.sh" | head -n 1 | sed 's/\/virtualenvwrapper.sh//'`
echo -e "\nLoad the virtual environment of python:\n" >> ${HOME}/.bashrc
echo "export PATH=\$PATH:${base_path}/" >> ${HOME}/.bashrc
echo "export WORKON_HOME=\${HOME}/.virtualenvs" >> ${HOME}/.bashrc
echo "export VIRTUALENVWRAPPER_PYTHON=${base_path}/python3" >> ${HOME}/.bashrc
echo "source ${base_path}/virtualenvwrapper.sh" >> ${HOME}/.bashrc

# reload user env.
echo "3. source ~/.bashrc"
source ${HOME}/.bashrc &> /dev/null

# Create a new virtualenv whith python.
echo "4. Create a new virtualenv."
mkvirtualenv --python=python3 ${virtual_env} &> /dev/null

# Upgrade the virtualenv pip version.
echo "5. Upgrade virtualenv pip version."
${HOME}/.virtualenvs/$(workon)/bin/python -m pip install --upgrade pip &> /dev/null

# Add workon cmd to .bashrc file."
echo "6. Add workon cmd to .bashrc."
echo -e "\nworkon ${virtual_env}\n" >> ${HOME}/.bashrc

# Show result.
echo -e "\nComplate the virtual environment(`workon`).\n"

#EOF
