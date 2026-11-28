#!/bin/sh
# Workspace-only picker styled like herdr's goto (kanagawa colors). Enter focuses the pick.
h="${HERDR_BIN_PATH:-herdr}"
# popup env may lack a UTF-8 locale; without it fzf drops the icons
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
e=$(printf '\033')
g="${e}[32m" y="${e}[33m" r="${e}[31m" d="${e}[2m" b="${e}[1m" z="${e}[0m"
cols=$(stty size 2>/dev/null </dev/tty | cut -d' ' -f2)
w=$(( ${cols:-80} - 3 )) # minus gutter + pointer + margin

# id, cwd of the active tab's first pane, focused, status, label
rows=$("$h" api snapshot | jq -r '.result.snapshot as $s | $s.workspaces[] | . as $w
  | [.workspace_id,
     ([$s.panes[] | select(.tab_id == $w.active_tab_id)][0].cwd // "-"),
     (if .focused then "1" else "0" end), .agent_status, .label] | @tsv' |
while IFS='	' read -r id cwd cur st label; do
  br=$(git -C "$cwd" branch --show-current 2>/dev/null)
  case $st in
    (working) i="${y}●" ;; (blocked) i="${r}!" ;; (idle) i="${g}○" ;; (*) i="${d}·" ;;
  esac
  [ "$cur" = 1 ] && m="${g}◆${z}" || m=" "
  # shortcut: printf pads by bytes, so non-ASCII labels shift the branch column
  n=$(( w - 5 - ${#br} )); [ "$n" -lt 1 ] && n=1
  printf '%s\t%s\t%s\t%s %s%s %s%-*s%s%s\n' "$id" "$cwd" "$br" "$m" "$i" "$z" "$b" "$n" "$label" "$z" "$br"
done)

# Nav mode until '/': printable keys do nothing, so the query stays empty.
keys=$(awk 'BEGIN{for(i=33;i<127;i++){c=sprintf("%c",i); if(index("jk/,:+()\"\047\\",c)==0) printf "%s%s",(n++?",":""),c}}'),space
ign=$(printf '%s' "$keys" | sed 's/,/:ignore,/g; s/$/:ignore/')

# shellcheck disable=SC2016 # $FZF_* vars are expanded by fzf, not this shell
sel=$(printf '%s\n' "$rows" | fzf --ansi --delimiter='	' --with-nth=4 --reverse \
  --prompt='/ ' --ghost='search workspaces' --info=inline-right --info-command='echo "$FZF_MATCH_COUNT workspaces"' \
  --pointer=' ' --gutter=' ' --no-scrollbar --highlight-line \
  --bind "$ign,j:down,k:up,/:change-prompt(> )+unbind(j,k,/,$keys)" \
  --bind "esc:transform:[ \"\$FZF_PROMPT\" = '/ ' ] && echo abort || echo 'clear-query+change-prompt(/ )+rebind(j,k,/,$keys)'" \
  --preview="printf '%s\n${d}%s\nj/k rows · / search · enter open · esc close${z}' {2} {3}" \
  --preview-window=down,3,border-none,noinfo \
  --color='bg:-1,fg:#c5c9c7,bg+:#87a987,fg+:#1c1e25:bold,hl:#dca561,hl+:#1c1e25:underline' \
  --color='prompt:#717c7c,query:#c5c9c7,info:#717c7c' \
  --color='separator:#393b44,pointer:#1c1e25,gutter:-1,preview-bg:-1,ghost:#717c7c')

id=$(printf '%s' "$sel" | cut -f1)
[ -n "$id" ] && exec "$h" workspace focus "$id"
