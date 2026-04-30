# Common jq utilities - must be explicitly included with: include "common";

# TEST: ../../t/jq/group_by_key
# echo '[{"t":"a"},{"t":"b"}]' | jq 'include "common"; group_by_key(.t)'
# => {"a":[{"t":"a"}],"b":[{"t":"b"}]}
def group_by_key(f):
  reduce .[] as $it ({}; .[$it | f | tostring] += [$it]);

# TEST: ../../t/jq/get_in
# echo '{"a":{"b":1}}' | jq 'include "common"; get_in(["a","b"])'
# => 1
def get_in(path): getpath(path // []);

# TEST: ../../t/jq/compact
# echo '[1,null,2]' | jq 'include "common"; compact'
# => [1,2]
def compact: map(values);

# TEST: ../../t/jq/select_present
# echo '[1,null,false,"",0,[],{}]' | jq 'include "common"; select_present'
# => [1,0]
def select_present: map(select(. and . != "" and . != [] and . != {}));

# TEST: ../../t/jq/deep_merge
# echo '{"a":1}' | jq 'include "common"; deep_merge({"b":2})'
# => {"a":1,"b":2}
def deep_merge(other):
  . as $in
  | other as $other
  | reduce ($other | keys_unsorted[]) as $key
      ($in;
        if .[$key] and ($other[$key] | type) == "object" and (.[$key] | type) == "object"
        then .[$key] = (.[$key] | deep_merge($other[$key]))
        else .[$key] = $other[$key]
        end);

# TEST: ../../t/jq/snake_case
# echo '"firstName"' | jq 'include "common"; snake_case'
# => "first_name"
def snake_case:
  gsub("(?<a>[a-z0-9])(?<b>[A-Z])"; "\(.a)_\(.b)")
  | gsub("(?<a>[A-Z]+)(?<b>[A-Z][a-z])"; "\(.a)_\(.b)")
  | ascii_downcase;

# TEST: ../../t/jq/camel_case
# echo '"first_name"' | jq 'include "common"; camel_case'
# => "firstName"
def camel_case: split("_") | .[0] + (.[1:] | map(. as $x | ($x[0:1] | ascii_upcase) + $x[1:]) | join(""));

# TEST: ../../t/jq/recursive_map
# echo '{"a":[1,2]}' | jq 'include "common"; recursive_map(if type == "number" then . * 2 else . end)'
# => {"a":[2,4]}
def recursive_map(f):
  if type == "object" then
    with_entries(.value |= recursive_map(f))
  elif type == "array" then
    map(recursive_map(f))
  else
    f
  end;
