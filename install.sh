
#!/usr/bin/env bash

set -e

# Simple installer for SideNotes
INSTALL_DIR="$HOME/.zsh_functions"
NOTES_DIR="$HOME/Code/SideNotes"

echo "Installing SideNotes..."

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$NOTES_DIR"

# Download or copy main script
if [[ -f "side-notes.sh" ]]; then
    cp side-notes.sh "$INSTALL_DIR/"
else
    curl -fsSL https://raw.githubusercontent.com/pdenya/side-notes/main/side-notes.sh -o "$INSTALL_DIR/side-notes.sh"
fi

# Add to gitignore
if ! grep -q "^\SideNotes$" "$HOME/.gitignore" 2>/dev/null; then
    echo "SideNotes" >> "$HOME/.gitignore"
fi
git config --global core.excludesFile "$HOME/.gitignore"

# Detect shell and add source line
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.bash_profile"
fi

# Add to shell config if not already there
if ! grep -q "side-notes.sh" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# SideNotes" >> "$SHELL_RC"
    echo "source $INSTALL_DIR/side-notes.sh" >> "$SHELL_RC"
fi

echo "✓ SideNotes installed!"
echo ""
echo "Run this to reload your shell:"
echo "  source $SHELL_RC"
echo ""
echo "Then in any git repo:"
echo "  notes_init  # initialize"
echo "  note <new-file-name>   # create a note"
