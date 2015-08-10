{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'
Utils = require './utils'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': => @complete()

  complete: ->
    editor = atom.workspace.getActiveTextEditor()
    # editor.moveToFirstCharacterOfLine()
    # DONE: find block detect function
    # DONE: find insertBlock function
    # DONE: find insertEndChar function
    # DONE: All those based on grammar
    # TODO: can't use (Utils[grammarName] ? Utils.insertNewLine)(selection) because context changed
    grammarName = @getGrammarName editor
    editor?.mutateSelectedText (selection) ->
      if Utils[grammarName]?
        Utils[grammarName] selection
      else
        Utils.unsupport selection

  getGrammarName: (editor) ->
    grammar = editor?.getGrammar?()
    grammarName = grammar.name ? grammar.scopeName if grammar?
    grammarName?.toLowerCase()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
