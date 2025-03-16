#!/bin/bash

# GitHub username
USERNAME="kay-who-codes"

# Dynamically determine the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Directory to save the repositories (same directory as the script)
SAVE_DIRECTORY="$SCRIPT_DIR/github_repositories"

# Path to the GitHub personal access token file
TOKEN_FILE="A:\Programming\Access Tokens\Github Access Token - Repo.txt"

# Read the GitHub personal access token from the file
if [ -f "$TOKEN_FILE" ]; then
  TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')
else
  echo "Token file not found at $TOKEN_FILE."
  exit 1
fi

# Check if the token is empty
if [ -z "$TOKEN" ]; then
  echo "Token is empty. Please ensure the token file contains a valid GitHub personal access token."
  exit 1
fi

# GitHub API URL (fetch up to 100 repositories per page)
GITHUB_API_URL="https://api.github.com/users/$USERNAME/repos?per_page=100"

# Create the save directory if it doesn't exist
mkdir -p "$SAVE_DIRECTORY"

# Fetch repositories
echo "Fetching repositories for user $USERNAME..."
REPOS=$(curl -s -H "Authorization: token $TOKEN" "$GITHUB_API_URL")

# Check if repositories were fetched
if [ -z "$REPOS" ]; then
  echo "No repositories found or an error occurred."
  exit 1
fi

# Extract clone URLs and clone each repository
echo "$REPOS" | grep -o 'git@[^"]*' | while read -r REPO_URL; do
  REPO_NAME=$(basename "$REPO_URL" .git)
  REPO_PATH="$SAVE_DIRECTORY/$REPO_NAME"

  # Skip if the directory already exists
  if [ -d "$REPO_PATH" ]; then
    echo "Skipping $REPO_NAME (already exists)."
    continue
  fi

  echo "Cloning $REPO_NAME into $REPO_PATH..."
  git clone "$REPO_URL" "$REPO_PATH"
done

echo "All repositories have been cloned."