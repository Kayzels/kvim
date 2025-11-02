(comment) @comment @spell
(line_comment) @comment @spell

(tag_name) @tag

">" @operator

((property_name) @variable
  (#match? @variable "^--"))
((plain_value) @variable
  (#match? @variable "^--"))

(class_name) @type
(id_name) @constant
(property_name) @property

(pseudo_class_selector (class_name) @attribute)

(function_name) @function

(important) @keyword.modifier;

(color_value) @string.special

(integer_value) @number
(float_value) @number
(unit) @type

"$" @character.special
(variable (identifier) @constant)

[
  (nesting_selector)
  (universal_selector)
] @character.special

[
  "#"
  ","
  "."
  ":"
  ";"
] @punctuation.delimiter

[
  "{"
  ")"
  "("
  "}"
] @punctuation.bracket
