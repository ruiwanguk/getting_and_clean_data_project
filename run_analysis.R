# This script provides functions to prepare Human Activity Recognition Using Smartphones Dataset
# and run analysis on the formatted dataset to get the average of each variable for each activity and 
# each subject

library(reshape2)

# run analysis on the dataset to get the average of each variable for each activity and each subject
# all the variables must be either the mean or the standard deviation of the measurements.
# 
# Args:
# 	dataset_path: the full path to the dataset
#	
# Returns:
# 	a tidy dataset which contains the average of each variable for each activity
#	and each subject.
runAnalysis <- function(dataset_path) {
	# prepare the dataset
	prepared_data <- prepareDataset(dataset_path)
	
	# get all the column names
	features <- names(prepared_data)
	
	# define all the ids columns
	ids <- c("subject", "activity")
	
	# retain all the measurements
	features <- features[! features %in% ids]	
	
	# melt the dataset according to its measurements
	prepared_data_melt <- melt(prepared_data, id=ids, measure.vars=features)
	
	# calculate the average of each variable
	results <- dcast(prepared_data_melt, subject + activity ~ variable,mean)
	
	# return results
	results
}

# Prepare the input dataset according to the following requirements:
#
# 1. merges the training and test dataset.
# 2. extracts only the measurements on the mean and standard deviation for each measurements.
# 3. uses descriptive activity names to name the activities in the dataset.
# 4. labels the dataset with descriptive variable names.
# 
# Args:
# 	dataset_path: the full path to the dataset
#	
# Returns:
# 	a dataset which contains only mean and standard deviation measurements, it also
# 	contains descriptive labels for the activities
prepareDataset <- function(dataset_path) {
	# merge training and test data
	x_data <- mergeTrainAndTestDataset(dataset_path)
	
	# merge training and test labels
	y_label <- mergeTrainAndTestLabel(dataset_path)
	
	merged_subject <- mergeTrainAndTestSubject(dataset_path)
	
	# extract only the measurements on the mean and standard deviation for each measurement
	x_subset <- subsetByMeanAndStd(dataset_path, x_data)
	
	# add column name for label
	descriptive_activity_labels <- extractDescriptiveActivityLabels(dataset_path, y_label)
	
	# Assign descriptive activity names to the dataset
	final_data <- cbind(merged_subject, descriptive_activity_labels, x_subset)
	
	# return the final data
	final_data
}

# Merge training and test data
# 
# Args:
# 	dataset_path: the full path to the dataset
#	
# Returns:
# 	merged training and test dataset
mergeTrainAndTestDataset <- function(dataset_path) {
	# read training set
	x_train <- read.csv(file.path(dataset_path, "train/X_train.txt"), sep="", header=FALSE)
	
	# read test set
	x_test <- read.csv(file.path(dataset_path, "test/X_test.txt"), sep="", header=FALSE)
	
	# merge training set with test set
	x_data <- rbind(x_train, x_test)
	
	# return merged dataset
	x_data
}

# Merge training and test activity labels
# 
# Args:
# 	dataset_path: the full path to the dataset
#	
# Returns:
# 	merged training and test activity labels
mergeTrainAndTestLabel <- function(dataset_path) {
	# read training label
	y_train <- read.csv(file.path(dataset_path, "train/y_train.txt"), sep="", header=FALSE)
	
	# read test label
	y_test <- read.csv(file.path(dataset_path, "test/y_test.txt"), sep="", header=FALSE)
	
	# merge training label with test label
	y_label <- rbind(y_train, y_test)
	
	# return merged labels
	y_label
}

# Merge training and test activity subjects
# 
# Args:
# 	dataset_path: the full path to the dataset
#	
# Returns:
# 	merged training and test subjects
mergeTrainAndTestSubject <- function(dataset_path) {
	# read training subjects
	subject_train <- read.csv(file.path(dataset_path, "train/subject_train.txt"), sep="", header=FALSE)
	
	# read test subjects
	subject_test <- read.csv(file.path(dataset_path, "test/subject_test.txt"), sep="", header=FALSE)
	
	# merge training subjects with test subjects
	merged_subject <- rbind(subject_train, subject_test)
	names(merged_subject) <- "subject"
	
	# return merged subjects
	merged_subject
}

# Subset the merged training and test dataset
# 
# Args:
# 	dataset_path: the full path to the dataset
#	x_data: merged training and test dataset
#	
# Returns:
# 	subset of the merged training and test dataset, only contains the mean and the standard
#	deviation measurements
subsetByMeanAndStd <- function(dataset_path, x_data) {
	# read feature names
	x_features <- read.csv(file.path(dataset_path, "features.txt"), sep="", header=FALSE)
	
	# label features as the column name for the whole dataset
	names(x_data) <- x_features$V2
	
	# select features with mean() and std()
	x_mean_std_features <- x_features[grepl("mean()", x_features$V2, fixed=TRUE) | grepl("std()", x_features$V2, fixed=TRUE), ]
	
	# create a vector that contains all the mean() and std() features
	mean_std_features <- as.character(x_mean_std_features$V2)
	
	# extract only the measurements on the mean and standard deviation for each measurement
	x_subset <- subset(x_data, select=mean_std_features)
	
	# return subset
	x_subset
}

# extract descriptive activity labels
# 
# Args:
# 	dataset_path: the full path to the dataset
#	y_label: training and test labels
#	
# Returns:
# 	descriptive activity labels
extractDescriptiveActivityLabels <- function(dataset_path, y_label) {
	# read activity labels
	activity_labels <- read.csv(file.path(dataset_path, "activity_labels.txt"), sep="", header=FALSE)
	
	# merge y_label with activity labels to have descriptive names
	merged_activity_labels <- merge(y_label, activity_labels, by.x="V1", by.y="V1")
	
	# add column name for label
	merged_activity_labels <- subset(merged_activity_labels, select=c("V2"))
	names(merged_activity_labels) <- "activity"
	
	# return descriptive activity labels
	merged_activity_labels
}

