I need your input on this so please discuss the following topic with me. The work has already started ( #155 ) but will take a while to finish.

Current state of authentication in SDDM is not sufficient to handle all cases required in a typical desktop setup. This document explains the motivation and way how to fix this.

### Current state
Nowadays, SDDM provides only simple username/password pair authentication. Neither password change nor more complicated credential requests are supported.

PAM support is still botched and double forking is required for it to work correctly.

The communication between the greeter and the daemon is strictly synchronous, implemented using by passing Login(user, pass, auto), LoginSucceeded and LoginFailed messages over a socket. This is not sufficient to implement any other use case.

The greeter provides components to select the user from a list and to enter a username and password.

### Proposed solution
I started writing QAuth (https://github.com/MartinBriza/QAuth). QAuth is a library providing unified user authentication to developers of Qt applications. The supported backends in version 0.1.1 are PAM and checking against /etc/shadow.

PAM is finally handled right - the authentication itself takes place in a helper binary that communicates with the parent application over a temporary socket.

The implemented API is completely asynchronous and general. There are three classes - QAuth as the entry point, QAuthRequest containing one concise request from the backend ("provide user and password") wrapping a list of QAuthPrompt that is used for retrieving one piece of information at a time ("password:..."). All these are exposed to both C++ and direct QML usage directly.

The main motivation to write was to provide a proper support for PAM. 

### Actions Required
If we decide to use QAuth, we need to modify everything that has anything to do with authentication:

* The daemon: Replace Authenticator with QAuth, change the socket communication with the greeter

* The greeter: Change the socket communication with the daemon, rewrite the conversation code in GreeterProxy

* SDDMComponents: Provide generic input methods for themes

* Themes: Hopefully nothing but more realistically we should switch to the generic components

