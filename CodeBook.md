# The Code Book
This file describes the variables, the data, and any transformations or work performed to clean up the data.
This file is supposed to be used togheter with the script presented in run_analysis.R, in the sense that the complement each other, some part of the documentation is presented in the script in order to be clearer to the reader.

# Summary of steps and resulting variables
## Steps
The following steps are performed on the script:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Analize
The main function to be called is analize(). The function will create a directory called 'merged' if it doesn't exist and it will save there 2 files:
  * tidy_ds.txt - the resulting data set resulting of steps 1, 2, 3 and 4.
  * tidy_mean_ds.txt - the data set described in step 5.

Through the function 'tidyDataSet' the script performs the activities described on steps 2, 3, and 4 (more details below). 
The variable ds_total contains the merged data set described in step 1 (already tidy).
The variable ds_mean contains the data set described in step 5.

## Performing each step
### Step 1
This step is simply a rbind function call. The only catch here is that we did the rbind after we tidy the train and test data sets (through calling the tidyDataSet function for each one), in order to have by construction a tidy resulting data set.

### Step 2
Step done inside the 'tidyDataSet' function. By looking at the features.txt we can understand what each column of x means and by doing so we could filter only the measurements on the and standard deviation. 
It was only used variables ending in mean() and std(). Variables ending in meanFreq() were discarded, since they do not represent a mean of value presented in the sample, as consequence we can notice that we don't have a variable std corresponding to these discarded variables, stdFreq() doesn't exist. 
They way it was done, was to use the features.txt file as a data set, filter leaving only the records for the desired features, and using this data set as a filter for the selection of the columns on the tidy data set. For more details on the implementation, please refer to the script.

### Step 3
This step was done through a merge with the data set presented in the activity_labels.txt. In order to do that we needed first to add the activity codes column present in the 'y_train.txt' or 'y_test.txt' files to the tidy data set. After that a merge by the activity_code was used between the tidy data set and the labels data set.
For more details on the implementation, please refer to the script.

### Step 4
The names used to label the data set were:
  * activity_name - the string corresponding to the name of the activity;
  * subject - the code of the subject;
  * origin - informs if the data came from 'train' or 'test' set;
  * and the appropriated feature names presented in the features.txt file (used 66 features).

A proper description of the formula used to name the features is presented in features_info.txt.
A brief resume of the name components:
  * t -> time domain
  * f -> frequency domain
  * BodyAcc -> body acceleration
  * GravityAcc -> acceleration
  * BodyGyro -> body gyroscope
  * BodyBodyAcc -> different component of the Fast Fourier Transform (FFT), second order, body acceleration
  * BodyBodyGyro -> different component of the Fast Fourier Transform (FFT), second order, body gyroscope
  * Jerk -> jerk signal
  * Mag -> magnitude
  * X -> X axis
  * Y -> Y axis
  * Z -> Z axis

### Step 5
  The tidy data set with the average of each variable for each activity and each subject was created through the call of the aggregate function, using activity_name and subject as group columns, and summarizing using mean on the columns containing the other numeric variables.
  For more details on the implementation, please refer to the script.






