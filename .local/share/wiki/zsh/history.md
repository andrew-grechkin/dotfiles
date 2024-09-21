# History

## Expansion

### Event Designators

An event designator is a reference to a command line entry in the history list. Unless the reference is absolute, events are relative to the current position in the history list.

* `!`: Start a history substitution, except when followed by a blank, newline, carriage return, = or ( (when the extglob shell option  is  en‐ abled using the shopt builtin).
* `!n`: Refer to command line n.
* `!-n`: Refer to the current command minus n.
* `!!`: Refer to the previous command. This is a synonym for ‘!-1'.
* `!string`: Refer to the most recent command preceding the current position in the history list starting with string.
* `!?string[?]`: Refer to the most recent command preceding the current position in the history list containing string. The trailing ? may be omitted if string is followed immediately by a newline. If string is missing, the string from the most recent search is used; it is an error if there is no previous search string.
* `^string1^string2^`: Quick substitution. Repeat the previous command, replacing string1 with string2. Equivalent to '!!:s^string1^string2^' (see Modifiers below).
* `!#`: The entire command line typed so far.

### Word Designators

Word designators are used to select desired words from the event. A : separates the event specification from the word designator. It may be omitted if the word designator begins with a ^, $, *, -, or %. Words are numbered from the beginning of the line, with the first word being denoted by 0 (zero). Words are inserted into the current line separated by single spaces.

* `0` (zero): The zeroth word. For the shell, this is the command word.
* `n`: The nth word.
* `^`: The first argument. That is, word 1.
* `$`: The last word. This is usually the last argument, but will expand to the zeroth word if there is only one word in the line.
* `%`: The first word matched by the most recent ‘?string?' search, if the search string begins with a character that is part of a word.
* `x-y`: A range of words; ‘-y' abbreviates ‘0-y'.
* `*`: All of the words but the zeroth. This is a synonym for ‘1-$'. It is not an error to use * if there is just one word in the event; the empty string is returned in that case.
* `x*`: Abbreviates x-$.
* `x-`: Abbreviates x-$ like x*, but omits the last word. If x is missing, it defaults to 0.

If a word designator is supplied without an event specification, the previous command is used as the event.

### Modifiers

After the optional word designator, there may appear a sequence of one or more of the following modifiers, each preceded by a ‘:'. These modify, or edit, the word or words selected from the history event.

* `h`: Remove a trailing filename component, leaving only the head.
* `t`: Remove all leading filename components, leaving the tail.
* `r`: Remove a trailing suffix of the form .xxx, leaving the basename.
* `e`: Remove all but the trailing suffix.
* `p`: Print the new command but do not execute it.
* `q`: Quote the substituted words, escaping further substitutions.
* `x`: Quote the substituted words as with q, but break into words at blanks and newlines. The q and x modifiers are mutually exclusive; the last one supplied is used.
* `s/old/new/`: Substitute new for the first occurrence of old in the event line. Any character may be used as the delimiter in place of /. The final delimiter is optional if it is the last character of the event line. The delimiter may be quoted in old and new with a single backslash. If & appears in new, it is replaced by old. A single backslash will quote the &. If old is null, it is set to the last old substituted, or, if no previous history substitutions took place, the last string in a !?string[?] search. If new is null, each matching old is deleted.
* `&`: Repeat the previous substitution.
* `g`: Cause changes to be applied over the entire event line. This is used in conjunction with ‘:s' (e.g., ‘:gs/old/new/') or ‘:&'. If used with ‘:s', any delimiter can be used in place of /, and the final delimiter is optional if it is the last character of the event line. An a may be used as a synonym for g.
* `G`: Apply the following ‘s' or ‘&' modifier once to each word in the event line.

### Examples

```bash
$ history
1 tar cvf etc.tar.gz /etc/
2 cp /etc/passwd /backup
3 ps -ef | grep http
4 service sshd restart
5 /usr/local/apache2/bin/apachectl restart
6 ls /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
```

```bash
# previous command by absolute index
$ !4
service sshd restart
```

```bash
# previous command by relative index
$ !-3
service sshd restart
```

```bash
# previous command
$ !!
$ !-1
ls /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
```

```bash
# previous command (most recent) starting with keyword
$ !ps
ps -ef | grep http
```

```bash
# previous command (most recent) containing keyword
$ !?apache
/usr/local/apache2/bin/apachectl restart
```

```bash
# previous command (the last one) with replaced keyword
$ ^ls^cat^
cat /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
```

```bash
# first argument from previous command (most recent) by keyword
$ ls -l !cp:^
ls -l /etc/passwd
```

```bash
# first argument from previous command (the last one)
$ ls -l !!:^
$ ls -l !^
ls -l /etc/cron.daily/logrotate
```

```bash
# last argument from previous command (most recent) by keyword
$ ls -l !cp:$
ls -l /backup
```

```bash
# last argument from previous command (the last one)
$ ls -l !!:$
$ ls -l !$
ls -l /etc/cron.hourly/logrotate
```

```bash
# argument by index from previous command (most recent) by keyword
$ ls -l !tar:2
ls -l etc.tar.gz
```

```bash
# all arguments from previous command (most recent) by keyword
$ ls -l !cp:*
ls -l /etc/passwd /backup
```

```bash
# all arguments from previous command (the last one)
$ ls -l !!:*
$ ls -l !*
ls -l /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
```

```bash
# refer recently used search keyword
$ !?apache
/usr/local/apache2/bin/apachectl restart

$ !% stop
/usr/local/apache2/bin/apachectl stop
```

```bash
# modify path and remove trailing element
$ ls -l !$:h
ls -l /etc/cron.hourly

# modify path and keep only trailing element
$ ls -l !$:t
ls -l logrotate

# modify path and remove extension
$ ls -l !tar:2:r
ls -l etc.tar
```

```bash
# sed-like substitute
$ !service:s/sshd/opensshd/
service opensshd restart
```
