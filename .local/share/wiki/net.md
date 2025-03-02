# netcat ssh relay

```bash
    mkfifo backpipe
    nc -lvvp 2222 0<backpipe | nc ssh-target-host 22 1>backpipe
```
