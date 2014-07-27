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
#               The coursework set the following requirement:
#       
#                       1. Merges the training and the test sets to create one 
#                       data set.
#                       2. Extracts only the measurements on the mean and 
#                       standard deviation for each measurement. 
#                       3. Uses descriptive activity names to name the activities 
#                       in the data set.
#                       4. Appropriately labels the data set with descriptive 
#                       variable names.
#                       5. Creates a second, independent tidy data set with the 
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
        download.file(data.url, tf, method = "curl")
        unzip(tf, exdir = "./data", overwrite = TRUE)
        unlink(tf) 
}

################################################################################
#
# Function:     read.data
# Purpose:      Read the data into data.frames
# INPUT:        <character> set :- read "train" or "test" set 
#               <data.frame> code :- names for measured data
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
read.data <- function(set, code){
    
        my.dir = paste(c(".", "data", "UCI HAR Dataset", set), collapse = "/")
    
        # read data items
        # REQUIREMENT 4: Appropriate data names
        # data is named appropriately from the outset
        # note that the measured.code gives the names for the 'measured' data
        
        ID <- read.table(file = 
                paste(c(my.dir, sprintf("subject_%s.txt", set)), collapse = "/"),
                col.names = "ID",
                colClasses = ("ID" = "integer"))
        activity <- read.table(file = 
                paste(c(my.dir, sprintf("y_%s.txt", set)), collapse = "/"),
                col.names = "activity",
                colClasses = c("activity" = "factor"))
        measured <- read.table(file = 
                paste(c(my.dir, sprintf("X_%s.txt", set)), collapse = "/"),
                col.names = code$measured.code)
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
library(plyr)

# initial set-upS
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
        test.data <- read.data("test", measured.code)
        train.data <- read.data("train", measured.code)  
}

# REQUIREMENT 1: Merge data
my.data.1 <- arrange(rbind(test.data, train.data), ID)

# REQUIREMENT 2: Extract data
# extract column names for mean and std but NOT meanFreq using grep
# and we also need 'ID', 'activity' and 'set'
p <- "mean[^F]|std"             
extract <- grep(p , names(my.data.1), value = TRUE) 
my.data.1 <- my.data.1[, c("ID", "activity", "set", extract)]

# REQUIREMENT 3: Descriptive activity names
# set levels as per activity.code
levels(my.data.1$activity) <- activity.code$activity.code

# REQUIREMENT 5: Average each variable by activity and subject 
my.data.2 <- ddply(my.data.1, .(ID, activity), transform, 
        {set = set; numcolwise(mean)})
write.csv(my.data.2, file = "data.csv")
