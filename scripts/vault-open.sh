#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VAULT_EDITOR="$(tmux show-option -gqv @vault_editor)"
VAULT_PATH="$(tmux show-option -gqv @vault_path)"
SESSION_PREFIX="$(tmux show-option -gqv @vault_session_prefix)"
POPUP_WIDTH="$(tmux show-option -gqv @vault_popup_width)"
POPUP_HEIGHT="$(tmux show-option -gqv @vault_popup_height)"

VAULT_EDITOR="${VAULT_EDITOR:-${EDITOR:-nvim}}"
VAULT_PATH="${VAULT_PATH:-$HOME/vault}"
SESSION_PREFIX="${SESSION_PREFIX:-vault-}"
POPUP_WIDTH="${POPUP_WIDTH:-90%}"
POPUP_HEIGHT="${POPUP_HEIGHT:-90%}"

CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"
DIR_HASH="$(echo -n "$CURRENT_PATH" | md5 | cut -c1-8)"
SESSION_NAME="${SESSION_PREFIX}${DIR_HASH}"

STATE_DIR="$HOME/.tmux-vault"
STATE_FILE="$STATE_DIR/${SESSION_NAME}.json"
mkdir -p "$STATE_DIR"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux display-popup -E \
        -w "$POPUP_WIDTH" -h "$POPUP_HEIGHT" \
        -d "$CURRENT_PATH" \
        "tmux attach -t $SESSION_NAME"
else
    tmux new-session -d -s "$SESSION_NAME" -c "${VAULT_PATH/#\~/$HOME}"

    LAST_FILE=""
    LAST_LINE=0
    if [[ -f "$STATE_FILE" ]]; then
        LAST_FILE="$(jq -r '.file // empty' "$STATE_FILE")"
        LAST_LINE="$(jq -r '.line // 0' "$STATE_FILE")"
    fi

    if [[ -n "$LAST_FILE" && -f "$LAST_FILE" ]]; then
        tmux send-keys -t "$SESSION_NAME" "$VAULT_EDITOR +$LAST_LINE '$LAST_FILE'" Enter
    else
        tmux send-keys -t "$SESSION_NAME" "$VAULT_EDITOR '${VAULT_PATH/#\~/$HOME}'" Enter
    fi

    tmux display-popup -E \
        -w "$POPUP_WIDTH" -h "$POPUP_HEIGHT" \
        -d "$CURRENT_PATH" \
        "tmux attach -t $SESSION_NAME"
fi
