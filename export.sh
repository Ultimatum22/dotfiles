#!/usr/bin/env bash
# Creates a self-contained tarball of the dotfiles for offline deployment.
# Usage: ./export.sh [output-path]
#   output-path defaults to ../dotfiles-export.tar.xz
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NAME="$(basename "$SCRIPT_DIR")"
OUTPUT="${1:-$(dirname "$SCRIPT_DIR")/dotfiles-export.tar.xz}"

echo "Ensuring all submodules are populated..."
git -C "$SCRIPT_DIR" submodule update --init --recursive
echo "  ...done"

echo "Creating archive at $OUTPUT ..."
tar -cJf "$OUTPUT" \
    --exclude='.git' \
    --exclude='.github' \
    --exclude='test' \
    --exclude='tests' \
    --exclude='tools/zsh-bin' \
    --exclude='tools/testssl.sh/bin' \
    -C "$(dirname "$SCRIPT_DIR")" \
    "$REPO_NAME"

SIZE=$(du -sh "$OUTPUT" | cut -f1)
echo "  ...done ($SIZE)"
echo ""
echo "To deploy on the target machine:"
echo "  tar xJf $(basename "$OUTPUT")"
echo "  cd $REPO_NAME && ./deploy.zsh"
