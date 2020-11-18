[ ("if") ("then") ("else") ("assert") ("with") ("let") ("in") ("rec") ("inherit") ] @keyword
("or") @keyword.operator
(comment) @comment
[ (string) (indented_string) ] @string
[ (path) (spath) (uri) ] @string.special
(identifier) @variable
((identifier) @_i (#match? @_i "^(builtins|baseNameOf|dirOf|fetchTarball|map|removeAttrs|toString)$")) @variable.builtin
(select ((identifier) @_i (#eq? @_i "builtins")) (attrpath (identifier) @variable.builtin)) @variable.builtin
((identifier) @_i (#eq? @_i "import")) @include
((identifier) @_i (#match? @_i "^(abort|derivation|throw)$")) @variable.builtin
((identifier) @_i (#match? @_i "^(true|false)$")) @boolean
(interpolation "${" @punctuation.special (_) "}" @punctuation.special) @none
[(unary "-" (integer)) (integer)] @number
[(unary "-" (float)) (float)] @float
