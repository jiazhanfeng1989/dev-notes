---
id: vluw66mcntnebm2fdvfkiay
title: Tcpdump
desc: ''
updated: 1789955445312
created: 1789436788077
---

# Description
Tcpdump is a command-line packet analyzer that can capture and display network traffic. It is a powerful tool for network troubleshooting and security analysis.

[Tcpdump Documentation](https://www.tcpdump.org/manpages/tcpdump.1.html)

# Usage
```bash
# Capture traffic on port 80
tcpdump -i eth0 -nn tcp port 80 -s 0 -w capture.pcap

# Read captured traffic
tcpdump -nn -r capture.pcap



# Capture traffic on specific host
tcpdump -i eth0 -nn host 192.168.1.10
tcpdump -i eth0 -nn src host 192.168.1.10
tcpdump -i eth0 -nn dst host 192.168.1.10


# Capture traffic on specific port
tcpdump -i eth0 -nn port 80
tcpdump -i eth0 -nn src port 80
tcpdump -i eth0 -nn dst port 80

# Capture traffic on specific host and port
tcpdump -i eth0 -nn 'tcp and host 192.168.1.10 and port 443'
tcpdump -i eth0 -nn 'host 192.168.1.10 and (port 80 or port 443)'
tcpdump -i eth0 -nn -s 0 -w capture.pcap 'host 10.0.0.5 or port 53'

# -B buffer size
tcpdump -i eth0 -nn -s 0 -B 40960 -w capture.pcap 'host 192.168.1.100'

# Capture DNS traffic
tcpdump -i eth0 -nn 'udp port 53'

# Capture HTTP traffic, -A means print the payload in ASCII format
tcpdump -i eth0 -nn -A 'tcp port 80'

# All SYN packets (including SYN-ACK)
tcpdump -i eth0 -nn 'tcp[tcpflags] & tcp-syn != 0'

# Pure SYN only (no ACK) — connection initiators
tcpdump -i eth0 -nn 'tcp[tcpflags] == tcp-syn'

# All RST packets — who reset the connection
tcpdump -i eth0 -nn 'tcp[tcpflags] & tcp-rst != 0'

# All FIN packets — graceful close
tcpdump -i eth0 -nn 'tcp[tcpflags] & tcp-fin != 0'

# Packets with payload data (PSH flag set; skips empty ACKs)
tcpdump -i eth0 -nn 'tcp[tcpflags] & tcp-push != 0'
```
# Output Format

```text
10:00:01.123456 IP 192.168.1.10.53000 > 10.0.0.5.80: Flags [S], seq 100, win 64240, length 0
```

## Line fields

| Field | Example | Meaning |
| ----- | ------- | ------- |
| Timestamp | `10:00:01.123456` | Packet capture time |
| Protocol | `IP` | IPv4 packet |
| Source | `192.168.1.10.53000` | Source IP and port |
| Direction | `>` | Traffic direction (source to destination) |
| Destination | `10.0.0.5.80` | Destination IP and port |
| TCP flags | `Flags [S]` | TCP flag set; `[S]` = SYN |
| Sequence | `seq 100` | TCP sequence number |
| Window | `win 64240` | TCP receive window |
| Payload | `length 0` | TCP payload length in bytes |

## Common TCP flags

| Flag | Meaning |
| ---- | ------- |
| `[S]` | SYN — start connection |
| `[S.]` | SYN + ACK |
| `[.]` | ACK |
| `[P.]` | PSH + ACK — usually carries data |
| `[F.]` | FIN + ACK — graceful close |
| `[R]` | RST — reset connection |

