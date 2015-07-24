# This script assumes we are in a directory containing 2 subdirectories, 'train' and 'test',
# containing the training and test data sets respectively.
# The script will create a subdirectory called 'merged', if it doesn't exist, that will contain
# the merged data sets created and used in the analysis.

currentDir <- "."
mergedDir <- "merged"
numFiles <- 3

library(plyr)
library(dplyr)

createMergedDir <- function() {
  if (!file.exists(mergedDir)) {
    # needs to create 'merged'
    dir.create(file.path(currentDir, mergedDir))
  }
}

readDataSet <- function(fileDir, fileName, cclass) {
  f <- read.csv(paste(fileDir, fileName, sep="/"), colClasses = cclass, sep = "", header=FALSE, stringsAsFactors=FALSE)
  data.frame(f)
}

writeDataSetFile <- function(ds, fileDir, fileName) {
  write.table(ds, file = paste(fileDir, fileName, sep="/"), 
              append = FALSE, sep = " ", row.names = FALSE,
              col.names = TRUE)
}

tidyDataSet <- function(fileDir, fileSufix) {
  # reading the individual data sets
  x <- readDataSet(fileDir, paste("X_", fileSufix, ".txt", sep=""), rep("numeric",561))
  y <- readDataSet(fileDir, paste("y_", fileSufix, ".txt", sep=""), c("numeric"))
  s <- readDataSet(fileDir, paste("subject_", fileSufix, ".txt", sep=""), c("numeric"))
  
  # reading the labels in order to merge yhem into the data set (given a more descriptive info)
  labels <- readDataSet(currentDir, 'activity_labels.txt', c("numeric", "character"))
  labels <- rename(labels, activity_code = V1, activity_name = V2)
  
  # reading the features. They are going to be used to name the select the columns and rename them.
  features <- readDataSet(currentDir, 'features.txt', c("numeric", "character"))
  features <- rename(features, feature_column = V1, feature_name = V2)
  # filter only column names ending in 'mean()'and 'std()'. fixed=TRUE ensure not to get 'meanFreq' fields
  f1 <- features[grep("mean()", features$feature_name, fixed=TRUE), ]
  f2 <- features[grep("std()", features$feature_name, fixed=TRUE), ]
  features <- rbind(f1, f2)
  # preserving original order
  features <- arrange(features, feature_column)
  
  # select only the columns specified in the 'features' variable
  x <- select(x, features$feature_column)
  # rename the columns to a more descriptive name
  colnames(x) <- features$feature_name
  
  # adding a new column 'origin' in the data set describing if the data came from  the 'train' or 'test' data set.
  x <- mutate(x, origin = fileSufix)
  # adding the column containing the activity codes
  x <- cbind(x, y)
  # adding the column containing the subject
  x <- cbind(x, s)
  # renaming the activity code and subject columns to a more descriptive name
  colnames(x)[length(names(x))-1] <- "activity_code"
  colnames(x)[length(names(x))] <- "subject"
  # merging the new 'x' variable with the labels to obtain the activity name on the data set
  x <- merge(labels, x, by.x="activity_code", by.y="activity_code")
  # we don't need the activity code anymore, remove it
  x <- select(x, 2:length(names(x)))
  # return the tidy data set
  x
}

analize <- function() {
  # creating the merged directory and its subdirectory 
  createMergedDir()
  
  # tidying train and test data sets 
  ds_train <- tidyDataSet('train', 'train')
  ds_test <- tidyDataSet('test', 'test')
  # merging both data sets togheter producing resulting data set, and writing it to the file
  ds_total <- rbind(ds_train, ds_test)
  writeDataSetFile(ds_total, mergedDir, 'tidy_ds.txt')
  
  # creating the data set cointaining the average of each variable for each activity and each subject
  # the data is grouped by activity name and subject.
  # Since the information of activity name and subject is present in the group info, we can remove
  # the columns activity_name and subject from the final data set. We also removed the origin field
  # that indicates if the data comes from the training or test set
  ds_mean <- aggregate(ds_total[, 2:(length(names(ds_total))-2)], list(ds_total$activity_name, ds_total$subject), mean)
  # Renaming the group info to more descriptive names
  colnames(ds_mean)[1] <- 'activity_name'
  colnames(ds_mean)[2] <- 'subject'
  writeDataSetFile(ds_mean, mergedDir, 'tidy_mean_ds.txt')
}

