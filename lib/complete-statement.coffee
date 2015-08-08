{CompositeDisposable} = require 'atom'
path = require 'path'
_ = require 'underscore-plus'
Utils = require './utils'
CSON = require 'season'

module.exports = CompleteStatement =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'complete-statement:complete': => @complete()
    @load()

  # completeWithLoad: ->
    # if @config? then @complete() else @load @complete

  complete: ->
    editor = atom.workspace.getActiveTextEditor()
    # editor.moveToFirstCharacterOfLine()
    # DONE: find block detect function
    # DONE: find insertBlock function
    # DONE: find insertEndChar function
    # DONE: All those based on grammar
    functions = @getFunctions editor
    editor?.mutateSelectedText (selection, index) ->
      if Utils[functions.needBlock] selection
        Utils[functions.insertBlock] selection
      else
        Utils[functions.insertEndChar] selection

  getFunctions: (editor) ->
    grammar = editor?.getGrammar?()
    if grammar?
      if grammar is atom.grammars.nullGrammar
        grammarName = 'Plain Text'
      else
        grammarName = grammar.name ? grammar.scopeName
    @config[grammarName] ? @config.nullGrammar
    # console.log @config[grammarName].insertBlock

  loadConfigFile: (filePath, callback) ->
    return callback({}) unless CSON.isObjectPath(filePath)
    callback(CSON.readFileSync filePath)

  load: ->
    bundledPath = CSON.resolve(path.join(__dirname, 'complete'))
    @loadConfigFile bundledPath, (config) => @config = config

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @completeStatementView.destroy()

  serialize: ->
    completeStatementViewState: @completeStatementView.serialize()
