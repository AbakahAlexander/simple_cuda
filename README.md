# CUDA RGB to Grayscale Converter

This project demonstrates CUDA-based parallel computing by converting RGB images to grayscale. The conversion is performed on the GPU using CUDA kernels for maximum performance.

## Overview

The application performs the following operations:
- **Image Acquisition**: An input image (`sloth.png`) is read using OpenCV, and its RGB channels are extracted.
- **Data Transfer**: The individual color channel data is transferred from host to device memory.
- **Kernel Execution**: A CUDA kernel computes the grayscale value for each pixel by averaging the R, G, and B components.
- **Result Retrieval**: The resulting grayscale data is copied back to the host and saved as `sloth-gray.png`.
- **Validation**: A CPU-based conversion is executed and compared with the GPU result using a mean difference metric.

## Implementation Details

- **Image Loading and Channel Extraction**: OpenCV is used to read the image and separate its R, G, and B channels.
- **CUDA Kernel (`convert`)**: The kernel computes the grayscale pixel value as  
  ```cpp
  d_gray[i] = (d_r[i] + d_g[i] + d_b[i]) / 3;
  ```
  where each pixel is indexed using grid and block coordinates.
- **Memory Management**: Device memory for each color channel and the grayscale output is allocated using `cudaMalloc`, and data is transferred using `cudaMemcpy`.
- **Result Comparison**: The GPU output is compared with a CPU-generated grayscale image to compute the mean pixel difference and a scaled percentage difference.

## Project Files

- `convertRGBToGrey.cu`: Contains the CUDA kernel and host-side logic, including memory management and file I/O.
- `convertRGBToGrey.hpp`: Header file with function declarations and required includes.
- `sloth.png`: The original RGB image used as input.
- `sloth-gray.png`: The grayscale image output produced by the CUDA kernel.
- Additional build scripts and configuration files as needed.

## Requirements

- NVIDIA CUDA Toolkit
- OpenCV library
- GCC 11 (for CUDA compatibility)

## Setup

Before building, run the compatibility setup script:

## Build and Execution

To compile the project, use the NVIDIA CUDA Compiler (NVCC) and link against the OpenCV libraries. For example:

```bash
nvcc -o convertRGBToGrey convertRGBToGrey.cu -lopencv_core -lopencv_imgcodecs -lopencv_imgproc
```

Run the executable with command-line options to specify the input image, output image, and kernel configuration:

```bash
./convertRGBToGrey -i sloth.png -o sloth-gray.png -t 256
```

This command processes `sloth.png` and produces the grayscale output as `sloth-gray.png`.

## Results

The output of the CUDA-based conversion has been validated against a CPU implementation. A mean difference metric is calculated and printed to assess the accuracy of the GPU result.

## License

The core CUDA code is derived from samples provided by NVIDIA Corporation and is subject to the NVIDIA end user license agreement (EULA). Additional modifications and the project as a whole are provided under the MIT License.

