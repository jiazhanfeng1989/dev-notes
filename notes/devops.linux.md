---
id: xlunmb0ghxcktv2dvlc87em
title: Linux
desc: ''
updated: 1765439529284
created: 1764840959429
---


# Linux Commands
```bash
eval "$(ssh-agent -s)" # start the ssh agent and print the agent's socket path
pgrep ssh-agent # list all ssh-agent processes
pgrep ssh-agent | xargs kill -9 # kill all ssh-agent processes
sha256sum <file> # calculate the SHA-256 hash of a file

# macOS（BSD date）
date -r 1479524170
date -r 1479524170 "+%Y-%m-%d %H:%M:%S %z (%Z)" # convert timestamp to human readable format
date -r $(date -j -u -f "%Y-%m-%d %H:%M:%S" "2025-12-11 07:46:15" +%s) +"%Y-%m-%d %H:%M:%S %Z" # convert timestamp to human readable format


# Linux（GNU date）
date -d @1479524170
date -d @1479524170 "+%Y-%m-%d %H:%M:%S %z (%Z)" # convert timestamp to human readable format


sort <file> | uniq -c | sort -nr # count the number of occurrences of each line and sort by count in descending order


grep --color=always "key1" <file> | grep --color=always "key2" # filter lines containing both key1 and key2
grep -E '(?=.*class)(?=.*virtual)' <file> # filter lines containing both class and virtual
grep -e "key1" -e "key2" <file> # filter lines containing either key1 or key2


sed -i 's/sleep/#sleep/g' <file> # replace sleep with #sleep in <file>
sed -i '3,$s/^/#/g' <file> # comment out the lines from the 3rd line to the end of the file
sed -i '/LICENSE_URL/d' <file> # delete the line containing LICENSE_URL
sed '/^$/d' <file> # delete empty lines
sed 's/^\s*//g' <file> # remove leading whitespace
sed -n '/11:07 18:29:20/,/11:07 18:31:11/p' <file> # print the lines between 11:07 18:29:20 and 11:07 18:31:11 in <file>


awk -F":" '{for(i=1;i<=NF;i++) print $i}' <file> # print the fields of the file separated by :


lsof -p 66631 # list all files opened by the process with PID 66631
lsof -nP -i :5000 # list all processes using port 5000
lsof /filepath/file.txt # list all processes using /filepath/file.txt
lsof -i -P -n | grep LISTEN # list all processes listening on ports

find . -type f -user root -exec chown weber:weber {} \; # change the owner of the files to weber:weber
find . -type f -user root -exec chown weber {} +; # change the owner of the files to weber:weber
find . -type f -name "*.swp" -delete # delete the swap files
find . -maxdepth 1 -type f # find all files in the current directory
find ./ -type d -empty # find all empty directories in the current directory
find ./ -type f -empty # find all empty files in the current directory


ps -ww -o pid,ppid,user,lstart,command -p <PID> # print the process information of the process with PID <PID>
ps eww -o command= -p <PID> # print the command and arguments and environment variables of the process with PID <PID>
```