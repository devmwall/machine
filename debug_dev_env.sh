#!/bin/bash

# Print out all environment variables
echo "ALL ENVIRONMENT VARIABLES:"
env

# Specific checks for DEV_ENV
echo ""
echo "DEV_ENV SPECIFIC CHECKS:"
echo "Printing DEV_ENV directly: $DEV_ENV"
echo "Using printenv: '$(printenv DEV_ENV)'"
echo "Using echo: '$(echo "$DEV_ENV")'"

# Check if variable is set using different methods
echo ""
echo "VARIABLE SET CHECKS:"
if [ -z "$DEV_ENV" ]; then
    echo "[ -z check says: Variable is NOT set or is empty"
else
    echo "[ -z check says: Variable IS set"
fi

if [ "$DEV_ENV" = "" ]; then
    echo "Comparison check says: Variable is empty"
else
    echo "Comparison check says: Variable has a value"
fi

# Attempt to resolve common issues
echo ""
echo "POTENTIAL SOLUTIONS:"
echo "1. Ensure you've run: export DEV_ENV=/full/path/to/your/repo"
echo "2. Check if the variable is set in your shell configuration:"
echo "   - For bash: ~/.bashrc or ~/.bash_profile"
echo "   - For zsh: ~/.zshrc"
echo "3. Try setting the variable in the current terminal session before running the script"
