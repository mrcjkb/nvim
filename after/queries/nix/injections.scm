; Bash mkDerivation (multi-line string)
(apply_expression 
  (select_expression (attrpath (identifier) @_func_name) (#eq? @_func_name "mkDerivation"))
  (attrset_expression
    (binding_set
      (binding 
        ((attrpath) @_path) (#any-of? @_path "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "checkPhase" "installPhase" "fixupPhase" "installCheckPhase" "distPhase")
        ((indented_string_expression) @bash)
      )
    ) 
  )
)
; Bash mkDerivation (single string)
(apply_expression 
  (select_expression (attrpath (identifier) @_func_name) (#eq? @_func_name "mkDerivation"))
  (attrset_expression
    (binding_set
      (binding 
        ((attrpath) @_path) (#any-of? @_path "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "checkPhase" "installPhase" "fixupPhase" "installCheckPhase" "distPhase")
        ((string_expression) @bash)
      )
    ) 
  )
)
;; writeShellScripBin  
(apply_expression 
  (apply_expression 
    (select_expression (attrpath (identifier) @_func_name) (#any-of? @_func_name "writeShellScripBin" "writeShellApplication" "writeShellScriptBinWith"))
  )
  ((indented_string_expression) @bash)
)
(apply_expression 
  (select_expression (attrpath (identifier) @_func_name) (#any-of? @_func_name "writeShellScripBin" "writeShellApplication" "writeShellScriptBinWith"))
  ((indented_string_expression) @bash)
)
;; writeShellScripBin (parenthesized)
(apply_expression 
  (apply_expression 
    (select_expression (attrpath (identifier) @_func_name) (#any-of? @_func_name "writeShellScripBin" "writeShellApplication" "writeShellScriptBinWith"))
  )
  (parenthesized_expression
  ((indented_string_expression) @bash)
  )
)
;; writeShellApplication | writeShellScriptBinWith
(apply_expression 
  (apply_expression 
    (apply_expression 
      (select_expression (attrpath (identifier) @_func_name) (#any-of? @_func_name "writeShellScripBin" "writeShellApplication" "writeShellScriptBinWith"))
    )
  )
  ((indented_string_expression) @bash)
)
;; writeShellApplication | writeShellScriptBinWith (parenthesized)
(apply_expression 
  (apply_expression 
    (apply_expression 
      (select_expression (attrpath (identifier) @_func_name) (#any-of? @_func_name "writeShellScripBin" "writeShellApplication" "writeShellScriptBinWith"))
    )
  )
  (parenthesized_expression
  ((indented_string_expression) @bash)
  )
)

;; shellHooks
(binding
 ((attrpath) @_func_name) (#eq? @_func_name "shellHook")
 (_
   (string_fragment) @bash
 )
)
