
R_version <- "3.6.1"
snapshot_date <- "2019-08-23"
required_pckgs <- c("[PACKAGE NAMES]") 
download_dir <- paste("pckgs", R_version, snapshot_date, sep = "_")



# Set the correct CRAN mirror and download --------------------------------

checkpoint::checkpoint(snapshot_date, checkpointLocation = ".", 
                       use.knitr = FALSE, auto.install.knitr = FALSE)
checkpoint::setSnapshot(snapshot_date)

if(!dir.exists(download_dir)){
  dir.create(download_dir)
}



# Compile the dependencies to determine install order ---------------------

pckg_summaries <- available.packages()
depends <- list()

parse_dependencies <- function(pckg){
  # Build a list of all dependencies, which can then be downloaded and
  # used to install dependencies locally in reverse order of dependence
  #
  # NOTE: an empty list called `depends` must be created in the calling
  #       environment. This list will be changed IN PLACE
  #
  # Parameters
  #   pckg : character
  #     name of the package
  #
  # Returns : NULL
  
  if(pckg %in% names(depends) | !pckg %in% rownames(pckg_summaries)){
    # If the package was already visited or doesn't exist, do nothing
    return()
  }
  
  clean <- function(string){
    # Extract the package name from a dependency list returned by 
    # `available.packages()`
    #
    # Parameters
    #   cleaned : character
    #     list of dependencies as contained in column `Depends` or `Imports`
    #
    # Returns : character
    #   vector of package names without version information; or "R" if package
    #   does not depend on any other packages
    
    cleaned <- gsub("\\n", "", string, )
    cleaned <- strsplit(cleaned, ", ?")
    cleaned <- unlist(cleaned)
    cleaned <- gsub(" .*", "", cleaned)
    
    if(!all(is.na(cleaned))){
      cleaned[!is.na(cleaned)]
    } else {
      "R"
    }
  }
  
  # Get all dependencies and imports and clean them
  add_depend <- c(
    pckg_summaries[pckg, "Depends"], 
    pckg_summaries[pckg, "Imports"],
    pckg_summaries[pckg, "LinkingTo"]
  )
  add_depend <- clean(add_depend)
  
  # Add them to the list in the parent environment and recursively
  # look for dependencies in the packages found this round
  depends[[pckg]] <<- add_depend
  
  for(dep_pckg in add_depend){
    parse_dependencies(dep_pckg)
  }
  
}

# Build up the dependency file
for(pckg in required_pckgs){
  parse_dependencies(pckg)
}

# Download each needed package
download.packages(names(depends), destdir = download_dir, 
                  quiet = TRUE, type = "win.binary")


saveRDS(depends, file.path(download_dir, "depends.rds"))

