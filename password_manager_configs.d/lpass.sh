#!/usr/bin/env bash
# vim:ts=2:sw=2
logincmd="login"
if [ "$OPT_LPASS_USER" == "unset" ]; then
  echo "set @lastpass_username in tmux options"
  exit
fi
otherOptsLogin="$OPT_LPASS_USER"
# listcmd="ls"
# Creates an output that will match 1pass's output
# 1pass_format_str=" [{ \"uuid\": \"%ai\", \"overview\": { \"URLs\": [ {\"u\": \"%al\" } ], \"title\": \"%an\" } }] "
listcmd="show --json --expand-multi -G"
otherOptsList=".*"
getcmd="show"
otherOptsGet="--json"

filter_list(){
  local -r input="$*"
  local -r FILTER_URL="sudolikeaboss://local"
  local -r JQ_FILTER="
  .[]
  | [select(.url == \"$FILTER_URL\")]
  | map([ .name, .id ]
  | join(\",\"))
  | .[]
  "
  echo $input | jq "$JQ_FILTER" --raw-output
}

filter_get(){
  local -r input="$*"
  local -r JQ_FILTER=".[].password"
  echo $input | jq "$JQ_FILTER" --raw-output
}