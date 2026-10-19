[
  (ui_object_initializer)
  (statement_block)
  (if_statement)
] @indent.begin

(statement_block "}" @indent.branch @indent.end)
(ui_object_initializer "}" @indent.branch @indent.end)

(else_clause "else") @indent.branch
(else_clause [(statement_block) (if_statement)] @indent.dedent)
(else_clause (if_statement consequence: (statement_block) @indent.dedent))

(if_statement
  consequence: (_) @indent.dedent
  (#not-kind-eq? @indent.dedent statement_block))

(statement_block
  (if_statement) . (ERROR "else") @indent.begin)

