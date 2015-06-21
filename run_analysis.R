
# ----------------------------------------------------------------------------------------------------
#
# run_analysis.R
#
# ----------------------------------------------------------------------------------------------------

setwd("I:\\MyData\\Training\\Getting and Cleaning Data\\CourseProject")
getwd()

require("data.table")
require("reshape2")

fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "projectfile.zip", method = "internal")
unzip("projectfile.zip")
list.files(path=".")

# features.txt is the column names for the x-Files
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
mn <- make.names(features$V2)      # make syntactically valid names


# read all files, and assign column names where possible
testData           <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE,col.names=mn)
testData_activity  <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE,col.names=c("Activity_Id"))
testData_subject   <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE,col.names=c("Subject_Id"))

trainData          <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE,col.names=mn)
trainData_activity <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE,col.names=c("Activity_Id"))
trainData_subject  <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE,col.names=c("Subject_Id"))


# yes descriptive activity names to name the activities in the data set
activities             <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)[,2]
testData_activity[,2]  <- activities[testData_activity[,1]]
colnames(testData_activity)[2] <- "Activity_Name"
trainData_activity[,2] <- activities[trainData_activity[,1]]
colnames(trainData_activity)[2] <- "Activity_Name"


# merge the training and the test sets to create one data set
testData  <-cbind(testData_activity,testData)
testData  <-cbind(testData_subject,testData)

trainData <-cbind(trainData_activity,trainData)
trainData <-cbind(trainData_subject,trainData)

oneDataset <-rbind(testData,trainData)

# extracts only the measurements on the mean and standard deviation for each measurement
# find all variable names containg the word "mean" and "std"
data_mean_std <- oneDataset[, grepl("*.mean.*", colnames(oneDataset)) | grepl("*.std.*", colnames(oneDataset))]
data_subj_act <-subset(oneDataset, select=c(Subject_Id, Activity_Id, Activity_Name))
data          <- cbind(data_subj_act, data_mean_std)

# reshape the data for processing
id_variables       <- c("Subject_Id", "Activity_Id", "Activity_Name")
measure_variables  <- setdiff(colnames(data), id_variables)
melt_data          <- melt(data, id = id_variables, measure.vars = data_labels)

# aply mean function to dataset using dcast function
tidy_data   <- dcast(melt_data, Subject_Id + Activity_Name ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
