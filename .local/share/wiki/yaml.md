# YAML cheatsheet

## Links

- [Initial source of this doc](https://github.com/lwindolf/lzone-cheat-sheets/blob/master/cheat-sheet/Languages/YAML.md)
- [YAML 1.2 Spec](http://www.yaml.org/spec/1.2/spec.html)
- [Online YAML Linter (Ruby)](http://www.yamllint.com/)
- [Online YAML Parser (Python)](http://yaml-online-parser.appspot.com/)
- [kwalify - YAML schema validator (Ruby)](http://www.kuwata-lab.com/kwalify/)
- [To quote or not to quote](http://blogs.perl.org/users/tinita/2018/03/strings-in-yaml---to-quote-or-not-to-quote.html)

## Syntax examples

```yaml
---
integer: 3
float1: 3.1415
float2: 3.1415e+2
string: string
bool1: false
bool2: true
date: 2022-02-02
undef1: ~
undef2: null
# enforcing strings
a: '2015-04-05'
b: "2015-04-05"
c: !str 2015-04-05
array:
  - 132
  - 2.434
  - abc
'array with JSON syntax': [42, '42']
'array of arrays 1':
  -
    - 1
    - 2
    - 3
  -
    - 4
    - 5
    - 6
'array of arrays 2':
  - [1, 2, 3]
  - [4, 5, 6]
'hash':
  subkey:
    subsubkey1: 5
    subsubkey2: 6
  another:
    'something else': Important!
  'in JSON syntax': {nr1: 5, nr2: 6}
```

### Multiple documents

```yaml
---
content: doc1
---
content: doc2
```

### Heredoc [multiline strings](https://yaml-multiline.info/)

_block notation_: newlines become spaces

```yaml
content:
  Arbitrary free text
  over multiple lines stopping only
  after the indentation changes...
```

_folded style_: replace single newlines with spaces

```yaml
content: >
  Arbitrary free text
  over "multiple lines" stopping after indentation changes...

  new line here and at the end are preserved
```

_literal style_: all newlines are preserved

```yaml
content: |
  Arbitrary free text
  over "multiple lines" stopping
  after indentation changes...
```

_no indicator (clip)_: one new line at the end

```yaml
content: >
  Arbitrary free text, only one newline will be at the end


```

_- indicator (strip)_: remove all newlines at the end

```yaml
content: |-
  Arbitrary free text, newlines after it are not preserved


```

_+ indicator (keep)_: save all newlines at the end

```yaml
content: |+
  Arbitrary free text with all newlines preserved after block


```

**Note** that YAML heredocs are the way to escape special characters:

```yaml
code:                          # sub key "url" with value 'https://...'
   url: "https://example.com"

code: |-                       # versus key "code" having value 'url: "https://..."'
   url: "https://example.com"
```

There is a good online previewer for the different heredoc modes: https://yaml-multiline.info/

### Content References (Aliases)

```yaml
---
values:
  - &ref Something to reuse
  - *ref  # Literal "Something to reuse" is inserted here!
```

### Merging Keys

```yaml
# some default properties for a hash
default_settings:
  install:
    dir: /usr/local
    owner: root
  config:
    enabled: false

# Derive settings for 'my_app' from default and change install::owner
# and add further setting "group: my_group"

my_app_settings:
  <<: *default_settings
  install:
    owner: my_user
    group: my_group
```

### Complex mapping


```yaml
# helps if your key is a special char:
'complex key': value

? complex key 2
: value
```

**Note**: key and value can be multiple, complex structures that you could not realize with the hash syntax!

For languages supporting key as complex structures:

```yaml
mapping:
  # Use a sequence as a key
  ? - foo
    - bar
  : 1

  # Use a mapping as a key
  ? baz: qux
  : 2

  # You can skip the value, which implies `null`
  ? quux

  # You can leave the key blank, which implies a `null` key
  ?
  : 3

  # You can even skip both the key and value, so both will be `null`
  ?

  # Or you can use a preposterously long scalar as a key
  ? |
    We the People of the United States, in Order to form a more
    perfect Union, establish Justice, insure domestic Tranquility,
    provide for the common defence, promote the general Welfare,
    and secure the Blessings of Liberty to ourselves and our
    Posterity, do ordain and establish this Constitution for the
    United States of America.
  : 3

  # Or just be ridiculous
  ? - foo: bar
      baz:
      - { qux: quux }
    - stahp
  : 4
```

In Ruby this would yield the following delightful hash:
```ruby
{
  "mapping" => {
    [ "foo", "bar" ]   => 1,
    { "baz" => "qux" } => 2,
    "quux"             => nil,
    nil                => nil,
    "We the People of the United States, in Order to form a more\nperfect Union, establish Justice, insure domestic Tranquility,\nprovide for the common defence, promote the general Welfare,\nand secure the Blessings of Liberty to ourselves and our\nPosterity, do ordain and establish this Constitution for the\nUnited States of America.\n" => 3
    [ { "foo" => "bar", "baz" => [ { "qux" => "quux" } ] }, "stahp" ] => 4
  }
}
```
