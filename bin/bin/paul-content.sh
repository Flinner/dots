curl_cache (){
  local cache_path=`echo $1 |  sed 's|/|_|g'`
  local cache_path="/tmp/$cache_path"

  [ -f "$cache_path" ] || curl -s "$1" -o "$cache_path"

  cat "$cache_path"
}


curl_cache "$1" | pup 'body .content text{}' | sed -r '/^\s*$/d' | bat --language=html
