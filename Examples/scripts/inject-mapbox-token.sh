# Look for a global file named 'mapbox' or '.mapbox' within the home directory
token_file=~/.mapbox
token_file2=~/mapbox
token="$(cat $token_file 2>/dev/null || cat $token_file2 2>/dev/null)"
if [ "$token" ]; then
  plutil -replace MBXAccessToken -string $token "$TARGET_BUILD_DIR/$INFOPLIST_PATH"
else
  echo 'warning: Missing Mapbox access token'
  open 'https://account.mapbox.com/access-tokens/'
  echo "warning: Get an access token from <https://account.mapbox.com/access-tokens/>, then create a new file at $token_file or $token_file2 that contains the access token."
fi