;; extends

(quasiquote
  (_
    (module) @_mod
    . (variable) @_name
  ) 
  (#eq? @_mod "Log")
  (#any-of? @_name "t" "d" "i" "w" "e")
  (quasiquote_body) @string
) 
(quasiquote
  (_
    (module) @_mod
    . (variable) @keyword.exception
  ) 
  (#eq? @_mod "Log")
  (#eq? @keyword.exception "e")
) 

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  ))

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  ))

