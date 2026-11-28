#!/bin/sh
# hide: move the focused pane into this workspace's "hidden" tab, remembering where it sat.
# unhide: move the most recently hidden pane back next to the same neighbor, same size.
set -eu
h="${HERDR_BIN_PATH:-herdr}"
db="${HERDR_PLUGIN_STATE_DIR:?}/hidden.tsv"
ws="${HERDR_WORKSPACE_ID:?}"
touch "$db"

hide() {
  p="${HERDR_PANE_ID:?}"
  lay=$("$h" pane layout --pane "$p")
  tab=$(printf '%s' "$lay" | jq -r '.result.layout.tab_id')
  [ "$(printf '%s' "$lay" | jq '.result.layout.panes | length')" -gt 1 ] || { echo "pane-hide: only pane in tab" >&2; exit 1; }
  for look in left up right down; do
    t=$("$h" pane neighbor --pane "$p" --direction "$look" | jq -r '.result.neighbor.neighbor_pane_id // empty')
    [ -n "$t" ] && break
  done
  # herdr only splits right/down of a target, so a right/down neighbor needs a swap afterwards
  case $look in left|right) split=right dim=width ;; *) split=down dim=height ;; esac
  case $look in left|up) swap=0 ;; *) swap=1 ;; esac
  # --ratio is the target slot's share; after a swap that slot holds the restored pane
  ratio=$(printf '%s' "$lay" | jq -r --arg p "$p" --arg t "$t" --arg k "$dim" --argjson s "$swap" '
    .result.layout.panes as $ps
    | ($ps[] | select(.pane_id == $t) | .rect[$k]) as $a
    | ($ps[] | select(.pane_id == $p) | .rect[$k]) as $b
    | (if $s == 1 then $b else $a end) / ($a + $b)')
  ht=$("$h" tab list --workspace "$ws" | jq -r '[.result.tabs[] | select(.label == "hidden")][0].tab_id // empty')
  if [ -n "$ht" ]; then
    "$h" pane move "$p" --tab "$ht" --split right --no-focus >/dev/null
  else
    "$h" pane move "$p" --new-tab --label hidden --no-focus >/dev/null
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$p" "$tab" "$t" "$split" "$ratio" "$swap" >>"$db"
}

unhide() {
  line=$(grep "^$ws:" "$db" | tail -1 || true)
  [ -n "$line" ] || { echo "pane-hide: nothing hidden in $ws" >&2; exit 0; }
  grep -vxF "$line" "$db" >"$db.tmp" || true
  mv "$db.tmp" "$db"
  IFS='	' read -r p tab t split ratio swap <<EOT
$line
EOT
  # pane was closed while hidden: drop it and try the next one
  "$h" pane get "$p" >/dev/null 2>&1 || { unhide; return; }
  ttab=$("$h" pane get "$t" 2>/dev/null | jq -r '.result.pane.tab_id' || true)
  if [ "$ttab" != "$tab" ]; then
    # neighbor gone or moved: put it beside the focused pane instead
    t="${HERDR_PANE_ID:?}" tab=$("$h" pane get "$t" | jq -r '.result.pane.tab_id') split=right ratio=0.5 swap=0
  fi
  "$h" pane move "$p" --tab "$tab" --target-pane "$t" --split "$split" --ratio "$ratio" --focus >/dev/null
  [ "$swap" = 0 ] || "$h" pane swap --source-pane "$p" --target-pane "$t" >/dev/null
}

"$1"
