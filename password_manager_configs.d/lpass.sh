#!/usr/bin/env bash
OPT_LPASS_USER="$(get_tmux_option "@lastpass-username" "unset")"

login(){
  if ! lpass status; then
    echo "Lastpass is not logged in."
    if [ -z "${LPUSERNAME}" ] && [ "unset" == "$OPT_LPASS_USER" ]; then
      echo "set @lastpass_username in tmux options or set LPUSERNAME to speed up this process in future"
      echo "Enter lastpass username: "
      read -r LPUSERNAME
      OPT_LPASS_USER="$LPUSERNAME"
    fi
    if [ -z "$LPUSERNAME" ]; then LPUSERNAME="$OPT_LPASS_USER"; fi
    lpass login "$LPUSERNAME"
  fi
}

get_items() {
  echo INFO: All items found: > /dev/stderr # debug
  itemlist="$(lpass ls)"
  # Convert name [id: uuid] syntax to name,uuid
  while read -r line; do
    echo "$line" | sed 's/[^/]*\/\([^[]*\)\[id:\ \([^]]*\)\]/\1,\2/' | log
  done <<< "$itemlist"
}

get_item_password() {
  local -r ITEM_UUID="$1"
  if $INCLUDE_PASSWORDS_IN_LOG; then
    echo DEBUG: \`lpass show -p $ITEM_UUID\` output: > /dev/stderr # debug
  fi
  $getcmd lpass show -p $ITEM_UUID | log true
}
