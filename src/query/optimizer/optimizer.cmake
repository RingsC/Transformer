#set the optimizer cmake file.
set(optimizer
)
set(cost_dir
)
set(path_dir
)
set(plan_dir
)


#set the cost source/header files.
set(cost_header_files
)
set(cost_source_files
	cost/cost.cpp
)

#set the path source/header files
set(path_header_files
)
set(path_source_files
)

#set the plan source/header files.
set(plan_header_files
)
set(plan_source_files
)


#add the header and source files to top.
set(cost_dir
	${cost_dir}
	${cost_header_files}
	${cost_source_files}
)
set(plan_dir
	${plan_dir}
	${plan_header_files}
	${plan_source_files}
)
set(path_dir
	${path_dir}
	${path_header_files}
	${path_source_files}
)
set(optimizer
	${optimizer}
	${cost_dir}
	${path_dir}
	${plan_dir}
)

#set the source groups
source_group("cost"					FILES ${cost_dir})
source_group("cost\\include"		FILES ${cost_header_files})
source_group("cost\\source"			FILES ${cost_source_files})

 
source_group("plan"					FILES ${plan_dir})
source_group("plan\\include"		FILES ${plan_header_files})
source_group("plan\\source"			FILES ${plan_source_files})



source_group("path"					FILES ${path_dir})
source_group("path\\include"		FILES ${path_header_files})
source_group("path\\source"			FILES ${path_source_files})

