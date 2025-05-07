#!/bin/bash

# Function to display messages
function info {
    echo -e "\033[1;34m$1\033[0m"  # Blue text for informational messages
}

# Function to show a loading message
function loading_message {
    echo -e "\033[1;33mLoading...\033[0m"  # Yellow text for loading message
}

# Function to show a success message
function success_message {
    echo -e "\033[1;32m✅ $1\033[0m"  # Green text for success messages
}

# Start the setup process
info "Starting project setup... 🚀"

# Step 1: Core setup
info "Setting up core... 🛠️"
cd ./packages/core  # Navigate to your core package directory using a relative path
loading_message  # Show loading message
flutter pub get  # Get Flutter dependencies for the core package
success_message "Core package dependencies installed successfully! 🎉"
loading_message  # Show loading message
dart run build_runner build --delete-conflicting-outputs  # Run build runner with delete flag
success_message "Core package build completed! 🚀"
cd -  # Return to the previous directory (root)
# Add your core setup commands here
# Example: flutter create .

# Step 2: Setting up APIs
info "Setting up APIs... 🌐"
cd ./packages/apis  # Navigate to your APIs package directory using a relative path
loading_message  # Show loading message
flutter pub get  # Get Flutter dependencies for the APIs package
success_message "API package dependencies installed successfully! 🎉"
loading_message  # Show loading message
dart run build_runner build --delete-conflicting-outputs  # Run build runner with delete flag
success_message "API package build completed! 🚀"
cd -  # Return to the previous directory (root)

# Step 3: Setting up example project in APIs package
info "Setting up example project in APIs package... 📦"
cd ./packages/apis/example  # Navigate to the example project directory using a relative path
loading_message  # Show loading message
flutter pub get  # Get Flutter dependencies for the example project
success_message "Example project dependencies installed successfully! 🎉"
loading_message  # Show loading message
dart run build_runner build --delete-conflicting-outputs  # Run build runner with delete flag
success_message "Example project build completed! 🚀"
cd -  # Return to the previous directory (root)

# Step 4: Get Flutter dependencies
# info "Running 'flutter pub get'..."
# flutter pub get

# Step 5: Run build runner
# info "Running 'dart run build_runner build' with delete..."
# dart run build_runner build --delete-conflicting-outputs

info "Setup complete! 🎉 You're ready to start using the project! 🚀"
info "Feel free to explore the examples provided and start building amazing things! 💡"

# Author information
echo -e "\n# Author: Gurkan Fikret Gunak (@gurkanfikretgunak)"  # Add author line
echo -e "🌟 Check out the project repository at: https://github.com/masterfabric-mobile/osmea \nDon't forget to star the project if you find it useful! ⭐"  # Add repository link and encouragement
