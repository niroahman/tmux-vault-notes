#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$CURRENT_DIR/scripts/vault-open.sh"
chmod +x "$CURRENT_DIR/scripts/vault-picker.sh"
chmod +x "$CURRENT_DIR/scripts/vault-state.sh"

get_opt() {
    local option="$1"
    local default="$2"
    local value
    value="$(tmux show-option -gqv "$option")"
    echo "${value:-$default}"
}

VAULT_KEY="$(get_opt @vault_key 'v')"
VAULT_PICKER_KEY="$(get_opt @vault_picker_key 'V')"
VAULT_WIDTH="$(get_opt @vault_popup_width '90%')"
VAULT_HEIGHT="$(get_opt @vault_popup_height '90%')"

tmux bind-key "$VAULT_KEY" run-shell "$CURRENT_DIR/scripts/vault-open.sh"
tmux bind-key "$VAULT_PICKER_KEY" run-shell "$CURRENT_DIR/scripts/vault-picker.sh"
