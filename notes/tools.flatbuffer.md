---
id: km0y7isr2pdcx90z7y2e0p6
title: Flatbuffer
desc: ''
updated: 1770276088550
created: 1768893975072
---

# description
[Flatbuffers](https://google.github.io/flatbuffers/) is an efficient cross platform serialization library.


# Usage
```bash
# print the version
flatc --version

# convert binary to json
flatc -t --raw-binary --strict-json example.fbs -- data.bin
flatc -t --raw-binary --strict-json --root-type ResponseType example.fbs -- data.bin
flatc -t --raw-binary --defaults-json --strict-json --root-type ResponseType example.fbs -- data.bin

# convert json to binary
flatc -b example.fbs data.json

# create golang code file from fbs file
#for golang, not recommend to use --go-namespace because it will override the namespace_go
flatc -g --gen-object-api --go-namespace testapi -o ./api/testapi api/testapi.fbs

##for golang, recommend to add namespace_go to the fbs file, and then generate the code file
namespace_go github.com.yourname.myproject.schema.user;
flatc -g --gen-object-api -o ./output ./example.fbs

# check the schema file
flatc schema.fbs
```