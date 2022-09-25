## 命令行参数解析

> 重点介绍 Shell Script 中 `getopts` 命令行参数解析工具的用法，以 IPv4 解析为脚本示例。


### 运行结果

```shell
[admin@localhost ~]$ chmod u+x ./demo.sh

[admin@localhost ~]$ ./demo.sh

Try './demo.sh -h' for more information.

[admin@localhost ~]$ ./demo.sh -h

Usage: sh ./demo.sh [OPTION]...
Validity tool for detecting IPv4.

Mandatory arguments to short options.
  -i                with an ipv4 address.
  -h                display this help and exit.

For example:
  $ sh ./demo.sh -i 192.168.1.100

[admin@localhost ~]$ ./demo.sh -i 10.0.0.1
```

