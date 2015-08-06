{CompositeDisposable} = require 'atom'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': => @complete()

  complete: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.moveToFirstCharacterOfLine()
    @processSelection editor, selection for selection in editor.getSelections()

  processSelection: (editor, selection) ->
    @removeTrailingWhitespace selection
    if @needBlock editor, selection
      @insertBlock editor, selection
    else
      @insertEndChar editor, selection

  needBlock: (editor, selection) ->
    selection.selectToFirstCharacterOfLine()
    selection.clear()
    selection.selectWord()
    word = selection.getText()
    selection.selectToEndOfLine()
    selection.clear()
    word in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  insertBlock: (editor, selection) ->
    if editor.getGrammar().name == 'Python'
      @insertPythonBlock editor, selection
    else
      @insertCStyleBlock editor, selection

  insertEndChar: (editor, selection) ->
    selection.selectToEndOfLine()
    selection.clear()
    selection.selectLeft()
    lastChar = selection.getText()
    selection.insertText lastChar
    if editor.getGrammar().name != 'Python' and lastChar != ';'
      selection.insertText ';'
    selection.insertText '\n ', select: true
    selection.autoIndentSelectedRows()
    selection.selectToEndOfLine()
    selection.clear()

  insertPythonBlock: (editor, selection) ->
    selection.selectToEndOfLine()
    selection.clear()
    selection.selectLeft()
    endWord = selection.getText()
    text = endWord
    text += ':' if endWord != ':'
    selection.insertText text + '\n ', select: true
    selection.autoIndentSelectedRows()
    selection.selectDown(1)
    selection.selectToEndOfLine()

  insertCStyleBlock: (editor, selection) ->
    selection.insertText ' {\n\n}', select: true
    selection.autoIndentSelectedRows()
    selection.clear()
    selection.selectUp(1)
    selection.selectToEndOfLine()
    selection.clear()

  removeTrailingWhitespace: (selection) ->
    selection.selectToBeginningOfLine()
    selection.clear()
    selection.selectToEndOfLine()
    selection.insertText selection.getText().replace(/[ \t]+$/, '')

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
