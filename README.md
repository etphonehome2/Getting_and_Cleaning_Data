# Getting_and_Cleaning_Data
Coursera Getting_and_Cleaning_Data

"Getting and Cleaning Data" Project Description

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare a tidy data that can be used for later analysis. 

For this project, data was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained can be found by clicking on this link [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data for the project can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The R script, run_analysis.R, will perform the the following:

 - Merges the training and the test sets to create one data set
-     Extracts only the measurements on the mean and standard deviation for each measurement 
-     Uses descriptive activity names to name the activities in the data set
-     Appropriately labels the data set with descriptive variable names
-     Using the preceeding data set, a second independent tidy data set with the average of each variable for each activity and each subject will be created

### Repository Contents ###

-     **CodeBook.md**: describes the variables, the data, and transformations performed to clean up the data
-     **LICENSE**:     license terms for text and code
-     **README.md**:   this file
-     **run_analysis.R**: R script to transform raw data set in a tidy one

### How to create the tidy data set ###

-     open the R console
-     copy the R script to your current working directory
-     execute the script by typing "source('run_analysis.R)"
-     the tidy data set will be created in your current work directory
