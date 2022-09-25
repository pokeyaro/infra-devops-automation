#!/bin/bash

##########################################################################
#     Install the latest version of the python environment (any user)    #
##########################################################################


# Installation path.
INSTALL_DIR="${HOME}/.python3"


# Download the latest secure version of Python.
echo "01. Download the Python source."
VERSION=`curl --silent https://www.python.org/downloads/source/ | grep -i "Latest Python 3 Release - Python 3.*" | sed 's/^.*Python //; s/<\/a>.*$//'`
TARFILE="Python-${VERSION}.tar.xz"
wget -c "https://www.python.org/ftp/python/${VERSION}/${TARFILE}" --tries=10 --quiet --no-verbose -O /tmp/${TARFILE}


# Unzip the tarfile.
echo "02. Unzip the Python tarball."
if [[ -s /tmp/${TARFILE} ]]; then
    tar -xf /tmp/${TARFILE} -C /tmp
else
    echo -e "\nPython [${TARFILE}] download failed.\n"
    exit 99
fi


# Install dependent packages.
echo "03. Install root dependent PKGs."
DEPEND_PKGS="gcc gcc-c++ glibc make zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel kernel-devel libffi-devel"
for pkg in ${DEPEND_PKGS}
do
    if [[ `sudo rpm -qa ${pkg} | wc -l` -eq 0 ]]; then
        sudo yum -y install ${pkg} &> /dev/null &
    fi
done
wait


# Source code compilation and installation.
echo "04. Install Python ${VERSION} Env."
ls -d /tmp/Python-${VERSION} &> /dev/null && cd /tmp/Python-${VERSION}
echo "    a> Set the prefix directory."
./configure prefix=${INSTALL_DIR} --with-openssl=/usr/local/openssl

echo "    b> Make compile check."
make

echo "    c> Make install."
make install


# Set command alias.
echo "05. Update .bashrc configuration file."
echo "alias python='\${HOME}/.python3/bin/python3'" >> ${HOME}/.bashrc
echo "alias pip='\${HOME}/.python3/bin/pip3'" >> ${HOME}/.bashrc


# Remove temp file.
echo "06. Unlink installation file."
cd /tmp && rm -rf Python*


# [fixed] pip is configured with locations that require TLS/SSL
mkdir -p ${HOME}/.pip
cat > ${HOME}/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com
EOF


# Install wheel module
{INSTALL_DIR}/bin/pip3 install wheel &> /dev/null
echo "All Done!"


#EOF
