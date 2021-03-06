(in-package :web4r)

(defclass pager ()
  ((items-per-page :type integer :initform *items-per-page* :initarg :items-per-page
                   :documentation "A number to display items per page.")
   (links-per-page :type integer :initform *links-per-page* :initarg :links-per-page
                   :documentation "A number to display page links per page.")
   (total-items    :type integer :initarg :total-items
                   :initform (error "Must supply total-items.")
                   :documentation "A number of total items.")
   (current-page   :type integer :initarg :current-page
                   :initform (get-current-page) :accessor current-page
                   :documentation "A current page number.")
   (total-pages    :type integer :accessor total-pages
                   :documentation "A number of total pages.")
   (item-start     :type integer :accessor item-start
                   :documentation "A start number to display items.")
   (item-end       :type integer :accessor item-end
                   :documentation "An end number to display items.")
   (link-start     :type integer :accessor link-start
                   :documentation "A start number to display page links.")
   (link-end       :type integer :accessor link-end
                   :documentation "An end number to display page links.")
   (next-link      :type string  :accessor next-link :initform ">>"
                   :documentation "A link to next page links.")
   (prev-link      :type string  :accessor prev-link :initform "<<"
                   :documentation "A link to previous page links."))
  (:documentation "A pagination class."))

(defun get-current-page ()
  "Returns the current page number."
  (let ((page (->int (get-parameter *page-param*))))
    (if (aand page (plusp it)) page 1)))

(defmethod initialize-instance :after ((p pager) &key)
  (with-slots (total-items total-pages items-per-page current-page) p
    (setf total-pages    (ceiling (/ total-items items-per-page))
          (item-start p) (* (1- current-page) items-per-page)
          (item-end   p) (min (* current-page items-per-page) total-items))
    (multiple-value-bind (link-start link-end) (link-limit p)
      (setf (link-start p) link-start
            (link-end   p) link-end))))

(defun link-limit (pager)
  (with-slots (links-per-page total-pages current-page) pager
    (cond ((= total-pages 1) (values 0 0))
          ((>= links-per-page total-pages) (values 1 total-pages))
          (t (let* ((left  (round (/ links-per-page 2)))
                    (right (- links-per-page left)))
               (cond ((<= current-page left) (values 1 links-per-page))
                     ((> (+ current-page right) total-pages)
                      (values (1+ (- total-pages links-per-page)) total-pages))
                     (t (values (- current-page left)
                                (+ current-page right)))))))))

(defmacro prev-link* (pager &optional parameters)
  "Displays a link to previous page links by the PAGER, must be
 an instance of the pager class, if needed. The default link is '<<'.
 PARAMETERS is a string get parameters which will be added to the link."
  `(with-slots (links-per-page current-page prev-link) ,pager
     (let ((page (max 1 (- current-page links-per-page)))
           (link (prev-link ,pager))
           (parameters ,parameters))
       (when (< 1 (link-start ,pager))
         (load-sml-path "paging/page_link.sml" ,*web4r-package*)))))

(defmacro next-link* (pager &optional parameters)
  "Displays a link to next page links by the PAGER, must be an
 instance of the pager class, if needed. The default link is '>>'.
 PARAMETERS is a string get parameters which will be added to the link."
  `(with-slots (links-per-page current-page next-link total-pages) ,pager
     (let ((page (min total-pages (+ current-page links-per-page)))
           (link (next-link ,pager))
           (parameters ,parameters))
       (when (< (link-end ,pager) total-pages)
         (load-sml-path "paging/page_link.sml" ,*web4r-package*)))))

(defun page-links (pager &optional parameters)
  "Generates and displays page links by the PAGER, must be an instance
 of the pager class, if needed. PARAMETERS is a string get parameters
 which will be added to the links."
  (with-slots (total-pages link-start link-end current-page) pager
    (when (> total-pages 1)
      (load-sml-path "paging/page_links.sml"))))

(defun page-summary (pager)
  "Generates and displays a summary result of a pagination by the
 PAGER, must be an instance of the pager class, if needed. The default
 format is 'Results 1 - 10  of 100'."
  (with-slots
        (total-items item-start item-end items-per-page links-per-page) pager
    (let ((item-start (1+ item-start)))
      (load-sml-path "paging/page_summary.sml"))))

(defun w/p (link)
  "Returns the LINK after adding a get parameter denotate the current
 page number."
  (add-parameter link *page-param* (get-current-page)))
