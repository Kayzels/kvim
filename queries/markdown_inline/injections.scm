;; extends

; ((code_span) @injection.content
;   (#match? @injection.content "^`\\{html\\}[^`]")
;   (#offset! @injection.content 0 6 0 -1)
;   (#set! injection.language "html"))

; HTML
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{html%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{html%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "html"))

; Javascript
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{javascript%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{javascript%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "javascript"))

((code_span) @injection.content
  (#lua-match? @injection.content "^`%{js%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{js%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "javascript"))

; Typescript
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{typescript%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{typescript%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "typescript"))

((code_span) @injection.content
  (#lua-match? @injection.content "^`%{ts%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{ts%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "typescript"))

; Lua
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{lua%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{lua%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "lua"))

; Python
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{python%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{python%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "python"))

; Css
((code_span) @injection.content
  (#lua-match? @injection.content "^`%{css%}[^`]")
  (#gsub! @injection.content "^`" "")
  (#gsub! @injection.content "^%{css%}" "")
  (#gsub! @injection.content "`$" "")
  (#set! injection.language "css"))
