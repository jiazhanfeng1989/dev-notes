---
id: 3rm4baml4gu8ec1eaxwnibh
title: Golangci Lint
desc: ''
updated: 1761535470771
created: 1757993320513
---

# Description
[Golangci-lint](https://golangci-lint.run/) is a linter for Go.

# Install
```bash
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.5.0
```

# Uninstall
```
sudo rm -rf $(go env GOPATH)/bin/golangci-lint
sudo rm -rf $(go env GOPATH)/pkg/mod/github.com/golangci
sudo rm -rf $(go env GOPATH)/pkg/mod/github.com/*/*lint*
```

# Commands
```bash
golangci-lint run
golangci-lint fmt
golangci-lint formatters
golangci-lint linters
golangci-lint fmt -h
golangci-lint run -h
golangci-lint config verify
golangci-lint cache clean
`````
# Integrations with other tools
[Integrations](https://golangci-lint.run/docs/welcome/integrations/)

# Template
[.golangci.yaml](./assets/.golangci.yaml)
