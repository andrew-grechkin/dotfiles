## Links

(tsv-utils)[https://github.com/eBay/tsv-utils]
(tips and tricks)[https://github.com/eBay/tsv-utils/blob/master/docs/TipsAndTricks.md]

## Utils

### Formatting

```bash
$ column -t -s$'\t' records.tsv
Name      Age  Address
Paul      23   Berlin
Emily     32   Copenhagen
Aliyah    27   Hamburg
John Doe  42   Universe
```

### Extracting columns

```bash
$ cut -f 3 records.tsv
Address
Berlin
Copenhagen
Hamburg
Universe
```

### Sorting

```bash
$ sort -n -t$'\t' -k2 records.tsv | column -t -s$'\t'
Name      Age  Address
Paul      23   Berlin
Aliyah    27   Hamburg
Emily     32   Copenhagen
John Doe  42   Universe
```
