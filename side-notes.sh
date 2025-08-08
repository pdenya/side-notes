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
    
    local title="${1:-note}"
    local filename="$NOTES_LINK_NAME/$(date +"%Y-%m-%d_%H-%M")_${title}.md"
    
    cat > "$filename" << EOF
# $title
*$(date +"%Y-%m-%d %H:%M:%S")*

EOF
    
    echo "Created: $filename"
    $NOTES_EDITOR "$filename"
}

# List notes
function notes {
    if [[ ! -L "$NOTES_LINK_NAME" ]]; then
        echo "Run 'notes_init' first to initialize"
        return 1
    fi
    
    if [[ -z "$(ls -A "$NOTES_LINK_NAME" 2>/dev/null)" ]]; then
        echo "No notes yet. Create one with 'note'"
        return 0
    fi
    
    ls -1t "$NOTES_LINK_NAME"
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