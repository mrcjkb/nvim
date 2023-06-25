(apply_expression
  function: (_
    function: (_
      function: (_) @_func
      (#match? @_func "(^|\\.)writeShellScriptBinWith$")
    )
  )
  argument: [
    (string_expression (string_fragment) @bash)
    (indented_string_expression (string_fragment) @bash)
  ])
  @combined
