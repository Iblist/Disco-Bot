;;;;Functions which perform core operations for the bot, as well as interacts with the websocket
(in-package :disco-bot)

(defmacro defbot (bot-name bot-token)
  `(defvar ,bot-name (make-instance 'bot :token ,bot-token)))

(defgeneric start-bot (obj)
  (:documentation "Start of the bots authentication process"))

(defmethod start-bot (obj)
  (with-accessors ((web-socket web-socket))
      obj
    (setf web-socket (make-client +ws-address+))
    (make-listeners obj)
    (start-connection web-socket :verify nil)))

(defgeneric make-listeners (obj)
  (:documentation "Removes listeners from web-socket then adds new ones"))

(defmethod make-listeners (obj)
  (with-accessors ((web-socket web-socket)
		   (hb-thread hb-thread)
		   (connected? connected?)
		   (authenticated? authenticated?))
      obj
    (remove-all-listeners (web-socket obj))
    (on :message (web-socket obj)
	(lambda (message)
	  (let ((op (get-item :op message))
		(d (get-item :d message))
		(type (get-item :t message))
		(out *standard-output*))
	    (case op
	      (0 (message-handler obj type d)
		 (get-sequence-number obj message))
	      (7 (reconnect-handler message))
	      (9 (invalid-session-handler message))
	      (10 (hello-received obj d))
	      (11 (heartbeat-recv obj))
	      (t (format out "~a~%" message))))))
    (on :close (web-socket obj)
	(lambda (&key code reason)
	  (format t "Code: ~a~%Reason:~a~%" code (octets-to-string reason))
	  (setf hb-thread nil)
	  (setf authenticated? nil)
	  (setf connected? nil)))))
  
(defgeneric hello-received (obj message)
  (:documentation "Starts a thread to send heartbeats to the websocket"))

(defmethod hello-received (obj message)
  (with-accessors ((hb-thread hb-thread)
		   (rate rate))
      obj
    (setf rate (cdr-assoc :heartbeat--interval message))
    (setf hb-thread (make-thread
		     (lambda ()
		       (heart-beat obj))))))

(defgeneric heartbeat-recv (obj)
  (:documentation "Checks if bot is authenticated on recieving a heartbeat and then authenticates if required"))

(defmethod heartbeat-recv (obj)
  (with-slots ((auth authenticated?)
	       (id session-id)
	       (seq sequence-number))
      obj
    (when (not auth)
      (if id (resume-bot obj) (authenticate obj)))))

(defgeneric stop-bot (obj)
  (:documentation "Sets the bot's online status to invisible. Still connected to the websocket, just appears to be offline."))

(defmethod stop-bot (obj)
  (update-status obj "invisible"))

(defgeneric get-sequence-number (obj message)
  (:documentation "Gets sequence number from opcode 0 message and updates bot. Used when resuming"))

(defmethod get-sequence-number (obj message)
  (with-accessors ((sq sequence-number))
      obj
    (setf sq (get-item :s message))))

(defun reconnect-handler (message)
  (declare (ignore message))
  (print "Reconnect recieved"))

(defun invalid-session-handler (message)
  (declare (ignore message))
  (print "Invalid session recieved"))

(defun message-handler (bot type content)
  """Fires off an event based on what opcode 0 event is recieved on the websocket"""
  (str-case type
	    ("READY" (on-ready bot content))
	    ("RESUMED" (on-resumed bot content))
	    ("CHANNEL_CREATE" (on-channel-create content))
	    ("CHANNEL_UPDATE" (on-channel-update content))
	    ("CHANNEL_DELETE" (on-channel-delete content))
	    ("CHANNEL_PINS_UPDATE" (on-channel-pins-update content))
	    ("GUILD_CREATE" (on-guild-create content))
	    ("GUILD_UPDATE" (on-guild-update content))
	    ("GUILD_DELETE" (on-guild-delete content))
	    ("GUILD_BAN_ADD" (on-guild-ban-add content))
	    ("GUILD_BAN_REMOVE" (on-guild-ban-remove content))
	    ("GUILD_EMOJIS_UPDATE" (on-guild-emojis-update content))
	    ("GUILD_INTEGRATIONS_UPDATE" (on-guild-integrations-update content))
	    ("GUILD_MEMBER_ADD" (on-guild-member-add content))
	    ("GUILD_MEMBER_REMOVE" (on-guild-member-remove content))
	    ("GUILD_MEMBER_UPDATE" (on-guild-member-update content))
	    ("GUILD_ROLE_CREATE" (on-guild-role-create content))
	    ("GUILD_ROLE_UPDATE" (on-guild-role-update content))
	    ("GUILD_ROLE_DELETE" (on-guild-role-delete content))
	    ("MESSAGE_CREATE" (on-message-create content))
	    ("MESSAGE_UPDATE" (on-message-update content))
	    ("MESSAGE_DELETE" (on-message-delete content))
	    ("MESSAGE_DELETE_BULK" (on-message-delete-bulk content))
	    ("MESSAGE_REACTION_ADD" (on-message-reaction-add content))
	    ("MESSAGE_REACTION_REMOVE" (on-message-reaction-remove content))
	    ("MESSAGE_REACTION_REMOVE_ALL" (on-message-reaction-remove-all content))
	    ("PRESENCE_UPDATE" (on-presence-update content))
	    ("TYPING_START" (on-typing-start content))
	    ("USER_UPDATE" (on-user-update content))
	    ("VOICE_STATE_UPDATE" (on-voice-state-update content))
	    ("VOICE_SERVER_UPDATE" (on-voice-server-update content))
	    ("WEBHOOKS_UPDATE" (on-webhooks-update content))
	    (type (on-un-implemented-event type content))))
