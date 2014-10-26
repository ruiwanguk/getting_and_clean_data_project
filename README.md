# Getting And Clean Data Project

# Prerequisite

Before you can execute, you need to make sure that you have R installed on your machine. 

Also, download the following dataset and unpack the zip file into our R work space:

[Original Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )

Here is a full [dataset description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Or, you can use the following R script:

	> file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	> download.file(file_url, destfile="./fuci.zip", method="curl")
	> unzip("./fuci.zip")	

# How to Run

In your R shell, import the run_analysis.R script:

	> source("./run_analysis.R")

Call runAnalysis() function, give the file path to the dataset as the input parameter:

	> results <- runAnalysis("./UCI HAR Dataset")

