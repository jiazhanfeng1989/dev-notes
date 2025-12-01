---
id: srekil65jvjy632gi69fayo
title: Vscode
desc: ''
updated: 1764664576277
created: 1748573802536
---

# Description
Common VSCode configurations and extensions to improve development efficiency.

# vscode Useful Extensions
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [Atlassian: Jira and Bitbucket](https://marketplace.visualstudio.com/items?itemName=Atlassian.atlascode)
- [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)
- [CMake Language Support](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
- [Clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [GitHub Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
- [OpenAPI Swagger Editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi)
- [OpenAPI Designer](https://marketplace.visualstudio.com/items?itemName=philosowaffle.openapi-designer)
- [Code Statistics](https://marketplace.visualstudio.com/items?itemName=caixw.statistic)
- [PlantUML](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [Git Commit Plugin](https://marketplace.visualstudio.com/items?itemName=redjue.git-commit-plugin)
- [JSON Viewer](https://marketplace.visualstudio.com/items?itemName=ccimage.jsonviewer)
- [Dendron Note](https://marketplace.visualstudio.com/items?itemName=dendron.dendron)
- [Go Language](https://marketplace.visualstudio.com/items?itemName=golang.Go)
- [HTML Formatter](https://marketplace.visualstudio.com/items?itemName=mohd-akram.vscode-html-formatter)
- [Groovy Lint](https://marketplace.visualstudio.com/items?itemName=NicolasVuillamy.vscode-groovy-lint)
- [Browser Bookmark](https://marketplace.visualstudio.com/items?itemName=jackiotyu.browser-bookmark)
- [Python Language](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
- [Python Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)
- [Gnuplot](https://marketplace.visualstudio.com/items?itemName=fizzybreezy.gnuplot)
- [GeoTools](https://marketplace.visualstudio.com/items?itemName=SmartMonkey.geotools)
- [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer&WT.mc_id=academic-77807-sagibbon)
- [Markdown Mermaid](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
- [Mermaid Markdown Syntax Highlighting](https://marketplace.visualstudio.com/items?itemName=bpruitt-goddard.mermaid-markdown-syntax-highlighting)

# vscode useful search 
- [vscode search](https://code.visualstudio.com/docs/editor/codebasics#_search-across-files)
- [using regex in vscode for powerful searching](https://keyholesoftware.com/using-regex-in-vscode-for-powerful-searching/?utm_source=chatgpt.com)

## VSCode shortcuts
```
open command palette:                     Command (⌘) + Shift (⇧) + P
open terminal:                            Ctrl (⌃) + `
open file:                                Command (⌘) + P
open next editor:                         Command (⌘) + Option (⌥)  +  <- or ->
move editor to next group:                Command (⌘) +  ⌃ +  <- or ->
open new file:                            Command (⌘) + N
go to line:                               ⌃  + g
close tab:                                Command (⌘) + W
toggle terminal:                          Command (⌘) + J
open side bar:                            Command (⌘) + B
hide secondary sidebar:                   Command (⌘) + Shift (⇧) + B
open settings:                            Command (⌘) + ,
go back to previous edit location:        Ctrl (⌃) + -
go forward to next edit location:         Ctrl (⌃) + Shift (⇧) + -
selects the word at the cursor            Command (⌘) + D
```

# vscode regular search expression
```
// Match /api/example and keyword in any order
^(?=.*/api/example)(?=.*keyword)

// Match keywordA and keywordB together and match order
keywordA.*keywordB

// Match keywordA or keywordB
keywordA|keywordB

// Json match keywordA:number
"keywordA"\s*:\s*\d+
 
// Lines NOT containing 'keyword'
^(?!.*keyword).*$

// Duplicate words (e.g., 'the the')
\b(\w+)\s+\1\b

// Match camelCase identifiers
\b[a-z]+(?:[A-Z][a-z0-9]+)+\b

// Match PascalCase identifiers
\b(?:[A-Z][a-z0-9]+){2,}\b

// Match snake_case identifiers
\b[a-z]+(?:_[a-z0-9]+)+\b

// Match IPv4 address
\b(?:(?:25[0-5]|2[0-4]\d|1?\d?\d)\.){3}(?:25[0-5]|2[0-4]\d|1?\d?\d)\b

// Match URL (http/https)
https?://\S+

// Match ISO date YYYY-MM-DD
\b\d{4}-\d{2}-\d{2}\b

// Match semantic version x.y.z
\b\d+\.\d+\.\d+\b

// Across lines: 'foo' ... 'bar' (non-greedy)
foo[\s\S]*?bar
```