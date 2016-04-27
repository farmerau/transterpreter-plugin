Settings = require "./settings.coffee"
{SelectListView, $, $$} = require 'atom-space-pen-views'
fs = require 'fs-plus'
module.exports =
class TransterpreterPluginView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div') #default
    @element.classList.add('transterpreter-plugin') #default
    #boardSelect dropdown
    @dropdown = document.createElement('select') #This is how you create a dropdown element. Call it dropdown.
    @dropdown.classList.add('dropdown') #This is the css class called dropdown for formatting.
    #projectSelect dropdown
    @dropdown1 = document.createElement('select') #dropdown1 declaration.
    @dropdown1.classList.add('dropdown') #Gets the same formatting as the other dropdown.

    # Create message element
    message = document.createElement('div') #default.
    message.classList.add('message') #default.
    @element.appendChild(message) #default.
    @element.appendChild(@dropdown) #throw the dropdown in there.
    @element.appendChild(@dropdown1) #throw the other dropdown in there.

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    # Tear down any state and detach

  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setBoards: (listofBoards) ->
    $(@dropdown).empty() #prevents us from populating an already populated dropdown.
    boards = listofBoards.split("\n"); #expects the list to be separated by new lines.
    for line in boards #iterate ofer the array returned by the split("/n") in previous line.
      temp = line.split(":") #expects value:key pairings.
      option = $('<option>') #create option element.
      if (temp[0] != '') #if the string isn't empty, because split gives us an empty string at the end...
        option.attr('value', temp[1]).text(temp[0]) #fill the option.
        $(@dropdown).append(option) #put the option in the selct box.

  generatePayload: (path) ->
    if path != "" #make sure the path is 'SOMETHING'
      contents = "files" #string for json key.
      fileContents = "contents" #string for json key.
      tempDirs = atom.workspace.getActivePaneItem()?.buffer.file?.path.split('/') #Convoluted function call series.
      ##Grab the active Pane so that we know what the active file is. This will be our main file to pass to server.

      [..., mainFile] = tempDirs ## Store the mainFile name. Happens to be the last thing in the array.
      window.payload["main"] = btoa(mainFile) #btoa is a javascript builtin that does base64 encoding. Do this to the filename.
      window.payload["ardu"] = $(@dropdown).find(":selected").val() #store the key to pass to the compiler to specify which arduino it compiles for.
      window.payload[contents] = {} #make sure this is an empty object.
      window.payload[fileContents] = [] #make sure this is an empty array.
      files = fs.listSync(path, window.acceptedFileTypes) #uses node package fs-plus to do a synchronous listing of the files in a directory as an array.
      for file in files #iterate through the array of files.
        filename = file.split('/') #split it at / so we can get the actual file name.
        [..., last] = filename #store the filename.
        temp = last #throw it into a temp variable. This can probably be deleted in the future. Was probably added for testing.
        tempObj = {} #make sure we declare this each time as an empty object.
        tempObj[temp] = btoa(fs.readFileSync(file, "utf-8")) #temp is the key. base64 encode the contents of the file. Again uses fs-plus. Make sure it is utf-8 encoded.
        window.payload[fileContents].push(temp) #add the listing for the filename.
        window.payload[contents][temp] = tempObj[temp] #store the tempObj that has the key and the filecontents in a nice little base64 encoded package.


  unbindEventHandler: ->
    $(@dropdown1).unbind(); #jQuery call.


  setProject: (projectDirs) ->
    $(@dropdown1).empty() #Prevents us from populating an already populated array
    choose = $('<option>') #Creates default choice in project dropdown
    choose.attr('value', "").text("Choose a project") #Sets default choice in project dropdown to "Choose a project"
    $(@dropdown1).append(choose) #Add default option to project dropdown
    for projDir in projectDirs #iterate through list of projects passed into function
      temp = projDir.split("/") #split it at / so we can get the actual project name
      option = $('<option>') #Create a new option
      [..., last] = temp #Get last element of array, as this will be the actual name of the project
      ##CoffeeScript array destructuring http://coffeescript.org/#destructuring
      option.attr('value', projDir).text(last) #Set value of this option to the name of the project
      $(@dropdown1).append(option) #fills the option
    $(@dropdown1).on("change", => @generatePayload($(@dropdown1).find(":selected").val())) #Generates json object based on user input
