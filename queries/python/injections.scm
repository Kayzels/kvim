; extends

(
  [
    (string_content)
  ] @injection.content
  (#match? @injection.content "\^w*SELECT|FROM|INNER JOIN|JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
  (#set! injection.language "sql")
)

(
  (assignment
    left: (identifier) @variable_name (#eq? @variable_name "DEFAULT_CSS")
    right: (string
      (string_content) @injection.content))
    (#set! injection.language "tcss")
)
