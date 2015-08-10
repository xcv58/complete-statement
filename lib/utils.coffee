module.exports =
  python: (selection) ->
    if @needPythonBlock selection then @insertPythonBlock selection else @insertPythonEndChar selection

  java: (selection) ->
    if @needJavaBlock selection then @insertCStyleBlock selection else @insertCStyleEndChar selection

  unsupport: (selection) -> @insert selection, (selection) => @insertNewLine selection

  needPythonBlock: (selection) -> (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch', 'def', 'elif']

  needCStyleBlock: (selection) -> (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch']

  needJavaBlock: (selection) ->
    return true if (@firstWord selection) in ['if', 'class', 'while', 'for', 'else', 'switch']
    (@lineContent selection)?.match(/(public|private).*(\(.*\)|class)/)

  insert: (selection, fn) ->
    @removeTrailingWhitespace selection
    fn selection

  insertPythonEndChar: (selection) -> @insert selection, (selection) => @insertNewLine selection

  insertCStyleEndChar: (selection) -> @insert selection, (selection) => @insertNewLine selection, (@lastChar selection), ';'

  insertPythonBlock: (selection) -> @insert selection, (selection) => @insertNewLine selection, (@lastChar selection), ':'

  insertCStyleBlock: (selection) ->
    @insert selection, (selection) =>
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

  lineContent: (selection) ->
    selection.cursor.moveToBeginningOfLine()
    selection.selectToEndOfLine()
    selection.getText()

  firstWord: (selection) -> (@lineContent selection)?.match(/\w+/)?[0]

  lastChar: (selection) -> (@lineContent selection).split('').pop()

  insertNewLine: (selection, lastChar = '', target = '') ->
    target = '' if lastChar is target or not lastChar
    @insertTextAtEndOfLine selection, "#{target}\n "

  insertTextAtEndOfLine: (selection, text) ->
    selection.cursor.moveToEndOfLine()
    selection.insertText text, select: true
    selection.autoIndentSelectedRows()
    selection.cursor.moveToEndOfLine()
