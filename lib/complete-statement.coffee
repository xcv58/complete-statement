{CompositeDisposable} = require 'atom'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': => @complete()

  complete: ->
    editor = atom.workspace.getActiveTextEditor()
    grammar = editor.getGrammar()
    editor.moveToFirstCharacterOfLine()
    @processSelection editor, selection for selection in editor.getSelections()


  processSelection: (grammar, selection) ->
    if @needBlock grammar, selection
      @insertBlock grammar, selection
    else
      @insertEndChar grammar, selection

  needBlock: (grammar, selection, fnBlock, fnEnd) ->
    selection.selectWord()
    selection.getText() in ['if', 'class', 'while', 'for', 'else', 'switch', 'def']

  insertBlock: (grammar, selection) ->
    selection.selectToEndOfLine()
    selection.clear()
    selection.insertText '{\n}'
    console.log 'insertBlock'

  insertEndChar: (grammar, selection) ->
    console.log 'insertEndChar'
    console.log 'insertEndChar'

  insertPython: ->
    console.log 'insertPython'

  insertCoffeeScript: ->
    console.log 'insertPython'

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
