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

This 


### 2.2 Semi-automatic installation


In addition, whenever a new version of R is installed in the DSH, many old packages will not work anymore and will have to be reinstalled




**Authors:**
Patrick Rockenschaub
___
<sup>1</sup> The views expressed here are those of the author(s) and not necessarily those of the Institute of Health Informatics.
