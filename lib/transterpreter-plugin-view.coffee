Settings = require "./settings.coffee"
pane = require "/node_modules/atom-pane"
module.exports =
class TransterpreterPluginView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('transterpreter-plugin')
    pane.append(@element)

    # Create message element
    message = document.createElement('div')
    message.textContent = window.listOfBoards
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
