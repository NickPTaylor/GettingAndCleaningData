################################################################################
#
# Name:         run_analysis.R
# Author:       N P Taylor
# Date:         25/07/14
#
# Desicription: This program was prepared for a coursework submission for the 
#               Coursera course 'Getting and Cleaning Data'.  The aim of the 
#               program is download and clean data collected from smartphone
#               accelorometers.  Details on the data are given here:
#
#                       http://archive.ics.uci.edu/ml/datasets/
#                               Human+Activity+Recognition+Using+Smartphones
#
#               The coursework set the following tasks:
#       
#                       * Merges the training and the test sets to create one 
#                       data set.
#                       * Extracts only the measurements on the mean and 
#                       standard deviation for each measurement. 
#                       * Uses descriptive activity names to name the activities 
#                       in the data set.
#                       * Appropriately labels the data set with descriptive 
#                       variable names.
#                       * Creates a second, independent tidy data set with the 
#                       average of each variable for each activity and each 
#                       subject.
#
#               This program executes those tasks.
#
################################################################################

################################################################################
#
# Function:     get.data
# Purpose:      Download the data
# INPUT:        NONE
# OUTPUT:       NONE
# Description   The function downloads the zipped data from the internet to a 
#               temporary folder, unzips it to a "data" folder and then deletes
#               the temporary folder.
#
################################################################################
get.data <- function(){
        data.url <- paste("http://d396qusza40orc.cloudfront.net/", 
                "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", sep = "")
        td <- tempdir()
        tf <- tempfile(tmpdir = td, fileext=".zip")
        download.file(my.url, tf, method = "curl")
        unzip(tf, exdir = "./data", overwrite = TRUE)
        unlink(tf) 
}

################################################################################
#
# Function:     read.data
# Purpose:      Read the data into data.frames
# INPUT:        <character> set :- read "train" or "test" set 
# OUTPUT:       <data.frame> my.data :- data
# Description   The reads the test and training data.  The function uses C
#               formatting to create the file name basd on whether it is 
#               reading test or traning data.  Where appropriate, columns are
#               classed as 'factors'.  The variable 'set' is created to be 
#               appended to the data frame - this indicates from which set the 
#               data belongs.  Finally, all data items are bound into a single
#               data frame.
#
################################################################################
read.data <- function(set){
    
        my.dir = paste(c(".", "data", "UCI HAR Dataset", set), collapse = "/")
    
        # read data items
        ID <- read.table(file = 
                paste(c(my.dir, sprintf("subject_%s.txt", set)), collapse = "/"),
                col.names = "ID",
                colClasses = ("ID" = "factor"))
        activity <- read.table(file = 
                paste(c(my.dir, sprintf("y_%s.txt", set)), collapse = "/"),
                col.names = "activity",
                colClasses = c("activity" = "factor"))
        measured <- read.table(file = 
                paste(c(my.dir, sprintf("X_%s.txt", set)), collapse = "/"),
                col.names = measured.code$measured.code)
        set <- data.frame(set = rep(set, dim(ID)[1]))
    
        # bind data
        my.data <- cbind(ID = ID$ID, 
                activity = activity$activity, 
                set = set$set,
                measured)  
}

################################################################################
#
# Function:     Main Program
#
################################################################################

# initial set-up
setwd("/home/nick/Desktop/NewDocs/Github/GettingAndCleaningData/courseWork")
data.dir <- "./data/UCI HAR Dataset"

# get data, if required
if (!file.exists("./data")){get.data()}

# read data, if required
check.names = c("measured.code", "activity.code", "test.data", "train.data")
if(!all(sapply(check.names, exists))){
        measured.code <- read.table(
                paste(c(data.dir, "features.txt"), collapse = "/"), 
                col.names = c("", "measured.code"))
        activity.code <- read.table(
                paste(c(data.dir, "activity_labels.txt"), collapse = "/"), 
                col.names = c("", "activity.code"))
        test.data <- read.data("test")
        train.data <- read.data("train")  
}