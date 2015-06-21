## Code Book ##

### Background Information ###

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Datasets in zip file ###

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Overview run_analysis.R

### Setup Working Directory ###
In the script, the first line of set the R current working directory, you either must modify it or comment it out.

### Packages Used ###

- data.table
- reshape2

### Automatic Download of Input file  ###
The input file used by the script is automatically downloaded, and unzipped by the following line of code

```sh
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "projectfile.zip", method = "internal")
unzip("projectfile.zip")
```

### Assignment of Column Names ###

The unzipped file contain separate files for metadata information associated with the data files. 

features.txt
activity_labels.txt

### Read test data ###

testData           <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE,col.names=mn)
testData_activity  <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE,col.names=c("Activity_Id"))
testData_subject   <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE,col.names=c("Subject_Id"))

### Read train data ###

trainData          <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE,col.names=mn)
trainData_activity <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE,col.names=c("Activity_Id"))
trainData_subject  <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE,col.names=c("Subject_Id"))

### Assigment of descriptive names to the activity data set activities ###

activities             <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)[,2]
testData_activity[,2]  <- activities[testData_activity[,1]]
colnames(testData_activity)[2] <- "Activity_Name"
trainData_activity[,2] <- activities[trainData_activity[,1]]
colnames(trainData_activity)[2] <- "Activity_Name"

### Merge the test and train dataset to one big dataset  ###

testData  <-cbind(testData_activity,testData)
testData  <-cbind(testData_subject,testData)

trainData <-cbind(trainData_activity,trainData)
trainData <-cbind(trainData_subject,trainData)

oneDataset <-rbind(testData,trainData)

### Extract the measurements on the mean and standard deviation for each measurement

data_mean_std <- oneDataset[, grepl("*.mean.*", colnames(oneDataset)) | grepl("*.std.*", colnames(oneDataset))]
data_subj_act <-subset(oneDataset, select=c(Subject_Id, Activity_Id, Activity_Name))
data          <- cbind(data_subj_act, data_mean_std)

### Reshape the data to get the average of each variable for each activity and each subject.  ###

id_variables       <- c("Subject_Id", "Activity_Id", "Activity_Name")
measure_variables  <- setdiff(colnames(data), id_variables)
melt_data          <- melt(data, id = id_variables, measure.vars = data_labels)

tidy_data   <- dcast(melt_data, Subject_Id + Activity_Name ~ variable, mean)
write.table(tidy_data, file = "./data.txt")

