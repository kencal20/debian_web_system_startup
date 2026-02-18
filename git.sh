#!/usr/bin/env bash

#!/usr/bin/env bash

# Install git if not installed
sudo apt update
sudo apt install git -y

echo "Git installed successfully."

# Prompt for Git user configuration
read -p "Enter your Git user name: " GIT_USER
read -p "Enter your Git email: " GIT_EMAIL

# Configure global git identity
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

echo "Git global username and email set."

echo "Git setup complete."
