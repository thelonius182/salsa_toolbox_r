# Install and load the necessary packages
pacman::p_load(ps, stringr)

# Define a function to check if a specific R script is running
is_script_running <- function(script_name) {
  
  process_list <- ps()
  
  for (cur_ps_handle in process_list$ps_handle) {
    ps_args <- ps_cmdline(cur_ps_handle)
    
    for (cur_arg in ps_args) {
      
      if (str_detect(cur_arg, script_name)) {
        return(TRUE)
      }
    }
  }
  
  return(FALSE)
}

# Check if cz_gids.R is running
cz_gids_running <- is_script_running("salsa_toolbx")
print(paste("salsa_toolbox running:", cz_gids_running))

# Check if other_script.R is running
other_script_running <- is_script_running("other_script.R")
print(paste("other_script.R is running:", other_script_running))
