# Disco-Bot

Disco-Bot (name pending) is a library for creating bots for Discord.

There are a couple of other libraries for doing this (notably https://github.com/lispcord/lispcord), however I couldn't get that to run on my computer so I made my own.

This is very much a **WIP**. While it should run on any implementation of Common Lisp, I make no promises. I'm still learning Lisp, and probably can't help too much if something breaks.

##Usage
Disco-bot handles the backend communication with the Discord API. Read up on that here: [Discord API](https://discordapp.com/developers/docs/intro).

###Creating a Bot
Currently, you can create a bot by using `(defvar *bot-name* (make-instance 'bot :token <your bot token>))`

The bot class contains methods used for interacting with the gateway

###Events
Events are handled using [Event Glue by orthecreedence.](https://github.com/orthecreedence/event-glue/) Events fired by Event Glue are named the same as in the Discord API docs with `_` replaced with `-`.

Events can be captured using, for example, `(bind :message-create (lambda (event)
			(*your code*)))`

###Sending messages
The send-message method is used to send text to the Gateway.
`(send-message *bot-name* channel-id "message")`

##Licence
Hahahahahahahahahahaahhahahahahahhaaahahahahahahahahahhhahahahahahaa
*deep breath*
bahahahahahahahahaahahahahahaahaahahahahaaahahhahahaha
Do what you want, maybe shoot me a message if you think it's cool.
