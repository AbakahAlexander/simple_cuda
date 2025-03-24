#!/bin/bash

echo "Cleaning up unnecessary shell scripts..."

# List of scripts to remove
SCRIPTS_TO_REMOVE=(
  "direct_build.sh"
  "cuda_compat_setup.sh"
  "compiler_fix.sh"
  "check_cuda_env.sh"
  "build_with_cpp11.sh"
)

# Remove each script
for script in "${SCRIPTS_TO_REMOVE[@]}"; do
  if [ -f "$script" ]; then
    echo "Removing $script"
    rm "$script"
  else
    echo "$script not found, skipping"
  fi
done

echo "Kept fix_headers.sh as requested"
echo "Cleanup complete"
