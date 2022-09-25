#!/bin/bash
#
# Function: Centos7.x virtual machine installation and configuration python environment.
#
# Tips: It is not recommended to use the latest python version, there is a problem that
# the default version of the dependency package openssl is lower.
#

# Check the number of positional arguments.
if [[ ${#} -eq 1 ]]; then
    # major="3.9"
    major="${1}"
else
    echo -e "\nPlease enter the python major version number you want to download, such as (3.9)\n"
    exit 99
fi

# Check the current system release.
cat /etc/os-release | grep -iq "centos.*7"
if [[ $? -ne 0 ]]; then
    echo -e "\nThis script only supports centos 7.\n"
    exit 99
fi

# Check the current executing user.
if [[ `whoami` != "root" ]]; then
    echo -e "\nInstall the Python environment via 'root' user.\n"
    exit 99
fi

# Check the basic commands.
if [[ `rpm -qa curl wget tar | wc -l` -lt 3 ]]; then
    echo -e "\nPlease execute the command first: 'yum install -y curl wget tar'\n"
    exit 99
fi

# Check the version of the python interpreter.
if [[ $(echo "$(python -V 2>&1 | awk '{print $NF}' | sed 's/\.[0-9]$//') > 3.6" | bc) -eq 1 ]]; then
    echo -e "\nThe python default interpreter version has met minimum expectations.\n"
    exit 0
else
    which python3 &> /dev/null
    if [[ $? -eq 0 ]]; then
        if [[ $(echo "$(python3 -V 2>&1 | awk '{print $NF}' | sed 's/3.//') > 6.0" | bc) -eq 1 ]]; then
            echo -e "\nThe python3 interpreter version has met minimum expectations.\n"
            exit 0
        fi
    fi
fi


################################################
#        Install the python environment        #
################################################

# Download the latest secure version of Python.
echo "01. Download the Python source."
version=`curl --silent https://www.python.org/downloads/source/ | awk -F '/' '{if ($6~/3\./) print $6}' | egrep -v "2.*|3.[01]|3.[0-6]." | sort -u | sort -rn -t '.' -k 2 | grep "${major}" | sort -rn -t '.' -k 3 | head -1`
tarfile="Python-${version}.tar.xz"
wget -c "https://www.python.org/ftp/python/${version}/${tarfile}" --tries=10 --quiet --no-verbose -O /tmp/${tarfile}


# Unzip the tarfile.
echo "02. Unzip the Python tarball."
if [[ -s /tmp/${tarfile} ]]; then
    tar -xf /tmp/${tarfile} -C /tmp
else
    echo -e "\nPython [${tarfile}] download failed.\n"
    exit 99
fi


# Install dependent packages.
echo "03. Install root dependent PKGs."
depend_pkgs="gcc gcc-c++ glibc make zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel kernel-devel libffi-devel"
for pkg in ${depend_pkgs}
do
    if [[ `rpm -qa ${pkg} | wc -l` -eq 0 ]]; then
        yum -y install ${pkg} &> /dev/null &
    fi
done
wait


# Source code compilation and installation.
echo "04. Install Python ${version} Env."
install_dir="/usr/local/sdk/python3"
ls -d /tmp/Python-${version} &> /dev/null && cd /tmp/Python-${version}
echo "    a> Set the prefix directory."
./configure prefix=${install_dir} &> /dev/null

echo "    b> Make compile check."
make --silent &> /dev/null

echo "    c> Make install."
make install --silent &> /dev/null


# Soft link for bin executable file.
echo "05. Soft link for bin file."
rm -f /usr/bin/python3 &> /dev/null
rm -f /usr/bin/pip3 &> /dev/null
ln -s ${install_dir}/bin/python${major} /usr/bin/python3 &> /dev/null
ln -s ${install_dir}/bin/pip${major} /usr/bin/pip3 &> /dev/null


# Upgrade the pip version.
echo "06. Upgrade pip version."
python3 -m pip install --upgrade pip &> /dev/null
pip3 install wheel


# Remove temp file.
echo "07. Unlink installation file."
cd /tmp && rm -rf Python*


#EOF
