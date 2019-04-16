;;;;Functions for creating payloads that will be sent to the gateway
(in-package :disco-bot)

(defun create-channel-object (message)
  (create-payload message
    :id
    :type
    :guild--id
    :position
    :permission--overwrites
    :name
    :topic
    :nsfw
    :last--message--id
    :bitrate
    :user--limit
    :rate--limit--per--user
    :recipients
    :icon
    :owner--id
    :application--id
    :parent--id
    :last--pin--timestamp))

(defun create-guild-object (message &optional guild-create)
  (let ((fields (list :id
		      :name
		      :icon
		      :splash
		      :owner
		      :owner--id
		      :permissions
		      :region
		      :afk--channel--id
		      :afk--timeout
		      :embed--enabled
		      :embed--channel--id
		      :verification--level
		      :default--message--notifications
		      :explicit--content--filter
		      :roles
		      :emojis
		      :features
		      :mfa--level
		      :application--id
		      :widget--enabled
		      :widget--channel--id
		      :system--channel--id)))
    (if guild-create
	(append fields
		(list :joined--at
		      :large
		      :unavailable
		      :member--count
		      :voice--states
		      :members
		      :channels
		      :presences)))
    (create-payload message fields)))
		      
(defun create-guild-member-object (message &optional guild-member-add)
  (let ((fields (list :user
		      :nick
		      :roles
		      :joined--at
		      :deaf
		      :mute)))
    (if guild-member-add
	(append fields (list :guild--id)))
    (create-payload message fields)))

(defun create-message-object (message)
  (let ((fields (list :id
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
		      :application)))
    (create-payload message fields)))

(defun create-user-object (message)
  (let ((fields (list :id
		      :username
		      :discriminator
		      :avatar
		      :bot
		      :mfa--enabled
		      :locale
		      :verified
		      :email
		      :flags
		      :premium--type)))
    (create-payload message fields)))
