; extends

(
  [
    (string_content)
  ] @injection.content
  (#match? @injection.content "\^w*SELECT|FROM|INNER JOIN|JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
  (#set! injection.language "sql")
)
