#!/usr/bin/env bash
set -euo pipefail

name="gh-actions-language-server"

FLAKE_FILE="$PWD/servers/$name/default.nix" # Update this if needed

echo "🔍 Checking for GH Actions Language Server updates..."

latest_version=$(curl -s https://registry.npmjs.org/gh-actions-language-server | jq -r '.["dist-tags"].latest')
current_version=$(grep '^  version = "' "$FLAKE_FILE" | sed -E 's/.*"([^"]+)".*/\1/')

echo "Current version: $current_version"
echo "Latest version:  $latest_version"

if [[ "$latest_version" == "$current_version" ]]; then
	echo "✅ Already up-to-date."
	exit 0
fi

echo "⬇️  Fetching new tarball..."
url="https://registry.npmjs.org/gh-actions-language-server/-/gh-actions-language-server-${latest_version}.tgz"
curl -L "$url" -o /tmp/$name.tgz

echo "🔢 Computing SHA256..."
sha256=$(nix hash file /tmp/$name.tgz)

echo "✍️  Updating $FLAKE_FILE..."

# Update version in `let` binding
sed -i "s|^  version = \".*\";|  version = \"$latest_version\";|" "$FLAKE_FILE"

# Update sha256 in `let` binding
sed -i "s|^  sha256 = \".*\";|  sha256 = \"$sha256\";|" "$FLAKE_FILE"

echo "🔄 Regenerating lock.json..."
nix run .#$name.lock

echo "✅ Update complete: version $latest_version, lock.json regenerated."
