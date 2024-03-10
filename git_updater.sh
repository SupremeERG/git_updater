#!/bin/bash

# Change these variables according to your repository
REPO_PATH="$1" # ./ by default
REMOTE_NAME="$2" # origain by default

# Go to the repository directory
cd "$REPO_PATH" || exit


echo log "@" /tmp/git_updater.log

while true; do
    BRANCH_NAME=$(git branch | awk '{print $2}')

    # Get the number of files changed
    NUM_FILES_CHANGED=$(git status --porcelain | wc -l)


    # Add all changes
    git add .

    # Commit changes with a default message
    git commit -m "Automated commit $(date)" >> /tmp/git_updater.log 2>&1 


    # Push changes to remote repository
    git push "$REMOTE_NAME" "$BRANCH_NAME" >> /tmp/git_updater.log 2>&1 


    # Get the repository name
    REPO_NAME=$(basename -s .git "$(git config --get remote."$REMOTE_NAME".url)")

    # Send desktop notification
    notify-send "Pushed $NUM_FILES_CHANGED changes to $REPO_NAME/$BRANCH_NAME"
    sleep 1800 # wait half an hour to push again
done
