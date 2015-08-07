module.exports =
  insertPythonBlock: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection, (@lastChar selection), ':'

  insertCStyleBlock: (selection) ->
    @removeTrailingWhitespace selection
    lastChar = @lastChar selection
    if lastChar is '{'
      @insertNewLine selection
    else
      selection.cursor.moveToEndOfLine()
      selection.insertText(" {\n\n}", {select: true, autoIndent: true, autoIndentNewline: true, normalizeLineEndings: true})
      selection.autoIndentSelectedRows()
      selection.cursor.moveUp(1)
      selection.cursor.moveToEndOfScreenLine()

  removeTrailingWhitespace: (selection) ->
    selection.selectToBeginningOfLine()
    selection.clear()
    selection.selectToEndOfLine()
    selection.insertText selection.getText().replace(/[ \t]+$/, '')

  needPythonBlock: (selection) ->
    (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  needCStyleBlock: (selection) ->
    (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  firstWord: (selection) ->
    selection.cursor.moveToBeginningOfLine()
    selection.selectToEndOfLine()
    selection.getText().match(/\w+/)?[0]

  lastChar: (selection) ->
    selection.cursor.moveToEndOfLine()
    selection.selectLeft()
    char = selection.getText()
    selection.cursor.moveRight(1)
    char

  insertNewLine: (selection, lastChar = '', target = '') ->
    selection.cursor.moveToEndOfLine()
    console.log 'last:', lastChar
    target = '' if lastChar in [target, '\n']
    selection.insertText "#{target}\n ", select: true
    selection.autoIndentSelectedRows()
    selection.cursor.moveToEndOfLine()

  insertPythonEndChar: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection

  insertCStyleEndChar: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection, (@lastChar selection), ';'
