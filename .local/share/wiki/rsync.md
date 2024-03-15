# list

```bash
# ssh
rsync user@host:

#rsync
rsync user@host::
```

# copy

```bash
# ssh
rsync user@host:some-dir ./

#rsync
rsync user@host::module/some-dir ./

#rsync using ssh auth and encryption
rsync --rsh=ssh user@host::module/some-dir ./
```
