; Copied from https://github.com/jasonyukr/tree-sitter-zsh/blob/00f0e37e089d29b8e0c6b703919aacc6d88bc7f1/queries/locals.scm
[
  (source_file)
  (block)
  (subshell)
  (function_definition)
] @local.scope

(function_definition
  name: (command_name) @local.definition.function)

(assignment
  name: (variable_name) @local.definition.var)

(for_statement
  variable: (variable_name) @local.definition.var)

(select_statement
  variable: (variable_name) @local.definition.var)

(foreach_statement
  variable: (variable_name) @local.definition.var)

(variable_expansion
  (variable_name) @local.reference)

(parameter_expansion
  (variable_name) @local.reference)

(parameter_expansion
  parameter: (variable_name) @local.reference)
