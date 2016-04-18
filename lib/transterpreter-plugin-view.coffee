Settings = require "./settings.coffee"
{SelectListView, $, $$} = require 'atom-space-pen-views'
module.exports =
class TransterpreterPluginView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('transterpreter-plugin')
    #boardSelect dropdown
    @dropdown = document.createElement('select')
    @dropdown.classList.add('dropdown')
    #projectSelect dropdown
    @dropdown1 = document.createElement('select')
    @dropdown1.classList.add('dropdown')

    # Create message element
    message = document.createElement('div')
    message.textContent = window.listOfBoard
    message.classList.add('message')
    @element.appendChild(message)
    @element.appendChild(@dropdown)
    @element.appendChild(@dropdown1)

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

  setProject: (projectDirs) ->
    $(@dropdown1).empty()
    choose = $('<option>')
    choose.attr('value', "").text("Choose a project")
    $(@dropdown1).append(choose)
    for projDir in projectDirs
      temp = projDir.split("/")
      option = $('<option>')
      [..., last] = temp #CoffeeScript array destructuring http://coffeescript.org/#destructuring
      option.attr('value', projDir).text(last)
      $(@dropdown1).append(option)
