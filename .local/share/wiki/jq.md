## Parsing TSV example

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

jq -n -R "$JQ_SCRIPT" <<"INPUT_DATA_END"
name	age	pets
Tom	12	cats
Tim	15	cats,dogs
Joe	11	rabbits,birds
INPUT_DATA_END
```
