#!/bin/bash

echo "Enter GitHub Repository URL:"
read REPO_URL

echo "Enter Folder Name you want to fetch from:"
read FOLDER_NAME

echo "Enter Exact Folder Name you want to fetch:"
read FILE_NAME

# Extract repo name from URL
REPO_DIR=$(basename -s .git "$REPO_URL")

echo "🚀 Cloning repository (no checkout)..."
git clone --no-checkout "$REPO_URL"

# Check if clone successful
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ Clone failed. Please check repository URL."
    exit 1
fi

cd "$REPO_DIR" || exit

echo "🔧 Enabling sparse checkout..."
git sparse-checkout init --cone

echo "📂 Setting folder: $FOLDER_NAME"
git sparse-checkout set "$FILE_NAME"

echo "📥 Checking out branch main..."
git checkout main

echo "✅ Successfully fetched only '$FILE_NAME' folder!"
echo "👉 Run: ls"
