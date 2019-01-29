---
title: "title"
excerpt: "excerpt"
categories: 
  - Linux
last_modified_at: 2019-01-29T14:39:00+09:00
tags: 
    - Linux
    - CentOS
    - Redhat
    - Bonding
author_profile: true
read_time: true
toc_label: "Network Bonding 구성하기" 
toc_icon: "cog" 
toc: true
toc_sticky: true
---


```
[root@gpu1 ~]# uname -r
3.10.0-693.el7.x86_64
```


```
[root@gpu1 ~]# cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core)
```

```
[root@gpu1 ~]# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root   17G  5.3G   12G  31% /
devtmpfs                 478M     0  478M   0% /dev
tmpfs                    489M     0  489M   0% /dev/shm
tmpfs                    489M  6.7M  482M   2% /run
tmpfs                    489M     0  489M   0% /sys/fs/cgroup
/dev/sda1               1014M  125M  890M  13% /boot
tmpfs                     98M     0   98M   0% /run/user/0
```


```

[root@gpu1 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:            976         134         699           6         142         679
Swap:          2047           0        2047
```


```
cat /proc/cpuinfo | grep processor | wc -l
1
```


KST 
```
[root@gpu1 ~]# ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
[root@gpu1 ~]# date
Tue Jan 29 14:23:06 KST 2019
```


```
[root@gpu1 ~]# hostnamectl set-hostname WAS-TEST
[root@gpu1 ~]# logout
[root@was-test ~]#
```


```
[root@was-test ~]# firewall-cmd --zone=public --add-port=80/tcp --permanent
success
[root@was-test ~]# firewall-cmd --reload
success
```

FTP
```
[root@was-test ~]# yum -y install vsftpd
Complete!
[root@was-test ~]# systemctl enable vsftpd.service
vsftpd.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig vsftpd on
[root@was-test ~]# systemctl start vsftpd
```

방화벽 설치
```
[root@was-test ~]# yum -y install system-config-firewall-tui
```

포트허용
```
[root@was-test ~]# #vi /etc/sysconfig/iptables
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 21 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
```
  ▶ 포트 80 : 아파치
  ▶ 포트 22 : SSH
  ▶ 포트 21 : FTP
  ▶ 포트 3306 : MySql 


firewalld 중지
```
[root@was-test ~]# systemctl mask firewalld
Created symlink from /etc/systemd/system/firewalld.service to /dev/null.

[root@was-test ~]# systemctl stop firewalld
[root@was-test ~]# systemctl status firewalld
● firewalld.service
   Loaded: masked (/dev/null; bad)
   Active: inactive (dead) since Tue 2019-01-29 14:41:46 KST; 2s ago
 Main PID: 782 (code=exited, status=0/SUCCESS)

Jan 29 14:06:11 gpu1 firewalld[782]: WARNING: ICMP type 'reject-route' is not supported by t...pv6.
Jan 29 14:06:11 gpu1 firewalld[782]: WARNING: reject-route: INVALID_ICMPTYPE: No supported I...ime.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: ICMP type 'beyond-scope' is not supported b...v6.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: beyond-scope: INVALID_ICMPTYPE: No supporte...me.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: ICMP type 'failed-policy' is not supported ...v6.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: failed-policy: INVALID_ICMPTYPE: No support...me.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: ICMP type 'reject-route' is not supported b...v6.
Jan 29 14:26:57 was-test firewalld[782]: WARNING: reject-route: INVALID_ICMPTYPE: No supporte...me.
Jan 29 14:41:46 was-test systemd[1]: Stopping firewalld.service...
Jan 29 14:41:46 was-test systemd[1]: Stopped firewalld.service.
Hint: Some lines were ellipsized, use -l to show in full.
```



apache
```
[root@was-test ~]# yum install httpd
```

