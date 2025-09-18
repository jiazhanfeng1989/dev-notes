---
id: ef887ao8ygjcu4sbmehvs8j
title: Best Practices
desc: ''
updated: 1760664503261
created: 1757038742246
---

# Description
Some best practices for programming and Golang.

# Golang Development Configuration
```bash
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOPRIVATE=bitbucket.***.com
go env -w GONOSUMDB=bitbucket.***.com
go env -w GONOPROXY=bitbucket.***.com
git config --global url."ssh://git@bitbucket.***.com".insteadOf "https://bitbucket.***.com/scm/"
```
# Golang Command Line
```bash
go mod init github.com/mypna/test # Initialize a new module
go mod download # Download the dependencies
go mod tidy # Tidy the module

go build ./... # Build the module
go test ./... # Test the module
go clean -modcache # Clean the module
go clean -testcache # Clean the test cache
go clean -i # Clean to remove the corresponding installed archive or binary
go clean -n #clean to print the remove commands it would execute, but not run them.
go clean -cache #clean to remove the entire go build cache.
go clean -buildcache # Clean build cache
go version -m ~/go/bin/ # Print Go version and module versions used to build executables in a directory.

go get -u github.com/mypna/test@v1.0.0 # Update a dependency
go get -tool golang.org/x/tools/cmd/goimports # Install goimports
go tool goimports --help # Print goimports help
go tool -n goimports # Print out the path to the tool on the filesytem
```

# Documents
- [Effective Go](https://go.dev/doc/effective_go)
- [Go References](https://go.dev/doc/#references)
- [Go Modules Details](https://go.dev/ref/mod)
- [Using Go Modules](https://go.dev/blog/using-go-modules)
- [Go Command](https://pkg.go.dev/cmd/go)
- [Go Configuration for Downloading Non Public Code](https://pkg.go.dev/cmd/go#hdr-Configuration_for_downloading_non_public_code)
- [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
- [Go Slog](https://go.dev/blog/slog)
- [Go GC Guide](https://tip.golang.org/doc/gc-guide)
- [Go SwissTable](https://go.dev/blog/swisstable)
- [Go 101](https://go101.org/article/101.html)
- [Go Proverbs](https://go-proverbs.github.io)
- [Go Profiling with pprof](https://pkg.go.dev/runtime/pprof)
- [Go Style Guide](https://google.github.io/styleguide/go/decisions)
- [Go Test Comments](https://go.dev/wiki/TestComments)
- [Go Testable Examples](https://go.dev/blog/examples)
- [Go Table Driven Tests](https://go.dev/wiki/TableDrivenTests)
- [Golangci-lint Documentation](https://golangci-lint.run/docs/)
- [Context and Structs](https://go.dev/blog/context-and-structs)
- [Context Induced Performance Bottleneck in Go](https://gabnotes.org/posts/context-induced-performance-bottleneck-in-go)
- [Go Tools Command](https://blog.howardjohn.info/posts/go-tools-command/)
- [Go Compiler Directives](https://zchee.github.io/golang-wiki/Comments/)
- [uber-go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
- [Go Advice](https://github.com/cristaloleg/go-advice)
- [Go Serialization Benchmarks](https://github.com/alecthomas/go_serialization_benchmarks)
- [Debugging performance issues in Go programs](https://go.dev/wiki/Performance)
- [Go Code Refactoring the 23x Performance Hunt](https://medium.com/@val_deleplace/go-code-refactoring-the-23x-performance-hunt-156746b522f7)

# Some Golang not compatible changes
- [Loop variable preview](https://go.dev/blog/loopvar-preview)
- [Working with Errors in Go 1.13](https://go.dev/blog/go1.13-errors)
