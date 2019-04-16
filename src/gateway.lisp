;;;;Functions which interact directly with the discord gateway
(in-package :disco-bot)


(defun gateway-request (client end-point method &rest rest)
  (http-request (format nil "~a/~a" +base-url+ end-point)
		:user-agent "DiscordBot (https://github.com/iblist, 1.0)"
		:method method
		:content (encode-json-alist-to-string rest)
		:additional-headers (acons "Authorization" (format nil "Bot ~a" (token client)) nil)))

(defun get-gateway (uri)
  (multiple-value-bind (body status headers uri stream closedp reason)
      (http-request uri)
    (declare (ignore headers uri stream closedp reason))
    (if (= status 200)
	(cdr (assoc ':URL
		    (decode-json-from-string
		     (octets-to-string body)))))))

(defgeneric send-message (obj channel-id message)
  (:documentation "Used to send messages to the server"))
  
(defmethod send-message (obj channel-id message)
  (let ((formatted-message (encode-json-alist-to-string (acons :content message nil)))
	(bot-token (format nil "Bot ~a" (token obj))))
    (http-request (format nil "~a/channels/~a/messages" +base-url+ channel-id)
		  :user-agent +user-agent+
		  :method :POST
		  :content formatted-message
		  :additional-headers (acons "Authorization" bot-token nil))))

(defgeneric heart-beat (obj)
  (:documentation "Used to respond to heartbeats sent by the server"))

(defmethod heart-beat (obj)
  (let ((sleep-time (/ (rate obj) 1000))
	(out *standard-output*))
    (loop while (equal (current-thread) (hb-thread obj)) do
	 (format out "Sending heartbeat...~%")
	 (send-text (web-socket obj) (encode-json-alist-to-string '((:op . 1) (:d . null))))
	 (sleep sleep-time))
    (format out "Quitting...")))
