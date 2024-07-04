;; extends

;; nixosTest

(call
  function: (attribute
    object: (_)
    attribute: (identifier) @_func_name)
  arguments: (argument_list
    (string) @injection.content (#set! injection.language "bash"))
    (#any-of? @_func_name "wait_until_succeeds" "succeed"))
