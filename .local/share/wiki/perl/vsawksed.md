# vs AWK and SED

```bash
curl -s https://www.archlinux.org/download/ | perl -nlE '/Current Release/ && (say /([[:digit:].]+)/x) && exit'
curl -s https://www.archlinux.org/download/ | awk '/Current Release/,/Current Release/ {match($0, /[[:digit:].]+/, m); print m[0]}'
curl -s https://www.archlinux.org/download/ | awk '/Current Release/ {match($0, /[[:digit:].]+/, m); print m[0]; exit}'
curl -s https://www.archlinux.org/download/ | sed -n '/Current Release/ {s/[^[:digit:]]*\([[:digit:].]\+\).*/\1/p; q}'
```

```bash
/usr/bin/lsblk -lp | perl -aE '$F[5] =~ m/part/ && say $F[0], " (", $F[3], ")"'
/usr/bin/lsblk -lp | awk '$6 ~ /part/ && NF < 7 {print $1, "(" $4 ")"}'
```
