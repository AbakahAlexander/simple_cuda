#!/bin/bash

echo "Fixing CUDA C++ header compatibility issues..."

# Ensure GCC 11 is installed
if ! command -v g++-11 &> /dev/null; then
    echo "Installing GCC 11..."
    sudo apt update
    sudo apt install -y gcc-11 g++-11
fi

# Create cuda_gcc_includes.txt with only the C++11 paths
cat > cuda_gcc_includes.txt << EOT
/usr/include/c++/11
/usr/include/x86_64-linux-gnu/c++/11
/usr/include/c++/11/backward
/usr/lib/gcc/x86_64-linux-gnu/11/include
/usr/local/include
/usr/include/x86_64-linux-gnu
/usr/include
EOT

echo "Created include paths file with C++11 paths only:"
cat cuda_gcc_includes.txt

# Create the NVCC wrapper script with proper include paths
cat > nvcc_wrapper.sh << 'EOT'
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
EOT

chmod +x nvcc_wrapper.sh

echo "Created nvcc_wrapper.sh that forces C++11 standard and correct include paths"
echo "You can run 'make clean build' now to use the wrapper"
