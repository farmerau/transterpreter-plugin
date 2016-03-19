module.exports =
class TransterpreterPluginView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('transterpreter-plugin')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The TransterpreterPlugin package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)
    message2 = document.createElement('div')
    message2.textContent = "I wanted to see what would happen."
    message2.textContent = atom.project.getPaths()
    message.classList.add('message2')
    @element.appendChild(message2)
    myElement = document.createElement('span')
    myElement.textContent = "Hi"
    
  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
