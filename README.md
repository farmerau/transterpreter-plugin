# transterpreter-plugin package
![Transterpreter logo](http://www.geoffreylong.com/images/portfolio/identity_transterpreter.jpg)

An in-progress attempt at making an Atom plugin for the Transterpreter project.
-

What is the Transterpreter?

The transterpreter is "an open-source and highly portable virtual machine designed to exploit concurrency on embedded systems, running process-oriented programs written in the occam-pi programming language." See transterpreter.org

The transterpreter-plugin is an Atom plugin designed to make development with/for the transterpreter a breeze. Because Atom is an incredibly easy to install text editor that runs on pretty much everything, it was the clear choice for our implementation.

Activating the Transterpreter-plugin

Ctrl + Shift + T activates the transterpreter-plugin.
Additionally, you can go to Packages > transterpreter-plugin > Toggle.

To open the dialog, click the transterpreter logo in the bottom right of your statusbar.

Using the transterpreter-plugin

Pick one of the always-up-to-date arduino boards that you are developing for. Then pick the Atom project you are working on. From there, the plugin will grab all of your .occ, .mod, and .inc files, and send them to the transterpreter project's compilation server. Once the server has done it's magic, the plugin receives the instruction sets for the corresponding arduino's processor and injects those instructions via avrdude.

It's that easy.
