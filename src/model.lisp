(in-package :cl-user)

(defpackage myapp.model
  (:use :cl
        :caveman
        :myapp.app))
(in-package :myapp.model)
  
(ql:quickload :yason)
(ql:quickload :closer-mop)

 
(defclass city ()
     ((id
       :initarg :id
       :initform 0
       :accessor id)
      (name
       :initarg :name
       :initform "none"
       :accessor name)
      (country-code
       :initarg :country-code
       :initform "none"
       :accessor country-code)
      (district
       :initarg :district
       :initform "none"
       :accessor district)
      (population
       :initarg :population
       :initform 0
       :accessor population)))
  

(defmethod yason:encode-object (object)
  (let ((res ""))
    (if (listp object)
        (dolist (obj object)
          (if (equal res "")
              (setf res (format nil "[~a" (yason:encode-slots obj)))
              (setf res (format nil "~a,~a" res (yason:encode-slots obj)))))
        (setf res (format nil "~a" (yason:encode-slots object))))
    (if (listp object)
        (format nil "~a]" res)
        (format nil "~a" res))))
  
(defmethod yason:encode-slots (object)
  (yason:with-output-to-string* ()
    (yason:with-object ()
      (mapcar (lambda (s)
                (let ((slot-name  (c2mop:slot-definition-name s)))
                  (format nil "~a" (yason:encode-object-element 
                                    (string-downcase (symbol-name slot-name)) 
                                    (slot-value object slot-name)))))
              (c2mop:class-slots (class-of object))))))

(defun make-city (raw)
  (let ((city (make-instance 'city)))
    (setf (id city) (getf raw :ID))
    (setf (name city) (getf raw :|Name|))
    (setf (country-code city) (getf raw :|CountryCode|))
    (setf (district city) (getf raw :|District|))
    (setf (population city) (getf raw :|Population|))
    city))
 
