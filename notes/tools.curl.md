---
id: kponeoars1ghp0o6oa1ht2z
title: Curl
desc: ''
updated: 1749872670856
created: 1747964867488
---

# Description
[curl](https://curl.se/) is a command-line tool for transferring data with URLs. It supports various protocols, including HTTP, HTTPS, FTP, and more. Curl is widely used for testing APIs, downloading files, and automating tasks that involve network communication.


# Common Commands
``` bash
// Download a file
curl -O http://example.com/file.txt

// Download a file with a different name
curl -o newname.txt http://example.com/file.txt

// Post json data
curl -X POST http://example.com/api -H "Content-Type: application/json" -d '{"username":"admin","password":"123456"}'

// Add a header
curl -H "Authorization: Bearer your_token" http://example.com/api

// Header only
curl -I http://example.com

// Detail request and response
curl -v http://example.com

// Use Cookie
curl -b "name=value" http://example.com
// Use Cookie file
curl -b cookies.txt http://example.com

// Use Proxy
curl -x http://proxy.example.com:8080 http://example.com

// ignore SSL certificate
curl -k https://example.com

// Silent mode
curl -s http://example.com

// Silent mode with errors shown
curl -sS http://example.com

curl --cacert ica_web.chain https://example.com
```

# 💡 Tips
``` bash
// Use curl to test the speed of a website
curl -s -w ‘%{time_connect}###%{time_starttransfer}###%{time_total}###%{size_download}###%{speed_download}’ -X GET http://example.com

for i in {1..1000};do curl -4 --location --request GET  'http://example.com'  -o /dev/null -s -w '\n%{time_namelookup}:%{time_connect}:%{time_starttransfer}:%{time_total}\n';done > /tmp/timings.log
awk -F':' '{ sum += $1 } END { if (NR > 0) print sum / NR }' /tmp/timings.log

grep -Po '"cluster_name":".*?"' file.json | sed -E 's/.*:"(.*?)"/\1/'
```