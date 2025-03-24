#!/bin/bash
INCLUDE_ARGS=""
while read -r line; do
    # Skip empty lines and lines starting with dash
    if [[ -n "$line" && "$line" != -* ]]; then
        INCLUDE_ARGS="$INCLUDE_ARGS -isystem $line"
    fi
done < cuda_gcc_includes.txt

# Force C++11 standard
ARGS_WITH_CPP11=$(echo "$@" | sed 's/--std=c++17/--std=c++11/')

echo "Running: nvcc $ARGS_WITH_CPP11 $INCLUDE_ARGS" 
nvcc $ARGS_WITH_CPP11 $INCLUDE_ARGS
