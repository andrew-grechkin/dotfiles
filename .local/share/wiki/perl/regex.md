# Regex

[perlcharclass](https://perldoc.perl.org/perlrecharclass)
[Test regex](https://regex101.com/)
[Learn regex](https://regexr.com/)
[Tutorial](https://www.regular-expressions.info)

## groups and ranges
* .             - any character except newline
* [ ]           - any single character of set
* [^ ]          - any single character NOT of set
* |             - alternation
* [a-z]         - character range
* ()            - capturing group
* (?<name>)     - named capturing group
* (?:)          - non-capturing group
* (?>)          - nested anchored sub-regexp, stops backtracking (atomic group)
* (?#)          - comment
* (?imx-imx)    - turns on/off imx options for rest of regexp.
* (?imx-imx:re) - turns on/off imx options, localized in group.

## back reference
* \1-9          - nth previous captured group
* \g{name}      - match named or numbered group
* \`            - pre-match (before matched string)
* \'            - post-match (after matched string)
* \+            - highest group matched
* \&            - whole match
* \_            - entire input string

## quantifiers
* *             - 0 or more previous regular expression
* *?            - 0 or more previous regular expression (non-greedy)
* +             - 1 or more previous regular expression
* +?            - 1 or more previous regular expression (non-greedy)
* ?             - 0 or 1 previous regular expression
* {m}           - exactly m previous regular expression
* {m,}          - at least m previous regular expression
* {m,}?         - at least m previous regular expression (non-greedy)
* {m,n}         - at least m but most n previous regular expression
* {m,n}?        - at least m but most n previous regular expression (non-greedy)

## escape
* \             - escape character
* \0            - null character
* \E            - end literal sequence
* \N{name}      - named character
* \Q            - begin literal sequence
* \a            - alarm
* \b            - backspace (0x08) (inside [] only)
* \e            - escape
* \f            - form feed
* \n            - newline
* \r            - carriage return
* \t            - tab
* \v            - vertical tab

## anchors
* ^             - beginning of a string or line (for /m)
* \A            - beginning of a string
* $             - end of a string or line (for /m)
* \Z            - end of a string, or before newline at the end
* \z            - end of a string
* \b            - word boundary (outside [] only)
* \B            - non-word boundary
* \<            - start of word
* \>            - end of word

## character classes
* \D            - non-digit
* \O            - octal digit
* \S            - non-whitespace character
* \H            - not horizontal-whitespace character
* \V            - not vertical-whitespace character
* \N            - not a new line
* \W            - non-word character
* \c            - control character
* \d            - digit, same as[0-9]
* \s            - whitespace character[ \t\n\r\f]
* \h            - horizontal whitespace character
* \v            - vertical whitespace character
* \w            - word character[0-9A-Za-z_]
* \x            - hexadecimal digit
* \p{Prop}      - a character that has the given Unicode property.
* \P{Prop}      - a character that doesn't have the Unicode property
* \xhh          - hexadecimal character hh
* \Oooo         - octal character ooo

## special character classes
* [:alnum:]     - alpha-numeric characters
* [:alpha:]     - alphabetic characters
* [:blank:]     - whitespace - does not include tabs, carriage returns, etc
* [:cntrl:]     - control characters
* [:digit:]     - decimal digits
* [:graph:]     - graph characters
* [:lower:]     - lower case characters
* [:print:]     - printable characters
* [:punct:]     - punctuation characters
* [:space:]     - whitespace, including tabs, carriage returns, etc
* [:upper:]     - upper case characters
* [:word:]      - same as \w
* [:xdigit:]    - hexadecimal digits

## assertions
* (?=)          - zero-width positive look-ahead assertion
* (?!)          - zero-width negative look-ahead assertion
* (?<=)         - zero-width positive look-behind
* (?<!)         - zero-width negative look-behind
* (?())         - condition (if then)
* (?()|)        - condition (if then else)

## options
* /U            - non-greedy patterns
* /[neus]       - encoding: none, EUC, UTF-8, SJIS, respectively
* /e            - evaluate replacements
* /g            - global match
* /i            - case insensitive
* /m            - multiline mode - '.' will match newline
* /o            - only interpolate #{} blocks once
* /s            - treat string as single line
* /x            - extended mode - whitespace is ignored, comments allowed
