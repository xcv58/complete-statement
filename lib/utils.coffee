module.exports =
  needPythonBlock: (selection) ->
    (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  needCStyleBlock: (selection) ->
    (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  needNullBlock: (selection) ->
    false

  insertPythonEndChar: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection

  insertCStyleEndChar: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection, (@lastChar selection), ';'

  insertNullEndChar: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection

  insertPythonBlock: (selection) ->
    @removeTrailingWhitespace selection
    @insertNewLine selection, (@lastChar selection), ':'

  insertCStyleBlock: (selection) ->
    @removeTrailingWhitespace selection
    lastChar = @lastChar selection
    if lastChar is '{'
      @insertNewLine selection
    else
      @insertTextAtEndOfLine selection, " {\n\n}"
      selection.cursor.moveUp(1)
      selection.cursor.moveToEndOfLine()

  removeTrailingWhitespace: (selection) ->
    selection.cursor.moveToBeginningOfLine()
    selection.selectToEndOfLine()
    selection.insertText selection.getText().replace(/[ \t]+$/, '')

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
    target = '' if lastChar in [target, '\n']
    @insertTextAtEndOfLine selection, "#{target}\n "

  insertTextAtEndOfLine: (selection, text) ->
    selection.cursor.moveToEndOfLine()
    selection.insertText text, select: true
    selection.autoIndentSelectedRows()
    selection.cursor.moveToEndOfLine()
