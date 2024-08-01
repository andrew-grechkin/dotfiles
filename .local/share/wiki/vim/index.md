# vim

Reload vim with different encoding
`:e ++enc=utf-8`

Use vim for file processing:

```bash
echo foo | EDITOR='vim +:s/foo/bar/ +wq' vipe | tail
```
