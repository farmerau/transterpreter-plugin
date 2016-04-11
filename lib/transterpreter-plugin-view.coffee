Settings = require "./settings.coffee"
{SelectListView, $, $$} = require 'atom-space-pen-views'
module.exports =
class TransterpreterPluginView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('transterpreter-plugin')
    @dropdown = document.createElement('select')
    @dropdown.classList.add('dropdown')

    # Create message element
    message = document.createElement('div')
    message.textContent = window.listOfBoards
    message.classList.add('message')
    @element.appendChild(message)
    @element.appendChild(@dropdown)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setBoards: (listofBoards) ->
    $(@dropdown).empty()
    boards = listofBoards.split("\n");
    for line in boards
      temp = line.split(":")
      option = $('<option>')
      if (temp[0] != '')
        option.attr('value', temp[1]).text(temp[0])
        $(@dropdown).append(option)
