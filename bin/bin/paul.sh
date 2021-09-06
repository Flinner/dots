#!/bin/sh


exit_m() {
  echo "$1"
  exit 1
}

# curl with cache! (in "/tmp")
curl_cache(){
  local cache_path=`echo $1 |  sed 's|/|_|g'`
  local cache_path="/tmp/$cache_path"

  [ -f "$cache_path" ] || curl -s "$1" -o "$cache_path"

  echo "$cache_path"
}


domain="https://tutorial.math.lamar.edu/"
file=`curl_cache "$1"` # main file, that has all questions
q_num=$(( $2 - 1 )) #numbering starts at 1

# naive method to check for only args!
[ -n "$file" ]  || exit_m  "No Files Given"
[ -n "$q_num" ] || exit_m  "No Questoin Number Given!"
[ ! -n "$3" ]   || exit_m  "Incorrect number of args :("


# get all practice questions
question_text=`cat $file | pup 'body .practice-problems li json{}' |
  jq ".[${q_num}].text"  | tr -d '"'`

# get all solution *links*
solution_path=`cat $file | pup 'body .practice-problems li json{}' |
  jq -r ".[${q_num}].children[0].href"`
solution_url="$domain/$solution_path"


# ====  get solution =========
# download if not already downloaded
echo '** Item
:PROPERTIES:
:ANKI_DECK: Math::Calculus-III
:ANKI_NOTE_TYPE: Basic
:END:
'
solution_path=`curl_cache "$solution_url"`
echo '*** Front'
echo "$question_text"
echo "\n"
echo '*** Back'
cat "$solution_path" | pup 'body .soln-content text{}' | sed -r '/^\s*$/d'
solution_title=`cat "$solution_path" | pup 'title text{}' | sed -r '/^\s*$/d'`
echo "\n"
echo "[[$solution_url][$solution_title]]"
echo "\n"

