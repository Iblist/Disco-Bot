(defsystem "disco-bot"
  :description "disco-bot: Discord bot library for common lisp"
  :version "1.0"
  :author "Tyler Hoskins <tyleryouknowtheginger@gmail.com>"
  :licence "WTFPL"
  :pathname "src/"
  :depends-on ("websocket-driver-client" "drakma" "cl-json" "bt-semaphore" "event-glue")
  :components ((:file "constants")
	       (:file "utility")
	       (:file "web-socket" :depends-on("constants" "utility"))
	       (:file "gateway" :depends-on ("constants" "utility"))
	       (:file "core" :depends-on ("gateway"))
	       (:file "payloads" :depends-on ("core"))
	       (:file "dispatch-handlers" :depends-on ("payloads"))))

