# https://gist.github.com/DNA/ebb9258089e9e1dfd08c58695b3cd6f1

```
"WTF IS \033[30;47m???", a practical cheat-sheet

Font color definitions can be intimidating and nonsense at first,
but it is quite easy, lets just follow character by character:

   ┌────────┤\033├── Escape character (ESC)
   │┌───────┤ [  ├── Define a sequence (many characters in a code)
   ││
   ││┌──────┤ X  ├── Parameter (optional)  ┐
   │││┌─────┤ ;  ├── Parameter separator   │ SGR Code
   ││││┌────┤ Y  ├── Parameter (optional)  │ "Select Graphic Rendition"
   │││││┌───┤ m  ├── SGR Code              ┘
   ││││││
   ││││││   ┌───────────┬───────────┐  ┌─────────────────────┐
\033[X;Ym   │  Normal   │  Bright   │  │ Styles              │
            ├─────┬─────┼─────┬─────┤  ├───┬─────────────────┤
            │  FG │  BG │  FG │  BG │  │ 0 │ Reset / Normal  │
  ┌─────────┼─────┼─────┼─────┼─────┤  │ 1 │ Bold            │
  │ Black   │  30 │  40 │  90 │ 100 │  │ 2 │ Darker color    │
  │ Red     │  31 │  41 │  91 │ 101 │  │ 3 │ Italic          │
  │ Green   │  32 │  42 │  92 │ 102 │  │ 4 │ Underline       │
  │ Yellow  │  33 │  43 │  93 │ 103 │  │ 5 │ Blinking (slow) │
  │ Blue    │  34 │  44 │  94 │ 104 │  │ 6 │ Blinking (fast) │
  │ Magenta │  35 │  45 │  95 │ 105 │  │ 7 │ Reverse         │
  │ Cyan    │  36 │  46 │  96 │ 106 │  │ 8 │ Hide            │
  │ White   │  37 │  47 │  97 │ 107 │  │ 9 │ Cross-out       │
  └─────────┴─────┴─────┴─────┴─────┘  └───┴─────────────────┘
  ┌──────────────────────────────────────────────────────────┐
  │ EXAMPLES                                                 │
  ├──────────────┬───────────────────────────────────────────┤
  │ Code         │ Description                               │
  ├──────────────┼───────────────────────────────────────────┤
  │ \033[30;47m  │ Black letters on White background         │
  │ \033[31m     │ Red letter                                │
  │ \033[1;2;94m │ Bold, Italic font with Bright Blue color  │
  │ \033[0m      │ Reset everything                          │
  └──────────────┴───────────────────────────────────────────┘
  ```
