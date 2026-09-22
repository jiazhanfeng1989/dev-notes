---
id: wst5kzs4csxbqjw49n5wg0r
title: Tcp
desc: ''
updated: 1789967911931
created: 1753421918946
---
# Description
Some tools to analyze network protocols.

# Tools
- [Wireshark](https://www.wireshark.org/)
- [Fiddler](https://www.telerik.com/fiddler)
- [Charles](https://www.charlesproxy.com/)
- [mitmproxy](https://mitmproxy.org/)
- [postman](https://www.postman.com/)
- [apipost](https://www.apipost.cn/)

## TCP
- [TCP/IP 协议介绍](https://mp.weixin.qq.com/s/v9MynQNYOj4SyxjW3Bg4Jw)

## Wireshark Tutorial
- [Wireshark Changing Column Display](https://unit42.paloaltonetworks.com/unit42-customizing-wireshark-changing-column-display/)
- [Wireshark Decrypting HTTPS Traffic](https://unit42.paloaltonetworks.com/wireshark-tutorial-decrypting-https-traffic/)
- [Wireshark Display Filter Expressions](https://unit42.paloaltonetworks.com/using-wireshark-display-filter-expressions/)
- [Wireshark Identifying Hosts and Users](https://unit42.paloaltonetworks.com/using-wireshark-identifying-hosts-and-users/)
- [Wireshark TLS Dissection](https://wiki.wireshark.org/TLS)
- [Wireshark 抓包实战](https://mp.weixin.qq.com/s/RaH8RsgJugrCzKAAbUMekQ)

# mitmproxy Tutorial
```bash
alias mitmp='mitmproxy --set console_mouse=false'
```

# DNS lookup
```bash
dig +trace example.com A
dig @8.8.8.8 example.com A
```

# 优化TCP性能
```bash
# 1. 调整内核参数
net.ipv4.tcp_syncookies = 1          # 防SYN Flood
net.ipv4.tcp_tw_reuse = 1            # 快速回收TIME_WAIT
net.ipv4.tcp_fin_timeout = 30        # 减少FIN_WAIT2时间
net.ipv4.tcp_max_syn_backlog = 8192  # 增大SYN队列
net.core.somaxconn = 8192            # 增大Accept队列
# 2. 启用BBR拥塞控制（推荐）
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
# 3. 调整缓冲区
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
```

