#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

# Set Zed as default for common source code file types
# Zed's bundle identifier is "dev.zed.Zed"

extensions=(
    "rs"     # Rust
    "py"     # Python
    "js"     # JavaScript
    "ts"     # TypeScript
    "jsx"    # React JSX
    "tsx"    # React TSX
    "java"   # Java
    "cpp"    # C++
    "c"      # C
    "h"      # Header files
    "hpp"    # C++ headers
    "go"     # Go
    "rb"     # Ruby
    "php"    # PHP
    "swift"  # Swift
    "kt"     # Kotlin
    "cs"     # C#
    "css"    # CSS
    "scss"   # SCSS
    "json"   # JSON
    "xml"    # XML
    "yaml"   # YAML
    "yml"    # YAML
    "toml"   # TOML
    "md"     # Markdown
    "txt"    # Text files
)

log "Setting Zed as default editor for source code files..."

for ext in "${extensions[@]}"; do
    echo "Setting default for .$ext files..."
    run_with_logging "Setting default for .$ext files..." duti -s dev.zed.Zed .$ext all
done

log "Done! Zed is now the default editor for the specified file types."
