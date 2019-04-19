;;;;Stuff that should not be changed through the bot's lifetime
(defpackage :disco-bot
  (:use
   :cl
   :drakma
   :json
   :wsd
   :bt
   :flexi-streams
   :event-glue))

(in-package :disco-bot)

(defconstant +base-url+
  "https://discordapp.com/api")

(defconstant +user-agent+
  "Disco-Bot (https://github.com/Iblist/Disco-Bot, 1.0)")

(defconstant +client+
  "disco-bot")

(defconstant +version+
  "0.2")

(defconstant +author+
  "Tyler Hoskins")

(defconstant +ws-address+
   "wss://gateway.discord.gg/?v=6&encoding=json")

(defclass bot ()
  ((token
    :reader token
    :initarg :token
    :initform (error "Bot requires a token")
    :documentation "Bot's token for authenticating with discord")
   (connected?
    :accessor connected?
    :initform nil
    :documentation "Am I connected to websocket?")
   (authenticated?
    :accessor authenticated?
    :initform nil
    :documentation "Am I authenticated with the gateway?")
   (web-socket
    :accessor web-socket
    :documentation "Websocket resource which the bot posts messages to")
   (rate
    :accessor rate
    :documentation "Rate limit for posting to gateway")
   (heart-beat-thread-id
    :accessor hb-thread
    :documentation "Thread used to send heartbeats to gateway")
   (session-id
    :accessor session-id
    :initform nil
    :documentation "Session ID for resuming, sent during ready event")
   (sequence-number
    :accessor sequence-number
    :initform nil
    :documentation "Sequence of op 0 events, used for resuming and heartbeats")))
