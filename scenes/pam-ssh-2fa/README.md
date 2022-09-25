## pam-ssh-2fa

> 构建 PAM（pam_python）模块的环境登录黑盒

- 双因素认证-Demo搭建：2FA（Two-factor authentication）

- 构建环境：
```shell
# centos7 / python2.7 / root下运行
cd pam-ssh-2fa/
sh deploy.sh
```

- 修改2FA密码：
```shell
# 初始密码为 'helloworld'
newpass="xxxxxx"
sed -i "s/helloworld/${newpass}/" /lib64/security/auth-2fa.py
```

- 登录测试：
```shell
[view@localhost ~]$ ssh admin@10.0.0.139
Warning: Permanently added '10.0.0.139' (ED25519) to the list of known hosts.
Authorized uses only. All activity may be monitored and reported.
(admin@10.0.0.139) Password: ******                                    <-- admin账号密码
(admin@10.0.0.139) Enter 2-factor auth: ******                         <-- 2fa默认密码为 'helloworld'
Last login: Fri Jun 17 18:27:10 2022 from 10.0.0.100
Authorized uses only. All activity may be monitored and reported.
[admin@localhost ~]$ 
```
