### Introduction
This code was submitted as an assignment on the 'Getting and Cleaning Data' course.  The objective is to download and clean a set of data.  The raw data is [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and the authors of [1] are acknowledged in providing use of this data set.

The objectives set out in the coursework are as follows:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In this document, an explanation shall be provided as to how the above objectives were achieved.  The processing code is called ```run_analysis.R``` and is available on this repo.

### Getting Data
The data is available on the internet.  The function, ```get.data()``` is used to download the data to the working directory:
```
get.data <- function(){
        data.url <- paste("http://d396qusza40orc.cloudfront.net/", 
                "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", sep = "")
        td <- tempdir()
        tf <- tempfile(tmpdir = td, fileext = ".zip")
        download.file(data.url, tf, method = "curl")
        unzip(tf, exdir = "./data", overwrite = TRUE)
        unlink(tf) 
}
```
The function performs the following operations:

* The zip file is downloaded to a temporary directory
* The files extracted to a folder called 'data' in the working directory
* The temporary folder is deleted.  

Notice that when the function is called in the main code i.e.

```if (!file.exists("./data")){get.data()}```

that the data is only downloaded if it has not already been.  This saves unnecessary time being used to download the large file.

### Reading and Labeling Data

After downloading the data, the ```read.data()``` function is used to read the data into data frames.  
```
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
```
Descriptive names are applied to the variables in this function along with appropriate classing where necessary.  Note the use of C-type formatted strings e.g.

```sprintf("subject_%s.txt", set)```

This substituts ```set``` to the file name which enables the file names to be set at runtime basd on whether the 'train' or 'test' data is required (the reason for doing this is so as not to repeat the code for both 'train' and 'test' data).  Note also that the data group, 'train' of 'test' is stored so as to identify from which group it has come from.

### Merging Training and Test Data
Once the above is done, merging is quite trivial.  It is just a matter of binding the training and test data together i.e.
```
arrange(rbind(test.data, train.data), ID)
```
Note that the data is arranged by ID for tidiness.

### Extracting Data
A regular expression is used to find variables which contain 'mean' or 'std'.  Also, it is assumed that the 'meanFreq' data is *not* required; hence, the pattern is designed to not match 'mean' if it is followed by 'F':
```
p <- "mean[^F]|std"             
extract <- grep(p , names(my.data.1), value = TRUE) 
my.data.1 <- my.data.1[, c("ID", "activity", "set", extract)]
```

### Labling Activity Names
This is simply achieved by renaming the levels of the 'activity' to the names provided.  These are given in the file ```activity_lables.txt``` that came with the data.  The code is
```
levels(my.data.1$activity) <- activity.code$activity.code
```
where ```activity.code``` was previously read in from the file stated above.

### Averaging Variable by ID and Activity
This is achieved with line of code:
```
my.data.2 <- ddply(my.data.1, .(ID, activity, set), {numcolwise(mean)})
```
This splits the data by 'ID' and 'activity' and then averages each column of numerical data.  Also, the variable 'set' is retained for future reference - this has no effect on the groupings.

Since I am not familiar with the ```ddply``` function, I performed a quick test to confirm that correct operation was being performed.  The operation can be performed using and alternative approach: 
```
temp <- split(my.data.1, list(my.data.1$ID, my.data.1$activity))
mean(temp[[1]][,4]) == my.data.2[1, 4]
```
It was confirmed that the two approaches are equivalent.

### References
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012