;;;;Functions which interact directly with the web-socket
(in-package :disco-bot)

(defgeneric authenticate (obj &key os game status)
  (:documentation "Authenticate bot with websocket"))

(defmethod authenticate (obj &key (os "emacs") (game "with-lisp") (status "Online"))
  (with-accessors ((token token)
		   (web-socket web-socket)
		   (authenticated? authenticated?))
      obj
    (send-text web-socket
	       (encode-json-alist-to-string
		`((:op . 2)
		  (:d . ((:token . ,token)
			 (:properties . ((:os . ,os)
					 (:browser . "disco-bot")
					 (:device . "disco-bot")))
			 (:presence . ((:game . ((:name . ,game)
						 (:type . 0)))))
			 (:compress . "false")
			 (:large-number . 50)
			 (:status ,status)
			 (:afk "false"))))))
    (setf authenticated? t)))

(defgeneric resume-bot (obj)
  (:documentation "Resumes the bots connection, gateway will then replay missed events"))

(defmethod resume-bot (obj)
  (with-accessors ((token token)
		   (ws web-socket)
		   (auth authenticated?)
		   (id session-id)
		   (seq sequence-number))
      obj
    (print "Resumed")
    (send-text ws (encode-json-alist-to-string
		   `((:op . 6)
		     (:d . ((:token . ,token)
			    (:session-id . ,id)
			    (:seq . ,seq))))))
    (setf auth t)))

(defgeneric update-status (obj status &optional game)
  (:documentation "Updates the clients status, e.g online, offline, dnd etc"))

(defmethod update-status (obj status &optional (game nil game-supplied-p))
  (with-slots (web-socket) obj
    (let ((activity (if game-supplied-p `((:name . ,game)(:type . 0)) nil)))
      (send-text web-socket (encode-json-alist-to-string
			     `((:op . 3)
			       (:d . ((:since . nil)
				      (:game . ,activity)
				      (:status . ,status)
				      (:afk . "false")))))))))
