#|
  This file is a part of myapp project.
|#

(in-package :cl-user)
(defpackage myapp.controller
  (:use :cl
        :caveman
        :myapp.app)
  (:import-from :myapp.view.emb
                :render)
  (:import-from :myapp.model
                :make-city))
(in-package :myapp.controller)

(cl-syntax:use-syntax :annot)


@url GET "/"
(defun index (params)
  @ignore params
  (render "index.html"))

@url POST "/"
(defun index-post (params)
  @ignore params
  "Hello, Caveman!")


@url GET "/1.0/city"
(defun 1.0-city-all (params)
  @ignore params
  (let* ((query (dbi:prepare clack.middleware.dbi:*db*
                             "SELECT * FROM City "))
         (result (dbi:execute query)))
    (yason:encode-object 
     (loop for row = (dbi:fetch result)
           while row
           collect (make-city row)))))


@url GET "/1.0/city/:id"
(defun 1.0-city-by-id (params)
  (let* ((query (dbi:prepare clack.middleware.dbi:*db*
                              (concatenate 'string "SELECT * FROM CITY WHERE ID = " (getf params :id))))
         (result (dbi:execute query))
         (row (dbi:fetch result)))
    (yason:encode-object (make-city row))))

@url GET "/1.0/city/:id/:column"
(defun 1.0-city-cloumn-by-id (params)
  (let* ((query (dbi:prepare clack.middleware.dbi:*db*
                              (concatenate 'string 
                                           "SELECT " 
                                           (getf params :column) 
                                           " FROM CITY WHERE ID = " 
                                           (getf params :id))))
         (result (dbi:execute query))
         (row (dbi:fetch result)))
    (with-output-to-string (stream)
      (yason:encode-plist row stream))))


