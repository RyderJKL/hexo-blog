# vscode

## 文件，符号，代码跳转

### 文件跳转

`Cmd+Tab`在当前打开的文件中切换
`Cmd+P`搜索当前工程下的文件

### 行跳转

`Ctrl+G`输入目标行

### 符号(Symbols)跳转

`cmd+shift+O`工具栏输入框里将会自动输入`@`，此时会列出当前文件中的所有符号。如果输入紧接再输入一个`:`，则会将所有符号进行分类。

> JavaScript 中的小技巧：如果同时打开了多个`.js`文件，可以使用`Cmd+T`搜索这个文件中的符号。

### 定义(Definition)和实现(implementation)跳转


## 0x00 键盘映射

```json
// 将键绑定放入此文件中以覆盖默认值
[
    {
        "key": "shift+cmd+l",
        "command": "editor.action.insertCursorAtEndOfEachLineSelected",
        "when": "editorTextFocus"
    },
    {
        "key": "cmd+j",
        "command": "editor.action.joinLines",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+j",
        "command": "-editor.action.joinLines",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "cmd+r",
        "command": "workbench.action.replaceInFiles",
        "when": "!editorFocus"
    },
    {
        "key": "shift+cmd+h",
        "command": "-workbench.action.replaceInFiles",
        "when": "!editorFocus"
    },
    {
        "key": "shift+cmd+r",
        "command": "workbench.action.gotoSymbol"
    },
    {
        "key": "cmd+r",
        "command": "-workbench.action.gotoSymbol"
    },
    {
        "key": "cmd+d",
        "//": "快速选择下一个，等同于 sublime: cmd + d",
        "command": "editor.action.addSelectionToNextFindMatch",
    },
    {
        "key": "shift+cmd+k",
        "command": "editor.action.deleteLines"
    },
    {
        "key": "shift+cmd+d",
        "//": "快速选择下一个，等同于 sublime: cmd + d",
        "command": "extension.vim_cmd+d",
        "when": "editorTextFocus && vim.active && vim.use<D-d> && !inDebugRepl"
    },
    {
        "key": "cmd+d",
        "//": "快速选择",
        "command": "-extension.vim_cmd+d",
        "when": "editorTextFocus && vim.active && vim.use<D-d> && !inDebugRepl"
    },
    {
        "key": "cmd+k cmd+s",
        "//": "打开键盘绑定",
        "command": "workbench.action.openGlobalKeybindings"
    },
    {
        "key": "cmd+k e",
        "command": "workbench.files.action.focusOpenEditorsView"
    },
    {
        "key": "alt+cmd+/",
        "command": "editor.action.blockComment",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "shift+alt+a",
        "command": "-editor.action.blockComment",
        "when": "editorTextFocus && !editorReadonly"
    }
]
```

## 其他快捷键

* `cmd + shift + c`: 在终端中打开当前目录


