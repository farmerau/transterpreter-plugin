TransterpreterPluginView = require './transterpreter-plugin-view'
Settings = require './settings.coffee'
fs = require 'fs-plus'

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
    #doWork() does work... Read comments in function for more info.
    @subscriptions.add atom.commands.add 'atom-workspace', 'transterpreter-plugin:doWork' : => @doWork()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @transterpreterPluginView.destroy()
    #This code is to safely deactivate the statusBar subscription.
    @statusBarTile?.destroy()
    @statusBarTile = null

  serialize: ->
    transterpreterPluginViewState: @transterpreterPluginView.serialize()

  toggle: ->
    ##call unbindEventHandler() on the view to perform a jQuery unbind on the @dropdown1 object to prevent redundancy.
    ##redundancy would happen if the transterpreter plugin were activated multiple times, because the event handler would be created each time.
    @transterpreterPluginView.unbindEventHandler()
    http = require('http') #standard use of node.js http package. see https://nodejs.org/api/http.html
    window.options.path='/board-choices.rkt' #sets http request path in options array defined in settings.coffee
    http.get window.options, (res) -> #perform get request with the specified options defined in settings.coffee
      res.on 'data', (chunk) -> #grabs the html body
        window.ListOfBoards = chunk.toString() #turns it into a string and stores it into a predefined variable in settings.coffee
    @modalPanel.hide() #hides the modal panel in case it is somehow up.
    if(@statusBarTile) #checks to see if we're using the statusBar service.
      if (@statusBarTile.item.hidden) #if we are not displaying it
        @statusBarTile.item.hidden= false #show it.
      else #else
        @statusBarTile.item.hidden= true #hide it.
    #blank line. Nothing happens here.
  doWork: ->#executes everytime the modal appears. Keeps modal up-to-date.
    #create modal
    @transterpreterPluginView.setProject(atom.project.getPaths()) #pass the project paths defined in atom.project. See Atom API. This updates the dropdown box for projects.
    @transterpreterPluginView.setBoards(window.ListOfBoards) #this takes in the list of boards derived from the http request in toggle. This updates the arduino dropdown.

    if @modalPanel.isVisible() #If the panel is visisble.
      @modalPanel.hide() #hide it.
    else #else
      @modalPanel.show() #show it.
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
     clickHandler = => atom.commands.dispatch(atom.views.getView(atom.workspace.getActiveTextEditor()), 'transterpreter-plugin:doWork')

     #function doWork() may be renamed, currently doesn't actually do any work.
     transtrprtrActionable.addEventListener("click", clickHandler)
     #appendChild() is how we're going to insert the image into the link.
     transtrprtrActionable.appendChild(transtrprtrLogo)

     ##This actualyl does the work involved in appending it to the statusbar.
     @statusBarTile = statusBar.addRightTile(item: transtrprtrActionable, priority: 999)
