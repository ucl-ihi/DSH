# Install R packages within the Data Safe Haven 

The Data Safe Haven does not have access to a CRAN mirror, the most common method to install R packages. For this reason, calling `install.packages("dplyr")` will not work, making it tedious to install new packages in the DSH environment. A number of R packages are preinstalled but many commonly used packages are still missing. 

Researchers working within the DSH have two options to install new R packages:
1. Contact the IT team to request the package
2. Download the package source outside the DSH, upload them through the secure file transfer portal, and install them manually within the DSH


## 1. Contacting the IT team

In an email from August 21st 2019 Anthony Peacock, the Head of Windows Infrastructure Services Group in charge of the DSH described a permanent way to install R packages:

>We have created a new common R library and  R-3.6.1 will have access by default. This is a read only library that will be actively managed and updated. Upon request, new R packages will be installed to this location for all Data Safe Haven customers to use. 
>
>Please review the packages that are available to you, if you don’t find what you are looking for IAO's/IAA's may request new packages by completing the online Data Safe Haven Software Request form:
>[https://ucl.my.salesforce.com/?startURL=/apex/bmcservicedesk__ssredirect?type=sr%26id=a3S0J0000026ANVUA2](https://ucl.my.salesforce.com/?startURL=/apex/bmcservicedesk__ssredirect?type=sr%26id=a3S0J0000026ANVUA2)"

Installing packages via the official channels has the advantage that packages will be actively updated. However, it can take a while until the request is dealed with. In addition, this option is not reproducible. Major updates to a package can break code, rendering it effectively useless after a few years. For this reason, installing packages manually as described below is recommended<sup>1</sup>. 


## 2. Upload and install packages directly

Installing the required packages manually allows researchers more power in determining which package is used within different projects. For example, depending on the project different versions of the same project might be necessary for legacy issues. 

### 2.1 Manual installation
The easies way to do so is by downloading the package binaries or source code from CRAN (e.g. https://cran.r-project.org/web/packages/dplyr/index.html). This archive can then be uploaded via the file transfer portal https://filetransfer.idhs.ucl.ac.uk/ and will appear in the DSH's Q: drive in the folder named like your username. 

The package can not be installed in the default package library, as standard DSH users do not have write permissions for this folder. Instead, we need to create a packages folder within the project folder. All packages installed via R can then be installed in this folder for which we do have writing permissions. To do so, we first create the folder and then tell R were to find this folder: 

```
dir.create("packages")
.libPaths("packages")
``` 

This code creates the folder and then sets R's search path to the folder. Note that while the first command only has to be run once, the `.libPaths` command needs to be run everytime R is started. The easiest way to do so is to place a file named .Rprofile in the project folder. This file will be called whenever the project is opened in RStudio, which will automatically reset the libpath for us. 

The package can then be installed either via the `install.packages()` function or from within the RStudio GUI by clicking Tools -> Install Packages... In the latter case, the drop down field *Install from:* needs to be changed from *Repository (CRAN)* to *Package Archive File (.zip; .tar.gz)*. Choose the package archive file in the drop-down menu and the package will be installed. Note, however, that this will not install any other packages that this package depends on. These will have to be installed one by one in reverse order. 


### 2.2 Semi-automatic installation

Installing all dependencies of a package manually can quickly become tedious. To make matters worse, whenever a new version of R is installed in the DSH, many old packages will not work anymore and will have to be reinstalled, again requiring you to reinstall those packages and all their dependencies one by one. 

The scripts *download.R* and *install.R* are scripts meant to help with this by automatically downloading all dependencies of a package outside of the DSH, finding the right order they need to be installed, and then using the downloaded files and the dependency order to install the package within the DSH. 

**Download**

You can use *download.R* outside of DSH (e.g. on your own laptop or PC) to automatically download the source of the required package as well as any necessary dependencies. In order to do so, there are four bits of information that you need to provide before running the script, all of which can be set at the beginning of the script:

* `R_version`: This variable contains the R version, for which the code should be downloaded, as a string. For example, in order to download packages that work with the current DSH R version 3.6.1, this variable needs to be initialised with `R_version <- "3.6.1"`
* `snapshot_date`: In addition to the R version, the script also allows/requires you to set a snapshot date. Only package versions that existed at the time of the snapshot will be downloaded, ensuring you that your code in the DSH will never break due to unexpected updates of packages. Dates should also be set as strings in the format `snapshot_date <- "2019-08-03"`.
* `required_pckgs`: This variable is a character vector containing the names of all packages you wish to download. This does not have to include any dependencies, which will be determined automatically. For example, if you wish to download tidyverse and data.table, simply set this variable to `required_pckgs <- c("tidyverse", "data.table")`.
* `download_dir`: Finally, this variable needs to provide a valid path to a directory in which you want to download the packages. In order to download the packages into the current working directory, simply initialise this variable with `download_dir <- "."`

**Install**

Once all packages have been downloaded via *download.R*, simply zip the folder specified in `download_dir` and upload them via the [DSH file transfer portal](https://filetransfer.idhs.ucl.ac.uk/webclient/Login.xhtml) together with the `install.R` script. Inside DSH, unpack the zip file and set the parameters in `install.R`.

* `R_version, snapshot_date, required_pckgs`: These should be set to the same values used during download (described above).
* `local_dir`: The path to the folder in which to install the packages. It should be noted here that DSH users do not have writting privileges on the DSH's default R package folders. Instead, I would recommend to create a folder `packages` in the root folder of each project, in which all packages necessary for the project are installed. This folder should then be passed to `local_dir`.
* `path_to_src`: This too is a string containing a path, this time to the unzipped package sources.

After the parameters have been set correctly, simply run `install.R` and all packages should be installed into `local_dir`. The last remaining step is to tell R and RStudio to look for packages in `local_dir` instead of the systems library. This can be done by running `.libPaths("[REPLACE_WITH_PATH_TO_LOCAL_DIR]")` everytime you start R. This can be automated by placing the command in a `.Rprofile` file in the root folder of your RStudio project. This works because RStudio searches for a file called `.Rprofile` at startup and runs any code that is included in the file.


**Authors:**
Patrick Rockenschaub
___
<sup>1</sup> The views expressed here are those of the author(s) and not necessarily those of the Institute of Health Informatics.
