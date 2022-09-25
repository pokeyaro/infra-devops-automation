## Install Python Interpreter

> Specify the version to install the python3.x environment (for CentOS7).\
> Please edit the config.ini file to enter the expected python major version.


### 运行结果

- 安装 Python 解释器
```shell
# 1.Define download version
[root@localhost ~]# cat config.ini 
# python major version
PY_MAJOR_VER=3.9

# 2. Install
[root@localhost ~]# sh ./installer.sh
01. Download the Python source.
02. Unzip the Python tarball.
03. Install root dependent PKGs.
04. Install Python 3.9.13 Env.
    a> Set the prefix directory.
    b> Make compile check.
    c> Make install.
05. Soft link for bin file.
06. Upgrade pip version.
07. Unlink installation file.

# 3. Check path
[root@localhost ~]# ll /usr/bin/python3 /usr/bin/pip3
lrwxrwxrwx. 1 root root 33 Jul  4 01:56 /usr/bin/pip3 -> /usr/local/sdk/python3/bin/pip3.9
lrwxrwxrwx. 1 root root 36 Jul  4 01:56 /usr/bin/python3 -> /usr/local/sdk/python3/bin/python3.9
```

- 安装 Python 虚拟环境
```shell
[root@localhost ~]# sh ./tools/install_venv.sh
1. Install virtualenvwrapper module.
2. Add virtual info to .bashrc file.
3. source ~/.bashrc
4. Create a new virtualenv.
5. Upgrade virtualenv pip version.
6. Add workon cmd to .bashrc.

Complate the virtual environment(venv).

[root@localhost ~]# source ~/.bashrc
(venv) [root@localhost ~]# workon
venv
```
