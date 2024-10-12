## Parsing TSV example

- parse TSV file with headers to JSON array of hashes manually providing keys

```bash
JQ_SCRIPT=$(cat <<"SCRIPT_END"
[inputs | split("\t")]
	| .[0] as $header
	| .[1:] | map({
		($header|.[0]): .[0],
		($header|.[1]): .[1],
		($header|.[2]): (.[2] | split(","))
	})
SCRIPT_END
)

- parse TSV file with headers to a JSON array of hashes detecting keys by header

```bash
JQ_SCRIPT=$(cat <<"SCRIPT_END"
[ inputs | split("\t") ]
	| .[0] as $keys
	| .[1:] | map(
		. as $row | reduce $row[] as $value ({}; . + {($keys[. | length]): $value})
	)
SCRIPT_END
```

```bash
jq -n -R "$JQ_SCRIPT" <<"INPUT_DATA_END"
name	age	pets
Tom	12	cats
Tim	15	cats,dogs
Joe	11	rabbits,birds
INPUT_DATA_END
```

```bash
# export environment variables from JSON object keys
# (e.g. $FOO from jq query ".foo")
export $(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')
```
