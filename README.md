# Embedder
An Xcode source editor extension for embedding lines of code

## Example
```
Text("embed me")
```
↑ becomes ↓
```
<#closure#> {
    Text("embed me")
}
```

## Introduction
Even though Mac OS Catalina and Xcode 11 provide a context menu to embed Views into HStacks and VStacks. This extension provides a more flexible option that is available at your finger tips. 

This shortcut works with cursor positions and single to multi-line selections.

I recommend creating a keyboard shortcut. I use `shift + cmd + {`

## Goals
- [ ] Add test cases.
- [ ] Handle more cursor position cases like when next to brackets instead of text.
- [ ] Determine possiblity of adding more versions with specific enclosing tags.