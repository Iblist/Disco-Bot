# Disco-Bot

Disco-Bot (name pending) is a library for creating bots for Discord.

There are a couple of other libraries for doing this (notably https://github.com/lispcord/lispcord), however I couldn't get that to run on my computer so I made my own.

This is very much a **WIP**. While it should run on any implementation of Common Lisp, I make no promises. I'm still learning Lisp, and probably can't help too much if something breaks.

## Usage
Disco-bot handles the backend communication with the Discord API. Read up on that here: [Discord API](https://discordapp.com/developers/docs/intro).
Fair warning, their documentation isn't...great.

### Creating a Bot
The easiest way to create a bot is using the defbot macro as follows: `(defbot *bot-name* *bot-token*)`
This creates a new instance of the bot class with the assigned name and bot token. 

The bot class contains methods used for interacting with the gateway

### Events
Events are handled using [Event Glue by orthecreedence.](https://github.com/orthecreedence/event-glue/) Events fired by Event Glue are named the same as in the Discord API docs with `_` replaced with `-`.

Events can be captured using, for example, `(bind :message-create (lambda (event)
			(*your code*)))`

You can find a list of possible gateway events [here.](https://discordapp.com/developers/docs/topics/gateway#commands-and-events)

### Sending messages
The send-message method is used to send text to the Gateway.
`(send-message *bot-name* channel-id "message")`

## Licence
Copyright © 2019 Tyler Hoskins tyleryouknowtheginger@gmail.com
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details
