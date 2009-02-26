(in-package :web4r-tests)
(in-suite web4r)

(defvar *test-slots*
  '(name password email sex marriage hobbies birth-date
    nickname phone-number zip-code note image))

(defmacro def-test-pclass ()
  `(defpclass testdb1 ()
     ((name         :length 50 :label "Full Name" :size 30)
      (password     :input :password :length (8 12) :hide t)
      (email        :type :email :unique t)
      (sex          :input :radio :options ("Male" "Female"))
      (marriage     :input :select :options ("single" "married" "divorced"))
      (hobbies      :input :checkbox :options ("sports" "music" "reading"))
      (birth-date   :type :date)
      (nickname     :length 50 :nullable t)
      (phone-number :type (:regex "^\\d{3}-\\d{3}-\\d{4}$"))
      (zip-code     :type :integer :length 5)
      (note         :length 3000 :rows 5 :cols 30)
      (image        :input :file :type :image :length (1000 500000) :nullable t))))

(test get-slots
  (is (eq (length *test-slots*) (length (get-slots 'testdb1))))
  (loop for s in (get-slots 'testdb1)
        do (is (member (web4r::slot-symbol s) *test-slots*))))

(test get-excluded-slots
  (let ((sl (remove 'password *test-slots*)))
    (is (eq (length sl) (length (get-excluded-slots 'testdb1))))
    (loop for s in (get-excluded-slots 'testdb1)
          do (is (member (web4r::slot-symbol s) sl))))
  (let ((*with-slots* :all))
    (is (eq (length *test-slots*) (length (get-excluded-slots 'testdb1))))
    (loop for s in (get-excluded-slots 'testdb1)
          do (is (member (web4r::slot-symbol s) *test-slots*))))
  (let ((*without-slots* '(email))
        (sl (remove 'email (remove 'password *test-slots*))))
    (is (eq (length sl) (length (get-excluded-slots 'testdb1))))
    (loop for s in (get-excluded-slots 'testdb1)
          do (is (member (web4r::slot-symbol s) sl))))
  (let ((*with-slots* '(name password email))
        (sl '(name email)))
    (is (eq (length sl) (length (get-excluded-slots 'testdb1))))
    (loop for s in (get-excluded-slots 'testdb1)
          do (is (member (web4r::slot-symbol s) sl)))))

(test slot-symbol
  (loop for s in '(name password email sex marriage hobbies birth-date
                   nickname phone-number zip-code note image)
        do (is (eq s (web4r::slot-symbol (get-slot 'testdb1 s))))))

(test slot-id
  (is (equal "NAME"         (web4r::slot-id (get-slot 'testdb1 'name))))
  (is (equal "PASSWORD"     (web4r::slot-id (get-slot 'testdb1 'password))))
  (is (equal "EMAIL"        (web4r::slot-id (get-slot 'testdb1 'email))))
  (is (equal "SEX"          (web4r::slot-id (get-slot 'testdb1 'sex))))
  (is (equal "MARRIAGE"     (web4r::slot-id (get-slot 'testdb1 'marriage))))
  (is (equal "HOBBIES"      (web4r::slot-id (get-slot 'testdb1 'hobbies))))
  (is (equal "BIRTH-DATE"   (web4r::slot-id (get-slot 'testdb1 'birth-date))))
  (is (equal "NICKNAME"     (web4r::slot-id (get-slot 'testdb1 'nickname))))
  (is (equal "PHONE-NUMBER" (web4r::slot-id (get-slot 'testdb1 'phone-number))))
  (is (equal "ZIP-CODE"     (web4r::slot-id (get-slot 'testdb1 'zip-code))))
  (is (equal "NOTE"         (web4r::slot-id (get-slot 'testdb1 'note))))
  (is (equal "IMAGE"        (web4r::slot-id (get-slot 'testdb1 'image)))))

(test slot-label
  (is (equal "Full Name"    (web4r::slot-label (get-slot 'testdb1 'name))))
  (is (equal "Password"     (web4r::slot-label (get-slot 'testdb1 'password))))
  (is (equal "Email"        (web4r::slot-label (get-slot 'testdb1 'email))))
  (is (equal "Sex"          (web4r::slot-label (get-slot 'testdb1 'sex))))
  (is (equal "Marriage"     (web4r::slot-label (get-slot 'testdb1 'marriage))))
  (is (equal "Hobbies"      (web4r::slot-label (get-slot 'testdb1 'hobbies))))
  (is (equal "Birth Date"   (web4r::slot-label (get-slot 'testdb1 'birth-date))))
  (is (equal "Nickname"     (web4r::slot-label (get-slot 'testdb1 'nickname))))
  (is (equal "Phone Number" (web4r::slot-label (get-slot 'testdb1 'phone-number))))
  (is (equal "Zip Code"     (web4r::slot-label (get-slot 'testdb1 'zip-code))))
  (is (equal "Note"         (web4r::slot-label (get-slot 'testdb1 'note))))
  (is (equal "Image"        (web4r::slot-label (get-slot 'testdb1 'image)))))

(test slot-unique
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'password))))
  (is (eq t   (web4r::slot-unique (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'zip-code))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-unique (get-slot 'testdb1 'image)))))

(test slot-nullable
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'birth-date))))
  (is (eq t   (web4r::slot-nullable (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'zip-code))))
  (is (eq nil (web4r::slot-nullable (get-slot 'testdb1 'note))))
  (is (eq t   (web4r::slot-nullable (get-slot 'testdb1 'image)))))

(test slot-rows
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'zip-code))))
  (is (eq 5   (web4r::slot-rows (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-rows (get-slot 'testdb1 'image)))))

(test slot-cols
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'zip-code))))
  (is (eq 30  (web4r::slot-cols (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-cols (get-slot 'testdb1 'image)))))

(test slot-size
  (is (eq 30  (web4r::slot-size (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'zip-code))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-size (get-slot 'testdb1 'image)))))

(test slot-length
  (is (eq 50                (web4r::slot-length (get-slot 'testdb1 'name))))
  (is (equal '(8 12)        (web4r::slot-length (get-slot 'testdb1 'password))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'email))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'sex))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'marriage))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'hobbies))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'birth-date))))
  (is (eq 50                (web4r::slot-length (get-slot 'testdb1 'nickname))))
  (is (eq nil               (web4r::slot-length (get-slot 'testdb1 'phone-number))))
  (is (eq 5                 (web4r::slot-length (get-slot 'testdb1 'zip-code))))
  (is (eq 3000              (web4r::slot-length (get-slot 'testdb1 'note))))
  (is (equal '(1000 500000) (web4r::slot-length (get-slot 'testdb1 'image)))))

(test slot-hide
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'name))))
  (is (eq t   (web4r::slot-hide (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'email))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'sex))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'marriage))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'zip-code))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-hide (get-slot 'testdb1 'image)))))

(test slot-options
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'name))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'password))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'email))))
  (is (equal '("Male" "Female")
                 (web4r::slot-options (get-slot 'testdb1 'sex))))
  (is (equal '("single" "married" "divorced")
                 (web4r::slot-options (get-slot 'testdb1 'marriage))))
  (is (equal '("sports" "music" "reading")
                 (web4r::slot-options (get-slot 'testdb1 'hobbies))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'birth-date))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'nickname))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'phone-number))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'zip-code))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'note))))
  (is (eq nil (web4r::slot-options (get-slot 'testdb1 'image)))))

(test slot-input
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'name))))
  (is (eq :password (web4r::slot-input (get-slot 'testdb1 'password))))
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'email))))
  (is (eq :radio    (web4r::slot-input (get-slot 'testdb1 'sex))))
  (is (eq :select   (web4r::slot-input (get-slot 'testdb1 'marriage))))
  (is (eq :checkbox (web4r::slot-input (get-slot 'testdb1 'hobbies))))
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'birth-date))))
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'nickname))))
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'phone-number))))
  (is (eq nil       (web4r::slot-input (get-slot 'testdb1 'zip-code))))
  (is (eq :textarea (web4r::slot-input (get-slot 'testdb1 'note))))
  (is (eq :file     (web4r::slot-input (get-slot 'testdb1 'image)))))

(test slot-type
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'name))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'password))))
  (is (eq :email   (web4r::slot-type (get-slot 'testdb1 'email))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'sex))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'marriage))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'hobbies))))
  (is (eq :date    (web4r::slot-type (get-slot 'testdb1 'birth-date))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'nickname))))
  (is (equal '(:regex "^\\d{3}-\\d{3}-\\d{4}$")
                      (web4r::slot-type (get-slot 'testdb1 'phone-number))))
  (is (eq :integer (web4r::slot-type (get-slot 'testdb1 'zip-code))))
  (is (eq nil      (web4r::slot-type (get-slot 'testdb1 'note))))
  (is (eq :image   (web4r::slot-type (get-slot 'testdb1 'image)))))

(defun safe= (html safe)
  (equal html
         (replace-str *nl* "" (slot-value safe 'web4r::content))))

(test slot-display-value
  (let ((i (make-instance 'testdb1
             :name         "Tomoyuki Matsumoto"
             :password     "password"
             :email        "tomo@example.com"
             :sex          "Male"
             :marriage     "single"
             :hobbies      '("sports" "reading")
             :birth-date   "1983-09-28"
             :nickname     "tomo"
             :phone-number "408-644-6198"
             :zip-code     "95129"
             :note         (concat "Hello" *nl* "World")
             :image        "test.gif")))
    (is (equal "Tomoyuki Matsumoto"
               (slot-display-value i (get-slot 'testdb1 'name))))
    (is (equal "password"
               (slot-display-value i (get-slot 'testdb1 'password))))
    (is (equal "tomo@example.com"
               (slot-display-value i (get-slot 'testdb1 'email))))
    (is (equal "Male"
               (slot-display-value i (get-slot 'testdb1 'sex))))
    (is (equal "single"
               (slot-display-value i (get-slot 'testdb1 'marriage))))
    (is (equal "sports, reading"
               (slot-display-value i (get-slot 'testdb1 'hobbies))))
    (is (equal "1983-09-28"
               (slot-display-value i (get-slot 'testdb1 'birth-date))))
    (is (equal "tomo"
               (slot-display-value i (get-slot 'testdb1 'nickname))))
    (is (equal "408-644-6198"
               (slot-display-value i (get-slot 'testdb1 'phone-number))))
    (is (equal "95129"
               (slot-display-value i (get-slot 'testdb1 'zip-code))))
    (is (equal (concat "Hello" *nl* "World")
               (slot-display-value i (get-slot 'testdb1 'note))))
    (is (safe= "Hello<br>World"
               (slot-display-value i (get-slot 'testdb1 'note) :nl->br t)))))

(test slot-save-value
  (let ((*request*
         (web4r::make-request
          :post-params
          '(("NAME" . "Tomoyuki Matsumoto")
            ("PASSWORD" . "password")
            ("EMAIL" . "tomo@tomo.com")
            ("SEX" . "Male")
            ("MARRIAGE" . "single")
            ("HOBBIES-sports" . "sports")
            ("HOBBIES-reading" . "reading")
            ("BIRTH-DATE-Y" . "1983")
            ("BIRTH-DATE-M" . "9")
            ("BIRTH-DATE-D" . "28")
            ("NICKNAME" . "tomo")
            ("PHONE-NUMBER" . "408-644-6198")
            ("ZIP-CODE" . "95129")
            ("NOTE" . "Hello
World")))))
    (is (equal "Tomoyuki Matsumoto"
               (slot-save-value (get-slot 'testdb1 'name))))
    (is (equal "password"
               (slot-save-value (get-slot 'testdb1 'password))))
    (is (equal "tomo@tomo.com"
               (slot-save-value (get-slot 'testdb1 'email))))
    (is (equal "Male"
               (slot-save-value (get-slot 'testdb1 'sex))))
    (is (equal "single"
               (slot-save-value (get-slot 'testdb1 'marriage))))
    (is (equal '("sports" "reading")
               (slot-save-value (get-slot 'testdb1 'hobbies))))
    (is (equal "1983-9-28"
               (slot-save-value (get-slot 'testdb1 'birth-date))))
    (is (equal "tomo"
               (slot-save-value (get-slot 'testdb1 'nickname))))
    (is (equal "408-644-6198"
               (slot-save-value (get-slot 'testdb1 'phone-number))))
    (is (equal "95129"
               (slot-save-value (get-slot 'testdb1 'zip-code))))
    (is (equal "Hello
World"         (slot-save-value (get-slot 'testdb1 'note))))
    ))

(test form-input
  (is-true (shtml= (form-input (get-slot 'testdb1 'name))
                   "<INPUT TYPE=\"text\" NAME=\"NAME\" ID=\"NAME\" SIZE=\"30\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'password))
                   "<INPUT TYPE=\"password\" NAME=\"PASSWORD\" ID=\"PASSWORD\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'email))
                   "<INPUT TYPE=\"text\" NAME=\"EMAIL\" ID=\"EMAIL\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'sex))
                   "<INPUT TYPE=\"radio\" VALUE=\"Male\" ID=\"Male\" NAME=\"SEX\">
<LABEL FOR=\"Male\">Male</LABEL>
<INPUT TYPE=\"radio\" VALUE=\"Female\" ID=\"Female\" NAME=\"SEX\">
<LABEL FOR=\"Female\">Female</LABEL>"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'marriage))
                   "<SELECT NAME=\"MARRIAGE\" ID=\"MARRIAGE\">
<OPTION VALUE=\"single\">single</OPTION>
<OPTION VALUE=\"married\">married</OPTION>
<OPTION VALUE=\"divorced\">divorced</OPTION>
</SELECT>"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'hobbies))
                   "<INPUT TYPE=\"checkbox\" VALUE=\"sports\" ID=\"HOBBIES-sports\" NAME=\"HOBBIES-sports\">
<LABEL FOR=\"sports\">sports</LABEL>
<INPUT TYPE=\"checkbox\" VALUE=\"music\" ID=\"HOBBIES-music\" NAME=\"HOBBIES-music\">
<LABEL FOR=\"music\">music</LABEL>
<INPUT TYPE=\"checkbox\" VALUE=\"reading\" ID=\"HOBBIES-reading\" NAME=\"HOBBIES-reading\">
<LABEL FOR=\"reading\">reading</LABEL>"))
  (is-true (equalp (shtml->html (select-date/ "BIRTH-DATE"))
                   (shtml->html (form-input (get-slot 'testdb1 'birth-date)))))
  (is-true (shtml= (form-input (get-slot 'testdb1 'nickname))
                   "<INPUT TYPE=\"text\" NAME=\"NICKNAME\" ID=\"NICKNAME\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'phone-number))
                   "<INPUT TYPE=\"text\" NAME=\"PHONE-NUMBER\" ID=\"PHONE-NUMBER\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'zip-code))
                   "<INPUT TYPE=\"text\" NAME=\"ZIP-CODE\" ID=\"ZIP-CODE\">"))
  (is-true (shtml= (form-input (get-slot 'testdb1 'note))
                   "<TEXTAREA NAME=\"NOTE\" ROWS=\"5\" COLS=\"30\" ID=\"NOTE\"></TEXTAREA>"))
  )