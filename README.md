# SideNotes

Lightweight, zero-friction project notes that live alongside your code. They appear right in your editor’s file tree as a `SideNotes` folder but never end up in Git. SideNotes gives every repository a persistent scratchpad you can open instantly. Notes are per project, timestamped, and ignored by Git by default.

- Minimal install, no dependencies beyond your shell
- Notes stored per project under a central directory (defaults to `~/Code/SideNotes`)
- A symlink (`SideNotes`) is created in your repo for quick access
- Appears right in your editor file tree via the `SideNotes` symlink (feels in-repo, stays out of Git)
- Timestamped Markdown files, opened in your editor

---

## Why SideNotes?

- Keep ephemeral thinking out of PRs and commits while still keeping it near the code.
- One consistent place for notes across all your repos.
- Right in your editor: the `SideNotes` folder appears in your repo tree via a symlink, so notes feel co-located with code without polluting Git.
- Fast: one command to initialize, one to write, one to jump to the latest.
- Safe: notes never land in Git; they live outside your working tree and are globally ignored.
- Portable: plain Markdown files on disk. No app lock-in.

---

## Quickstart

```bash
# Install (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/pdenya/side-notes/main/install.sh | bash

# In any project directory
notes_init            # one-time per project
note first-idea       # creates a timestamped Markdown note
notes                 # shows usage and lists your notes
notes_latest          # opens the most recent note in your editor
```

By default, notes are opened with `$EDITOR` (falling back to VS Code via `code`).

---

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/pdenya/side-notes/main/install.sh | bash
```

### Manual

```bash
git clone https://github.com/pdenya/side-notes.git
cd side-notes
./install.sh
```

What the installer does:
- Copies `side-notes.sh` to `~/.zsh_functions/`
- Ensures `~/Code/SideNotes` exists
- Adds `SideNotes` to your global Git ignore and sets `core.excludesFile` to `~/.gitignore`
- Sources the script from your `~/.zshrc` (or `~/.bashrc` / `~/.bash_profile`)

To start using without restarting your shell:

```bash
source ~/.zshrc   # or the file the installer prints
```

To update later, just re-run the installer one-liner.

---

## CLI reference

All commands are shell functions defined by `side-notes.sh`.

- `notes_init [project_name]`
  - Initializes SideNotes for the current directory.
  - Creates a per-project notes directory under the base directory and a `SideNotes` symlink in the repo.
  - If `project_name` is omitted, the current folder name is used.

- `note <slugified-filename>`
  - Creates a new Markdown file named like `YYYY-MM-DD_HH-MM_<slug>.md` and opens it in your editor.
  - Use lowercase with hyphens for spaces, e.g. `note exploring-build-flags`.

- `notes`
  - Shows usage and, if initialized, lists your notes newest-first.

- `notes_latest`
  - Opens the most recent note for the current project.

- `notes_projects`
  - Lists all projects with notes and a count per project.

---

## Examples (with expected output)

Assume you run these inside a repository called `api-server`.

```bash
$ notes_init
✓ SideNotes initialized for api-server

$ note performance-sweep
Created: SideNotes/2025-08-08_14-22_performance-sweep.md

$ notes
SideNotes · Lightweight project notes

USAGE:
  notes_init [project_name]  Initialize notes for current repository
  note <slugified-filename>  Create a new note (e.g. note sidenotes-style-adjustments)
  notes                      Show this help and list existing notes
  notes_latest              Open the most recent note
  notes_projects            List all projects with notes

NOTE: Use slugified filenames (lowercase, hyphens for spaces)

NOTES:
  2025-08-08_14-22_performance-sweep.md

$ notes_latest
# Opens the latest note in your $EDITOR (e.g., VS Code)
```

A newly created note looks like:

```markdown
# performance-sweep
*2025-08-08 14:22:00*

```

`notes_projects` output example:

```bash
$ notes_projects
Projects with SideNotes:
  api-server (12 notes)
  mobile-app (7 notes)
  infra (3 notes)
```

---

## Configuration

You can tweak behavior with environment variables (add these to your shell rc file before sourcing the script):

- `SIDENOTES_DIR`: base directory where all notes are stored
  - Default: `~/Code/SideNotes`
- `EDITOR`: command to open files
  - Default: your `$EDITOR`, falling back to `code` (VS Code). Set to `vim`, `nvim`, `nano`, etc.

Advanced (edit `side-notes.sh` if you want to change these):
- `NOTES_LINK_NAME`: the symlink placed in your repo (default `SideNotes`)

---

## How it works

- When you run `notes_init`, SideNotes:
  - Creates a per-project directory under the base dir (e.g., `~/Code/SideNotes/api-server/`)
  - Creates a symlink called `SideNotes` in your repo pointing to that directory
- `note <slug>` creates a timestamped Markdown file in that directory and opens it
- Notes are globally ignored by Git via your global `~/.gitignore` entry (`SideNotes`), so the symlink and files won’t show up as changes in your repo

Expected layout:

```
~/Code/SideNotes/
  api-server/
    2025-08-08_14-22_performance-sweep.md

/path/to/your/repo/
  SideNotes -> ~/Code/SideNotes/api-server/
```

---

## Troubleshooting

- “Run 'notes_init' first to initialize”
  - You’re in a repo without the `SideNotes` symlink yet. Run `notes_init` in that repo.

- `notes_latest` says “No notes yet”
  - Create your first note with `note <slug>`.

- Editor doesn’t open
  - Ensure `$EDITOR` is set or that `code` is installed. Example: `export EDITOR=vim`.

- I don’t use Zsh
  - The installer will source the script from your `~/.bashrc` or `~/.bash_profile` when Zsh config isn’t found. The functions are compatible with modern Bash.

- Keep `SideNotes` out of Git for everyone on my machine
  - The installer adds `SideNotes` to your global `~/.gitignore` and sets `git config --global core.excludesFile ~/.gitignore`.

---

## Uninstall

Remove the source line from your shell config (`.zshrc`, `.bashrc`, or `.bash_profile`):

```bash
# Remove or comment out this line
source ~/.zsh_functions/side-notes.sh
```

Then delete the script (notes remain on disk):

```bash
rm ~/.zsh_functions/side-notes.sh
```

Your notes under `~/Code/SideNotes` are untouched.

---

## License

MIT