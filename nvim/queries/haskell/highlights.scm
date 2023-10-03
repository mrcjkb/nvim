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
    . (variable) @exception
  ) 
  (#eq? @_mod "Log")
  (#eq? @exception "e")
) 

((variable) @exception
  (#any-of? @exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  ))

