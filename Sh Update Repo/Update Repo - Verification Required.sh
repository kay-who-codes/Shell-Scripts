#!/bin/bash

# Script to update a GitHub repository from the local machine

# Step 1: Ensure we are in a Git repository
if [ ! -d ".git" ]; then
  echo "Error: This is not a Git repository. Please run this script inside a Git repository folder."
  exit 1
fi

# Step 2: Get the local repository name and replace spaces with dashes
local_repo_name=$(basename "$PWD")   # Get the current directory name
github_repo_name=${local_repo_name// /-}  # Replace spaces with dashes

echo "Local repository name: $local_repo_name"
echo "GitHub repository name: $github_repo_name"

# Step 3: Add all changes (modified, new, and deleted files)
git add -A

# Step 4: Commit the changes
echo "Enter commit message (leave blank for default):"
read commit_msg

if [ -z "$commit_msg" ]; then
  commit_msg="Update repository with latest changes"
fi

git commit -m "$commit_msg"

# Step 5: Push changes to the GitHub repository
git remote set-url origin "https://github.com/kay-who-codes/$github_repo_name.git"
git push origin main

# Completion message
echo "Repository updated and pushed to GitHub with name: $github_repo_name"
