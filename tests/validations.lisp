(in-package :web4r-tests)
(in-suite web4r)

(defvar *label* "label")

(test length
  (is (eq    (validation-errors *label* "123456789" '(:length 20)) nil))
  (is (eq    (validation-errors *label* "12345" '(:length (3 10))) nil))
  (is (equal (validation-errors *label* "123456789" '(:length 3))
             (list (web4r::get-error-msg :too-long *label* 3))))
  (is (equal (validation-errors *label* "123" '(:length (5 8)))
             (list (web4r::get-error-msg :too-short *label* 5))))
  (is (equal (validation-errors *label* "1234567890" '(:length (3 5)))
             (list (web4r::get-error-msg :too-long *label* 5))))
  (is (eq (validation-errors *label* (list (cons "size" 100)) '(:length 300)) nil))
  (is (eq (validation-errors *label* (list (cons "size" 80)) '(:length (50 100))) nil))
  (is (equal (validation-errors *label* (list (cons "size" 100)) '(:length 50))
             (list (web4r::get-error-msg :too-big *label* 50))))
  (is (equal (validation-errors *label* (list (cons "size" 30)) '(:length (50 100)))
             (list (web4r::get-error-msg :too-small *label* 50))))
  (is (equal (validation-errors *label* (list (cons "size" 110)) '(:length (50 100)))
               (list (web4r::get-error-msg :too-big *label* 100)))))

(test type
  (is (equal (validation-errors *label* "n" '(:type (:member ("a" "i" "u"))))
              (list (web4r::get-error-msg :invalid *label*))))
  (is (eq    (validation-errors *label* "i" '(:type (:member ("a" "i" "u")))) nil))
  (is (eq    (validation-errors *label* '("1983" "9" "28") '(:type :date)) nil))
  (is (equal (validation-errors *label* '("19830" "9" "28") '(:type :date))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (equal (validation-errors *label* '("1983" "13" "28") '(:type :date))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (equal (validation-errors *label* '("1983" "9" "32") '(:type :date))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (eq (validation-errors *label* "ABCDEFGhijkl" '(:type :alpha)) nil))
  (is (equal (validation-errors *label* "aiueo1" '(:type :alpha))
             (list (web4r::get-error-msg :not-alpha *label*))))
  (is (equal (validation-errors *label* "1aiueo" '(:type :alpha))
             (list (web4r::get-error-msg :not-alpha *label*))))
  (is (equal (validation-errors *label* "ai1ueo" '(:type :alpha))
             (list (web4r::get-error-msg :not-alpha *label*))))
  (is (eq    (validation-errors *label* "aiueo1" '(:type :alnum))
             nil))
  (is (equal (validation-errors *label* "ai@ueo" '(:type :alnum))
             (list (web4r::get-error-msg :not-alnum *label*))))
  (is (equal (validation-errors *label* "!aiueo" '(:type :alnum))
             (list (web4r::get-error-msg :not-alnum *label*))))
  (is (equal (validation-errors *label* "aiueo-" '(:type :alnum))
             (list (web4r::get-error-msg :not-alnum *label*))))
  (is (eq    (validation-errors *label* "1234567890" '(:type :integer))
             nil))
  (is (equal (validation-errors *label* "1234a56789" '(:type :integer))
             (list (web4r::get-error-msg :not-a-number *label*))))
  (is (equal (validation-errors *label* "a123456789" '(:type :integer))
             (list (web4r::get-error-msg :not-a-number *label*))))
  (is (equal (validation-errors *label* "123456789a" '(:type :integer))
             (list (web4r::get-error-msg :not-a-number *label*))))

  (is (eq    (validation-errors *label* "test@test.com" '(:type :email))
             nil))
  (is (equal (validation-errors *label* "invalidmail" '(:type :email))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (eq    (validation-errors *label* "408-644-1234"
                                '(:type (:regex "^\\d{3}-\\d{3}-\\d{4}$")))
             nil))
  (is (equal (validation-errors *label* "408-644-12340"
                                '(:type (:regex "^\\d{3}-\\d{3}-\\d{4}$")))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (equal (validation-errors *label* "408-6440-1234"
                                '(:type (:regex "^\\d{3}-\\d{3}-\\d{4}$")))
             (list (web4r::get-error-msg :invalid *label*))))
  (is (equal (validation-errors *label* "4080-644-1234"
                                '(:type (:regex "^\\d{3}-\\d{3}-\\d{4}$")))
             (list (web4r::get-error-msg :invalid *label*)))))

(test nullable
  (eq    (validation-errors *label* " " '(:nullable nil)) nil)
  (equal (validation-errors *label* "" '(:nullable nil))
         (list (web4r::get-error-msg :empty *label*)))
  (eq    (validation-errors *label* (list (cons "size" 1)) '(:nullable nil))
         nil)
  (equal (validation-errors *label* (list (cons "size" 0)) '(:nullable nil))
         (list (web4r::get-error-msg :empty *label*))))

(test with-validations
  (is (equal (with-validations (("1" "v" '(:nullable nil))
                                ("2" "v" '(:nullable nil)))
               (lambda (e) e)
               "ok")
             "ok"))
  (is (equal (with-validations (("1" "v" '(:nullable nil))
                                ("2" nil '(:nullable nil)))
               (lambda (e) e)
               "ok")
             (list (web4r::get-error-msg :empty "2"))))
  (is (equal (with-validations (("1" nil '(:nullable nil))
                                ("2" nil '(:nullable nil)))
               (lambda (e) e)
               "ok")
             (list (web4r::get-error-msg :empty "1")
                   (web4r::get-error-msg :empty "2")))))
