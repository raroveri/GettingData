# GettingData
Getting and Cleaning Data Course Project

# The Project
The project consists in producing a tidy data set extracted from data related to wearable computing.
  
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
  
And here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# The Script
A script called run_analysis.R, presented in this repo, was created.
The script does the following:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

After sourcing the file, the main function to be called is analize(). The function will create a directory called 'merged' if it doesn't exist and it will save there 2 files:
  * tidy_ds.txt - the resulting data set resulting of steps 1, 2, 3 and 4.
  * tidy_mean_ds.txt - the data set described in step 5.

# The Code Book
In this repo we also have a code book, called CodeBook.md, that describes the variables, the data, and any transformations or work performed to clean up the data.