# tmux-vault-notes

A tmux plugin that opens a markdown editor in a popup overlay, tied to your current directory. Remembers the last file and line you had open.

## Installation

### TPM
```tmux
set -g @plugin 'niroahman/tmux-vault-notes'
run '~/.tmux/plugins/tpm/tpm'
```

### Manual
```bash
git clone https://github.com/niroahman/tmux-vault-notes ~/.tmux/plugins/tmux-vault-notes
```

To install via TPM:

1. `prefix + I` — TPM installs the plugin
2. `prefix + r` — reload tmux config

## Configuration

```tmux
set -g @vault_editor         'nvim'    # or micro, hx, nano
set -g @vault_path           '~/vault' # path to your vault
set -g @vault_key            'v'       # prefix + v
set -g @vault_picker_key     'V'       # prefix + V
set -g @vault_popup_width    '90%'
set -g @vault_popup_height   '90%'
set -g @vault_session_prefix 'vault-'
```

## Usage

- `prefix + v` — open vault in a popup overlay, restores last state
- `prefix + V` — fzf picker across all vault sessions

## State

Per-directory state stored in `~/.tmux-vault/<session>.json`. Remembers last open file and line number.

```bash
# Manual state management
./scripts/vault-state.sh <session> load
./scripts/vault-state.sh <session> save /path/to/file.md 42
./scripts/vault-state.sh <session> clear
```
