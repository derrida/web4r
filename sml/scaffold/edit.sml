(with-sml-file (sml-path "template.sml")
  (append  head  [script :type "text/javascript" :src "/js/jquery-1.3.2.min.js"])
  (append  head  [script :type "text/javascript" :src "/js/jquery.validate.js"])
  (append  head  [script :type "text/javascript" :src "/js/jquery.date.js"])
  (append  head  [script :type "text/javascript" (safe 
"jQuery.validator.messages.remote = 'The save value is already in use.';
$(document).ready(function() {
    $('#" cname "_form').validate({
        errorPlacement: function(error, element) {
            error.appendTo( element.parent() )
        },
    })
"
(when (date-slots class)
  "    $(this).changeSelectDate();
")
"})")])
  (replace title [title (if oid "Editing " "New ") cname])
  (replace body  [body
                  (if (and oid (not ins))
                      [p "That page doesn't exist!"]
                      (progn
                        [h1 (if oid "Editing " "New ") cname]
                        (msgs)
                        (form-for/cont (funcall edit/cont*)
                          :class class :instance ins
                          :submit (if oid "Update" "Create"))))]))
