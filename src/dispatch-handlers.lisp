;;;;Functions that trigger events in response to the websocket
"""
Expects content to be an already decoded alist
Naming convention is: <on-*event-name*>
"""

"""
TODO
Guild Members Chunk
"""

(in-package :disco-bot)

(defgeneric on-ready (obj message)
  (:documentation "Parses data from ready event and updates bot"))

(defmethod on-ready (obj message)
  (with-accessors ((id session-id))
      obj
    (setf id (cdr-assoc :session--id message))))

(defgeneric on-resumed (obj trace)
  (:documentation "Contains debug information when resume succeeds"))

(defmethod on-resumed (obj trace)
  (trigger (event :resumed
		  :data trace))
  (with-accessors ((auth authenticated?))
      obj
    (setf auth t)))

(defun on-channel-create (message)
  (trigger (event :channel-create
		  :data (create-channel-object message))))

(defun on-channel-update (message)
  (trigger (event :channel-update
		  :data (create-channel-object message))))

(defun on-channel-delete (message)
  (trigger (event :channel-delete
		  :data (create-channel-object message))))

(defun on-channel-pins-update (message)
  (trigger (event :channel-pins-update
		  :data (create-payload message
			  :channel--id
			  :last--pin--timestamp))))

(defun on-guild-create (message)
  (trigger (event :guild-create
		  :data (create-guild-object message t))))

(defun on-guild-update (message)
  (trigger (event :guild-update
		  :data (create-guild-object message))))

(defun on-guild-delete (message)
  (trigger (event :guild-delete
		  :data (create-payload message
			  :id
			  :unavailable))))

(defun on-guild-ban-add (message)
  (trigger (event :guild-ban-add
		  :data (create-payload message
			  :guild--id
			  :user))))

(defun on-guild-ban-remove (message)
  (trigger (event :guild-ban-remove
		  :data (create-payload message
			  :guild--id
			  :user))))

(defun on-guild-emojis-update (message)
  (trigger (event :guild-emojis-update
		  :data (create-payload message
			  :guild--id
			  :emojis))))

(defun on-guild-integrations-update (message)
  (trigger (event :guild-integrations-update
		  :data (create-payload message
			  :guild--id))))

(defun on-guild-member-add (message)
  (trigger (event :guild-member-add
		  :data (create-guild-member-object message t))))

(defun on-guild-member-remove (message)
  (trigger (event :guild-member-remove
		  :data (create-payload message
			  :guild--id
			  :user))))

(defun on-guild-member-update (message)
  (trigger (event :guild-member-update
		  :data (create-payload message
			  :guild--id
			  :roles
			  :user
			  :nick))))

(defun on-guild-role-create (message)
  (trigger (event :guild-role-create
		  :data (create-payload message
			  :guild--id
			  :role))))

(defun on-guild-role-update (message)
  (trigger (event :guild-role-update
		  :data (create-payload message
			  :guild--id
			  :role))))

(defun on-guild-role-delete (message)
  (trigger (event :guild-role-delete
		  :data (create-payload message
			  :guild--id
			  :role--id))))

(defun on-message-create (message)
  (trigger (event :message-create
		  :data (create-payload message
			  :id
			  :channel--id
			  :guild--id
			  :author
			  :member
			  :content
			  :timestamp
			  :edited--timestamp
			  :tts
			  :mention--everyone
			  :mentions
			  :mention--roles
			  :attachments
			  :embeds
			  :reactions
			  :nonce
			  :pinned
			  :webhook--id
			  :type
			  :activity
			  :application))))

(defun on-message-update (message)
  (trigger (event :message-update
		  :data (create-message-object message))))

(defun on-message-delete (message)
  (trigger (event :message-delete
		  :data (create-payload message
			  :id
			  :channel--id
			  :guild--id))))

(defun on-message-delete-bulk (message)
  (trigger (event :message-delete
		  :data (create-payload message
			  :ids
			  :channel--id
			  :guild--id))))

(defun on-message-reaction-add (message)
  (trigger (event :message-reaction-add
		  :data (create-payload message
			  :user--id
			  :channel--id
			  :message--id
			  :guild--id
			  :emoji))))

(defun on-message-reaction-remove (message)
  (trigger (event :message-reaction-remove
		  :data (create-payload message
			  :user--id
			  :channel--id
			  :message--id
			  :guild--id
			  :emoji))))

(defun on-message-reaction-remove-all (message)
  (trigger (event :message-reaction-remove-all
		  :data (create-payload message
			  :channel--id
			  :message--id
			  :guild--id))))

(defun on-typing-start (message)
  (trigger (event :typing-start
		  :data (create-payload message
			  :channel--id
			  :guild--id
			  :user--id
			  :timestamp))))

(defun on-presence-update (message)
  (trigger (event :presence-update
		  :data (create-payload message
					:user
					:roles
					:game
					:guild--id
					:status
					:activities
					:client--status))))

(defun on-user-update (message)
  (trigger (event :user-update
		  :data (create-user-object message))))

(defun on-voice-state-update (message)
  (trigger (event :voice-state-update
		  :data (create-payload message
					:guild--id
					:channel--id
					:user--id
					:member
					:session--id
					:deaf
					:mute
					:self--deaf
					:self--mute
					:suppress))))

(defun on-voice-server-update (message)
  (trigger (event :voice-server-update
		  :data (create-payload message
					:token
					:guild--id
					:endpoint))))

(defun on-webhooks-update (message)
  (trigger (event :webhooks-update
		  :data (create-payload message
					:guild--id
					:channel--id))))

(defun on-un-implemented-event (type content)
  (format t "Event of type: ~a is not implemented, contained;~%~{~a~^~%~}"
	  type content))
