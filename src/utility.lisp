;;;;Several short utility functions created to make code easier to read
(in-package :disco-bot)

(defmacro str-case (key &body forms)
  """Same idea as the case macro, but with strings"""
  `(cond ,@(loop for f in forms collect
		`((equal ,key ,(car f)) ,@(cdr f)))
	 (t nil)))

(defun create-payload (message &rest rest)
  (loop for field in rest collect
       (assoc field message)))
"""
(defun create-payload (message &rest rest)
  (declare (ignore rest))
  message)
"""

"""
(defmacro create-payload (message &body body)
  `(list ,@(loop for field in body collect
	       `(cdr-assoc ,field ,message))))
"""

(defun cdr-assoc (item list)
  (cdr (assoc item list)))

(defun get-item (item message)
  (let ((decoded-json (decode-json-from-string message)))
    (cdr-assoc item decoded-json)))

(defun make-bot-unbound (instance)
  (makunbound instance))
