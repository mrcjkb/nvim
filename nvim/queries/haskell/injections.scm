;; extends

; quasiquoted sql
;; (quasiquote
;;   (quoter) @_name 
;;   (#eq? @_name "sql")
;;   ((quasiquote_body) @sql)
;; )
; quasiquoted sql (any quasiqutoe)
; (exp_apply
;   (exp_name
;     (qualified_variable
;       (((variable) @_func_name)(#any-of? @_func_name "query" "query_" "queryWith" "queryWith_" "execute" "execute_" "executeMany"))
;     )
;   )
;   (exp_name) ;; the Connecton
;   (quasiquote
;     ((quasiquote_body) @sql)
;   )
; )
; (exp_apply
;   (exp_name
;     (((variable) @_func_name)(#any-of? @_func_name "query" "query_" "queryWith" "queryWith_" "execute" "execute_" "executeMany"))
;   )
;   (exp_name) ;; the Connection
;   (quasiquote
;     ((quasiquote_body) @sql)
;   )
; )
; Qualified function that returns a Query
; (
;  (signature
;    (_
;     ((qualified_type (type) @type_name)(#eq? @type_name "Query"))
;    )
;  )
;  (function
;    (_
;     (quasiquote_body) @sql
;    )
;  )
; )

; Unqualified function that returns a Query
; (
;  (signature
;    (_
;     ((type) @type_name)(#eq? @type_name "Query")
;    )
;  )
;  (function
;    (_
;     (quasiquote_body) @sql
;    )
;  )
; )
;
