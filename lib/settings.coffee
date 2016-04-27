window.ListOfBoards = ""; #Blank string to store the list of boards later.
window.transterpreterServer = '45.55.232.116'; #Matt's server.
window.transterpreterPort = 9000; #Port the Racket Server is listening on.
window.options = {
  hostname: window.transterpreterServer, #Transterpreter server IP
  port: window.transterpreterPort, #Port
  path:'' #is defined in function calls, hopefully.
}
window.projectDirs = []; #empty array.
window.acceptedFileTypes = [".occ", ".inc", ".mod"]; #Files that we want to ship to the server.
window.payload = {} #Empty object used to pass to the server later.
