#!/usr/bin/env bash
SESSION_PREFIX="$(tmux show-option -gqv @vault_session_prefix)"
POPUP_WIDTH="$(tmux show-option -gqv @vault_popup_width)"
POPUP_HEIGHT="$(tmux show-option -gqv @vault_popup_height)"

SESSION_PREFIX="${SESSION_PREFIX:-vault-}"
POPUP_WIDTH="${POPUP_WIDTH:-90%}"
POPUP_HEIGHT="${POPUP_HEIGHT:-90%}"

STATE_DIR="$HOME/.tmux-vault"

SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep "^${SESSION_PREFIX}")

if [[ -z "$SESSIONS" ]]; then
    tmux display-message "No vault sessions open"
    exit 0
fi

LIST=""
while IFS= read -r session; do
    STATE_FILE="$STATE_DIR/${session}.json"
    if [[ -f "$STATE_FILE" ]]; then
        LAST_FILE="$(jq -r '.file // empty' "$STATE_FILE")"
    else
        LAST_FILE=""
    fi
    DISPLAY_FILE="$(basename "${LAST_FILE:-}")"
    LIST="${LIST}${session}\t${DISPLAY_FILE:-no file}\n"
done <<< "$SESSIONS"

SELECTED=$(printf "%b" "$LIST" | fzf --prompt="vault > " --with-nth=2 --delimiter='\t' | cut -f1)

if [[ -n "$SELECTED" ]]; then
    tmux switch-client -t "$SELECTED"
fi
