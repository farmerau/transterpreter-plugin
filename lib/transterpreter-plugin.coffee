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
  consumeStatusBar: (statusBar) ->
    ##This functions purpose is to make a clickable transterpreter logo
    ##that will send the code to the compiler and do the arduino work.

    #Create the element to hold the transterpeter logo
     transtrprtrLogo = document.createElement('img')
     #Use atom://transterpreter-plugin/$dir to reference items from project dir.
     transtrprtrLogo.setAttribute('src', "atom://transterpreter-plugin/styles/tvm-logo.png")
     #Setting height to 17px because it looks okay. May work on actually styling this later.
     transtrprtrLogo.setAttribute('height', "17 px")
     #We need this icon to actually do something, so I'm going with href to function call.
     transtrprtrActionable = document.createElement('a')
     transtrprtrActionable.setAttribute('href', "#")
     #function doWork() may be renamed, currently doesn't actually do any work.
     transtrprtrActionable.setAttribute('onClick', "doWork();")
     #appendChild() is how we're going to insert the image into the link.
     transtrprtrActionable.appendChild(transtrprtrLogo)

     ##This actualyl does the work involved in appending it to the statusbar.
     @statusBarTile = statusBar.addRightTile(item: transtrprtrActionable, priority: 999)

  doWork: ->
