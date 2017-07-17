#set gpu.
set(gpu
)

#set the gpu files 
set(gpu_dir
)
set(gpu_header_files
    ../include/execution/gpu/gpu.hpp
)
set(gpu_source_files
    gpu/gpu.cpp
)
set(gpu_dir
    ${gpu_dir}
    ${gpu_header_files}
    ${gpu_source_files}
)
set(gpu
	${gpu}
	${gpu_dir}
)


