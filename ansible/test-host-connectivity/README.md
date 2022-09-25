## 检测校准主机列表

> 功能：若 Ansible Inventory 列表中存在`UNREACHABLE`主机通讯不可达的条目, 将该行信息进行注释, 确保 Inventory 中条目都可连通。


### 运行结果

```shell
[admin@localhost ~]$ chmod u+x ./check_hosts.sh

[admin@localhost ~]$ ./check_hosts.sh /etc/ansible/hosts
```

### Host对比

- 脚本执行前
```shell
[admin@localhost ~]$ cat /etc/ansible/hosts
[foo]
10.60.0.15  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # foo node-01
10.60.0.16  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # foo node-02

[bar]
10.60.0.17  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # bar node-01
10.60.0.18  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # bar node-02

[admin@localhost ~]$ ansible -i hosts nss -m ping -e "ansible_python_interpreter=/usr/bin/python3"
10.60.0.15 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.60.0.17 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.60.0.18 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.60.0.16 | UNREACHABLE! => {
    "changed": false,
    "msg": "Data could not be sent to remote host \"10.60.0.16\". Make sure this host can be reached over ssh: ssh: connect to host 10.60.0.16 port 22: Connection timed out\r\n",
    "unreachable": true
}
```

- 脚本执行后
```shell
[admin@localhost ~]$ cat /etc/ansible/hosts
[foo]
10.60.0.15  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # foo node-01
# 10.60.0.16  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # foo node-02

[bar]
10.60.0.17  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # bar node-01
10.60.0.18  ansible_ssh_user=root  ansible_ssh_pass=123456  ansible_ssh_port=22    # bar node-02

[admin@localhost ~]$ ansible -i hosts nss -m ping -e "ansible_python_interpreter=/usr/bin/python3"
10.60.0.15 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.60.0.17 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.60.0.18 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
