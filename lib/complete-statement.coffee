{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'
Utils = require './utils'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': ->
      editor = atom.workspace.getActiveTextEditor()
      Utils.complete editor if editor?

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
