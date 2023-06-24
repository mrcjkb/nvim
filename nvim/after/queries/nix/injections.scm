; Bash mkDerivation
(apply_expression 
  (select_expression (attrpath (identifier) @_func_name)
  (#eq? @_func_name "mkDerivation"))
  (attrset_expression
    (binding_set
      (binding 
        ((attrpath) @_path)
        (#any-of? @_path "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "checkPhase" "installPhase" "fixupPhase" "installCheckPhase" "distPhase")
        ((_
          (string_fragment) @bash
         )
        )
      )
    ) 
  )
)
;; writeShell* (at various levels)
(apply_expression 
  (apply_expression 
    (select_expression (attrpath (identifier) @_func_name)
    (#any-of? @_func_name "writeShellScriptBin" "writeShellApplication" "writeShellScriptBinWith"))
  )
    ((_
      (string_fragment) @bash
     )
    )
)

(apply_expression 
  (select_expression (attrpath (identifier) @_func_name)
  (#any-of? @_func_name "writeShellScriptBin" "writeShellApplication" "writeShellScriptBinWith"))
    ((_
      (string_fragment) @bash
     )
    )
)
(apply_expression 
  (apply_expression 
    (apply_expression 
      (select_expression (attrpath (identifier) @_func_name)
      (#any-of? @_func_name "writeShellScriptBin" "writeShellApplication" "writeShellScriptBinWith"))
    )
  )
    ((_
      (string_fragment) @bash
     )
    )
)

;; writeShell* (parenthesized, at various levels)
(apply_expression 
  (apply_expression 
    (select_expression (attrpath (identifier) @_func_name)
    (#any-of? @_func_name "writeShellScriptBin" "writeShellApplication" "writeShellScriptBinWith"))
  )
  (parenthesized_expression
    ((_
      (string_fragment) @bash
     )
    )
  )
)
(apply_expression 
  (apply_expression 
    (apply_expression 
      (select_expression (attrpath (identifier) @_func_name)
      (#any-of? @_func_name "writeShellScriptBin" "writeShellApplication" "writeShellScriptBinWith"))
    )
  )
  (parenthesized_expression
    ((_
      (string_fragment) @bash
     )
    )
  )
)

;; shellHooks
(binding
 ((attrpath) @_func_name) (#eq? @_func_name "shellHook")
 (_
   (string_fragment) @bash
 )
)

;; (nixosTest) testScript
(
  (binding
   ((attrpath) @_attr_name) 
    (#eq? _attr_name "nodes")
  )
  (binding
   ((attrpath) @_func_name) (#eq? @_func_name "testScript")
   (_
     (string_fragment) @python
   )
  )
)

;; home-manager Neovim plugin config
(attrset_expression
  (binding_set
    (binding
      (attrpath) @_ty_attr
      (_
        (string_fragment) @_ty
      )
      (#eq? @_ty_attr "type")
      (#eq? @_ty "lua")
    )
    (binding
      (attrpath) @_cfg_attr
      (_
        (string_fragment) @lua
      )
      (#eq? @_cfg_attr "config")
    )
  )
)
