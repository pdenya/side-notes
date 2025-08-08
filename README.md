# SideNotes

Lightweight project notes that live in your Git repositories but aren't added to git. Persistent scratch pads for git projects. 

## Install

### Quick install
```bash
curl -fsSL https://raw.githubusercontent.com/pdenya/side-notes/main/install.sh | bash
```

### Manual install
```bash
git clone https://github.com/pdenya/side-notes.git
cd side-notes
./install.sh
```

## Usage

```bash
# Initialize in any git repo
notes_init

# Create a note
note my-idea

# List notes
notes

# Open latest note
notes_latest
```

## Uninstall

Remove this line from your shell config (`.bashrc` or `.zshrc`):
```bash
source ~/.zsh_functions/side-notes.sh
```

Then delete the script:
```bash
rm ~/.zsh_functions/side-notes.sh
```

Your notes in `~/Code/SideNotes` will remain untouched.

## License

MIT
```

