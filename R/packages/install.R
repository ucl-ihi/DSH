


# These parameters must be the same as those used for download
R_version <- "3.6.1"
snapshot_date <- "2019-08-23"
required_pckgs <- c("[PACKAGE_NAME]")


# path to the local directory into which the packages should be installed
local_dir <- "[PATH_TO_INSTALL_DIR]"
path_to_src <- "[PATH_TO_UPLOADED_PACKAGE_FILES]"




# DO NOT CHANGE ANYTHING BELOW --------------------------------------------

# Set the path
src_dir <- file.path(path_to_src, 
                     paste("pckgs", R_version, snapshot_date, sep = "_"))
srcs <- dir(src_dir)
srcs <- srcs[!grepl("\\.rds")]

# Load the dependencies
depends <- readRDS(file.path(src_dir, "depends.rds"))



install_pckg <- function(pckg){
  # Install a package downloaded with `download.R` based on source files 
  # and a dependency list
  #
  # Parameters
  #   pckg : character
  #     package name to be installed
  #
  # Return : NULL
  
  installed <- installed.packages(lib.loc = local_dir)
  
  if(pckg %in% names(depends) & !pckg %in% installed){
    for(dep_pckg in depends[[pckg]]){
      install_pckg(dep_pckg)
    }
    
    src <- srcs[grep(x = srcs, paste0("^", pckg, "_"))]
    
    if(length(src) > 1){
      stop(paste("More than one package were found:", paste(src, collapse = ", ")))
    } else if (length(src) == 1){
      if(grepl(x = src, "\\.zip$")){
        install.packages(file.path(src_dir, src), repos = NULL, type = "win.binary")
      } else if (grepl(x = src, "\\.tar\\.gz$")) {
        install.packages(file.path(src_dir, src), repos = NULL, type = "source")
      }
    }
  }
}


for(pckg in required_pckgs){
  install_pckg(pckg)
}

