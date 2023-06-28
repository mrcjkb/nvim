(apply_expression
  function: (_
    function: (_
      function: (_) @_func
      (#match? @_func "(^|\\.)writeShellScriptBinWith$")
    )
  )
  argument: [
    (string_expression (string_fragment) @injection.content (#set! injection.language "nix"))
    (indented_string_expression (string_fragment) @injection.content (#set! injection.language "nix"))
  ] (#set! injection.combined))


;; The below queries will be upstreamed

;; (nixosTest) testScript
((binding
  ((attrpath) @_attr_name) 
    (#eq? _attr_name "nodes")
  )
  (binding
   ((attrpath) @_func_name) (#eq? @_func_name "testScript")
   (_
     (string_fragment) @injection.content (#set! injection.language "python")
   ))
   (#set! injection.combined))

;; home-manager Neovim plugin config
(attrset_expression
  (binding_set
    (binding
      (attrpath) @_ty_attr
      (_
        (string_fragment) @_ty
      )
      (#eq? @_ty_attr "type")
      (#eq? @_ty "lua"))
    (binding
      (attrpath) @_cfg_attr
      (_
        (string_fragment) @injection.content (#set! injection.language "lua")
      )
      (#eq? @_cfg_attr "config")
    ))
    (#set! injection.combined))
