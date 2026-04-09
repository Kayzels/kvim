[
  (ui_object_initializer)
  (statement_block)
] @indent.begin

(statement_block "}" @indent.branch @indent.end)
(ui_object_initializer "}" @indent.branch @indent.end)

(else_clause) @indent.branch

(statement_block
  (if_statement) . (ERROR "else") @indent.begin)

(if_statement
  consequence: (_) @indent.dedent
  (#not-has-parent? @indent.begin "else_clause")
  (#not-kind-eq? @indent.dedent "statement_block")) @indent.begin

