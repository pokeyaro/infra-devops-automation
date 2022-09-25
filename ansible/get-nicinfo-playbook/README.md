## ansible-playbook-nicinfo
> Linux script for obtaining and collecting NIC information.

### How to use
```bash
# 1.修改Inventory列表
vim ./hosts

# 2.检测Hosts的连通性
ansible -i ./hosts all -m ping -f 100 | grep -i "success" | wc -l

# 3.批量下发配置
sh ./run.sh

# 4.查看回传结果
cat ./result.csv
```

### Core functions
- 在`Client`端通过`lspci`命令查看网卡的信息，利用`Ansible`剧本统计并汇集，最终在`Server`端显示结果
```shell
[root@physical-server ~] # apt-get install pciutils

[root@physical-server ~] # lspci | grep "Ethernet"
04:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe
04:00.1 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe
3b:00.0 Ethernet controller: Intel Corporation Ethernet Controller XL710 for 40GbE QSFP+ (rev 02)
3b:00.1 Ethernet controller: Intel Corporation Ethernet Controller XL710 for 40GbE QSFP+ (rev 02)
af:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)
af:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 02)

[root@physical-server  ~] # lspci | grep "Ethernet" | awk '{if($0~/10GbE SFP+/){i++} else if($0~/40GbE QSFP+/){j++} else {x++}} END{print "[Fiber-Port]\n10G: "i, "\n40G: " j, "\n[Electric-Port]\n1G: "x}' | column -t
[Fiber-Port]
10G:             2
40G:             2
[Electric-Port]
1G:              2
```

### Playbook display
```shell

PLAY [The playbook for version 2.10.8 ansible is running.] ******************************************************

TASK [Install the command 'lspci'] ******************************************************************************
ok: [10.50.11.2]

TASK [Push the script file] *************************************************************************************
changed: [10.50.11.2]

TASK [Run the script file] **************************************************************************************

TASK [Pull the result back to the local] ************************************************************************
changed: [10.50.11.2]

TASK [Clean up the temporary files] *****************************************************************************
changed: [10.50.11.2] => (item=script.sh)
changed: [10.50.11.2] => (item=nic_info.txt)

TASK [Save as csv file.] ****************************************************************************************
changed: [10.50.11.2]

PLAY RECAP ******************************************************************************************************
10.50.11.2                : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
