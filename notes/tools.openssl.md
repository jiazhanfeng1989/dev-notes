---
id: t72b28xbran0edcp6di00s1
title: Openssl
desc: ''
updated: 1749873367700
created: 1749868778922
---

# Description
usage of openssl command line tool
[OpenSSL](https://www.openssl.org/) is a widely used cryptographic library that provides tools for secure communication over networks. It supports various cryptographic algorithms and protocols, including SSL/TLS.
``` bash
# Generate a private key
openssl genrsa -out private.pem 2048

# Generate a self-signed certificate
openssl req -new -x509 -key private.pem -out cert.pem -days 365 -subj "/CN=example.com"

# Generate a certificate signing request (CSR)
openssl req -new -key private.pem -out request.csr -subj "/CN=example.com"

# Sign a CSR with a CA certificate
openssl x509 -req -in request.csr -CA ca.pem -CAkey ca_key.pem -CAcreateserial -out signed_cert.pem -days 365

# Convert PEM to DER format
openssl x509 -in cert.pem -outform DER -out cert.der

# Convert DER to PEM format
openssl x509 -in cert.der -inform DER -out cert.pem -outform PEM

# Verify a certificate
openssl verify -CAfile ca.pem -verbose cert.pem

# Show the details of a certificate
openssl x509 -in cert.pem -text -noout

# Show the details of a private key
openssl rsa -in private.pem -text -noout

# Show the details of a CSR
openssl req -in request.csr -text -noout

# Show the details of a CA certificate
openssl x509 -in ca.pem -text -noout

# Create a certificate chain file
cat cert.pem ca.pem > ca_web.chain

# Connect to a secure server and display certificate details
# Used for verifying SSL/TLS connections and examining server certificates
openssl s_client -showcerts -connect example.com:443

# Convert certificate chain to PKCS#7 format and display detailed certificate information
# Useful for inspecting all certificates in a chain (leaf, intermediate, root)
openssl crl2pkcs7 -nocrl -certfile ca_web.chain | openssl pkcs7 -print_certs -text -noout
```