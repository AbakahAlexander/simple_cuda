OPENCV_FLAGS := $(shell pkg-config --exists opencv4 && pkg-config opencv4 --cflags --libs || pkg-config opencv --cflags --libs)
NVCC := $(shell which nvcc)
CUDA_PATH := $(shell dirname $$(dirname $$(which nvcc 2>/dev/null)) 2>/dev/null)
CUDA_INCLUDE := $(if $(CUDA_PATH),-I$(CUDA_PATH)/include,)

# GCC 11 setup
GPP11_PATH := $(shell which g++-11 2>/dev/null || echo "/usr/bin/g++-11")
HOST_COMPILER := -ccbin $(GPP11_PATH)
COMPATIBILITY_FLAGS := -allow-unsupported-compiler

# Use wrapper if available
NVCC_CMD := $(shell if [ -f ./nvcc_wrapper.sh ]; then echo "./nvcc_wrapper.sh"; else echo "$(NVCC)"; fi)

CPPFLAGS := $(CUDA_INCLUDE) -Wno-deprecated-gpu-targets $(HOST_COMPILER) $(COMPATIBILITY_FLAGS)
LDFLAGS := -lcuda $(OPENCV_FLAGS)

TARGET = convertRGBToGrey.exe
SRC = convertRGBToGrey.cu

all: build

build: check-deps $(TARGET)

$(TARGET): $(SRC)
	$(NVCC_CMD) $< --std c++17 $(CPPFLAGS) $(LDFLAGS) -o $@

check-deps:
	@if [ -z "$(NVCC)" ]; then \
		echo "Error: CUDA compiler (nvcc) not found. Run ./setup.sh to install required dependencies."; \
		exit 1; \
	fi
	@if ! pkg-config --exists opencv4 && ! pkg-config --exists opencv; then \
		echo "Error: OpenCV not found. Run ./setup.sh to install required dependencies."; \
		exit 1; \
	fi
	@if [ ! -f "$(GPP11_PATH)" ]; then \
		echo "Error: g++-11 not found at $(GPP11_PATH). Run ./cuda_compat_setup.sh to install compatible compiler."; \
		exit 1; \
	fi
	@echo "Using g++-11 at: $(GPP11_PATH)"
	@if [ -f ./nvcc_wrapper.sh ]; then \
		echo "Using NVCC wrapper with GCC 11 headers"; \
	fi

clean:
	rm -f $(TARGET)

.PHONY: all build clean check-deps
