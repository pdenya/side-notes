#!/usr/bin/env zsh

# SideNotes - Lightweight project notes
# https://github.com/pdenya/side-notes

# Configuration
NOTES_BASE_DIR="${SIDENOTES_DIR:-$HOME/Code/SideNotes}"
NOTES_LINK_NAME="SideNotes"
NOTES_EDITOR="${EDITOR:-code}"

# Initialize notes for current repository
function notes_init {
    local repo_name="${1:-$(basename "$PWD")}"
    local note_dir="$NOTES_BASE_DIR/$repo_name"
    
    if [[ -L "$NOTES_LINK_NAME" ]]; then
        echo "✓ Notes already initialized"
        return 0
    fi
    
    mkdir -p "$note_dir"
    ln -s "$note_dir" "$NOTES_LINK_NAME"
    echo "✓ SideNotes initialized for $repo_name"
}

# Create a new note
function note {
    if [[ ! -L "$NOTES_LINK_NAME" ]]; then
        echo "Run 'notes_init' first to initialize"
        return 1
    fi
    
    if [[ -z "$1" ]]; then
        echo "Usage: note <slugified-filename>"
        echo "Example: note sidenotes-style-adjustments"
        echo "Note: Use slugified names (lowercase, hyphens for spaces)"
        return 1
    fi
    
    local title="$1"
    local filename="$NOTES_LINK_NAME/$(date +"%Y-%m-%d_%H-%M")_${title}.md"
    
    cat > "$filename" << EOF
# $title
*$(date +"%Y-%m-%d %H:%M:%S")*

EOF
    
    echo "Created: $filename"
    $NOTES_EDITOR "$filename"
}

# Show usage and list notes
function notes {
    echo "SideNotes - Lightweight project notes"
    echo ""
    echo "USAGE:"
    echo "  notes_init [project_name]  Initialize notes for current repository"
    echo "  note <slugified-filename>  Create a new note (e.g. note sidenotes-style-adjustments)"
    echo "  notes                      Show this help and list existing notes"
    echo "  notes_latest              Open the most recent note"
    echo "  notes_projects            List all projects with notes"
    echo ""
    echo "NOTE: Use slugified filenames (lowercase, hyphens for spaces)"
    echo ""
    
    if [[ ! -L "$NOTES_LINK_NAME" ]]; then
        echo "STATUS: Not initialized. Run 'notes_init' first."
        return 0
    fi
    
    if [[ -z "$(ls -A "$NOTES_LINK_NAME" 2>/dev/null)" ]]; then
        echo "NOTES: No notes yet. Create one with 'note <filename>'"
        return 0
    fi
    
    echo "NOTES:"
    ls -1t "$NOTES_LINK_NAME" | sed 's/^/  /'
}

# Open latest note
function notes_latest {
    if [[ ! -L "$NOTES_LINK_NAME" ]]; then
        echo "Run 'notes_init' first to initialize"
        return 1
    fi
    
    local latest=$(ls -t "$NOTES_LINK_NAME" 2>/dev/null | head -n1)
    if [[ -z "$latest" ]]; then
        echo "No notes yet"
        return 1
    fi
    
    $NOTES_EDITOR "$NOTES_LINK_NAME/$latest"
}

# List all projects with notes
function notes_projects {
    echo "Projects with SideNotes:"
    ls -1d "$NOTES_BASE_DIR"/*/ 2>/dev/null | while read -r dir; do
        local project=$(basename "$dir")
        local count=$(ls -1 "$dir" 2>/dev/null | wc -l)
        echo "  $project ($count notes)"
    done
}