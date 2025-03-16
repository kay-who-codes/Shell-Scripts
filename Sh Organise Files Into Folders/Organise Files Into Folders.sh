#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Move to the script's directory
cd "$SCRIPT_DIR"

# Get the script's filename (without the path)
SCRIPT_NAME="$(basename "$0")"

# Loop through all files in the directory
for FILE in *; do
  # Skip the script itself and directories
  if [[ "$FILE" == "$SCRIPT_NAME" ]] || [[ -d "$FILE" ]]; then
    continue
  fi

  # Get the file extension (if any) and convert it to uppercase
  EXTENSION="${FILE##*.}"
  if [[ "$FILE" != "$EXTENSION" ]]; then
    EXTENSION=$(echo "$EXTENSION" | tr '[:lower:]' '[:upper:]')
  else
    EXTENSION="NO_EXTENSION" # For files without extensions
  fi

  # Create the folder if it doesn't exist
  if [[ ! -d "$EXTENSION" ]]; then
    mkdir -p "$EXTENSION"
  fi

  # Move the file into the corresponding folder
  mv "$FILE" "$EXTENSION/"
  echo "Moved '$FILE' to '$EXTENSION/'"
done

echo "File organization complete!"