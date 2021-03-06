(with-sml-file (sml-path "template.sml")
  (append  head  [script :type "text/javascript" :src "/js/jquery-1.3.2.min.js"])
  (append  head  [script :type "text/javascript" :src "/js/jquery.validate.js"])
  (append  head  [script :type "text/javascript" (safe 
"$.validator.addMethod('remote', function(value, element) {return true;}, '');
$(document).ready(function() {
    $('#user_form').validate({
        errorPlacement: function(error, element) {
            error.appendTo( element.parent() )
        },
    })
})")])
  (replace title [title "login page"])
  (replace body  [body
                  [h1 "Login"]
                  (msgs)
                  (form-for/cont (login/cont redirect-uri)
                    :class 'user :submit "login")
                  [a :href (page-uri "regist") "Sign up"]]))
