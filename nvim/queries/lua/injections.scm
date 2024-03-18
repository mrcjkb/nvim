;; extends

; ((string ("string_content") @query) (#lua-match? @query "^%s*;;+%s?"))

;; TODO:
; ((comment 
;     content: (comment_content) @injection.language)
; . (expression_list
;         value: (string content: (string_content) @injection.content))
;   (#gsub! @injection.language "%-%-[[%s*([%w%p]+)%s*%]%]" "%1")
; )
