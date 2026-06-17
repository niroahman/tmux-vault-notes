#!/usr/bin/env bash
STATE_DIR="$HOME/.tmux-vault"
SESSION_NAME="${1:-}"

if [[ -z "$SESSION_NAME" ]]; then
    echo "Usage: $0 <session-name> {save|load|clear} [file] [line] [col]"
    exit 1
fi

STATE_FILE="$STATE_DIR/${SESSION_NAME}.json"
mkdir -p "$STATE_DIR"

case "${2:-}" in
    save)
        FILE="${3:-}"
        LINE="${4:-0}"
        COL="${5:-0}"
        printf '{"file":"%s","line":%s,"col":%s,"timestamp":"%s"}\n' \
            "$FILE" "$LINE" "$COL" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$STATE_FILE"
        ;;
    load)
        if [[ -f "$STATE_FILE" ]]; then
            cat "$STATE_FILE"
        else
            echo '{"file":"","line":0,"col":0}'
        fi
        ;;
    clear)
        rm -f "$STATE_FILE"
        ;;
    *)
        echo "Usage: $0 <session> {save|load|clear}"
        exit 1
        ;;
esac
