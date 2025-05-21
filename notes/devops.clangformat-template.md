---
id: 7zha1702rosm03dko2f2u9g
title: Clang Format Template
desc: ''
updated: 1747812422681
created: 1747810907549
---

# Description
clang-format is a tool for formatting codes which is provided by LLVM. It has proven to be one of the best C++ code formatting tools over the world. Many open source projects have regarded clang-format as the official tool for code formatting, and force any code commit to be formatted by it before merge, e.g. MongoDB. Unlike other tools which use own parsers, clang-format uses the Clang tokenizer and supports the same C++ source code as the Clang compiler. This guarantees correct output is produced and offers unique features (e.g. wrapping long lines whether of code, strings, arrays - something which AStyle has no way of doing).

For further information of clang-format, please visit the official [clang-format homepage](https://clang.llvm.org/docs/ClangFormat.html).

For vscode+clang-format config, please visit
[vscode clang format](https://code.visualstudio.com/docs/cpp/cpp-ide#_clangformat)


## clang-format commandline usage
``` text
//format and display your_code.cpp
clang-format -style=file your_code.cpp

//format and replace your_code.cpp
clang-format -i -style=file your_code.cpp 

 //user specific .clang-format format and replace your code
clang-format -i -style=file -assume-filename=/path/to/.clang-format your_code.cpp

//verify clang-format config
clang-format -style=file -dump-config
```
## clang-format style file
clang-format supports some pre-defined coding format styles, e.g. Google, Webkit and etc.

Below is an example of .clang-format.
``` text
Language:        Cpp
# BasedOnStyle:  Google
AccessModifierOffset: -4
AlignAfterOpenBracket: Align
KeepEmptyLinesAtTheStartOfBlocks: false
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignEscapedNewlines: Left
AlignOperands:   true
AlignTrailingComments: true
AllowAllParametersOfDeclarationOnNextLine: false
AllowShortBlocksOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: None
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: true
BinPackArguments: false
BinPackParameters: false
BraceWrapping:  
  AfterClass:      true
  AfterControlStatement: true
  AfterEnum:       true
  AfterFunction:   true
  AfterNamespace:  true
  AfterObjCDeclaration: true
  AfterStruct:     true
  AfterUnion:      true
  AfterExternBlock: true
  BeforeCatch:     true
  BeforeElse:      true
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakBeforeBinaryOperators: None
BreakBeforeBraces: Allman
BreakBeforeInheritanceComma: false
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: true
BreakConstructorInitializers: BeforeComma
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: false
ColumnLimit:     100
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: false
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DerivePointerAlignment: true
DisableFormat:   false
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:  
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IncludeBlocks:   Preserve
IncludeCategories:
  - Regex:           '^<ext/.*\.h>'
    Priority:        2
  - Regex:           '^<.*\.h>'
    Priority:        1
  - Regex:           '^<.*'
    Priority:        2
  - Regex:           '.*'
    Priority:        3
IncludeIsMainRegex: '([-_](test|unittest))?$'
IndentCaseLabels: true
IndentPPDirectives: None
IndentWidth:     4
IndentWrappedFunctionNames: false
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: None
ObjCBlockIndentWidth: 2
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 200
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyExcessCharacter: 1
PenaltyReturnTypeOnItsOwnLine: 600
PointerAlignment: Left
ReflowComments:  true
SortIncludes:    false
SortUsingDeclarations: false
SpaceAfterCStyleCast: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 2
SpacesInAngles:  false
SpacesInContainerLiterals: true
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard:        Cpp11
TabWidth:        4
UseTab:          Never
```