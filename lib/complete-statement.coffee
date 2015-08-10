{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'
Utils = require './utils'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': => @complete()

  complete: ->
    editor = atom.workspace.getActiveTextEditor()
    Utils.complete editor if editor?
    # editor.moveToFirstCharacterOfLine()
    # DONE: find block detect function
    # DONE: find insertBlock function
    # DONE: find insertEndChar function
    # DONE: All those based on grammar

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
