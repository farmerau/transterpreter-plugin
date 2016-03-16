TransterpreterPluginView = require './transterpreter-plugin-view'
{CompositeDisposable} = require 'atom'

module.exports = TransterpreterPlugin =
  transterpreterPluginView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @transterpreterPluginView = new TransterpreterPluginView(state.transterpreterPluginViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @transterpreterPluginView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'transterpreter-plugin:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @transterpreterPluginView.destroy()

  serialize: ->
    transterpreterPluginViewState: @transterpreterPluginView.serialize()

  toggle: ->
    console.log 'TransterpreterPlugin was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
