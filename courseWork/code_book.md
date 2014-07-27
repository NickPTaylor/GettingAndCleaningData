### Introduction
This code book is derived from the data available from [here](
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  Refer to ```features_info.txt``` and ```features.txt``` in the data set for full background detail. 

The measured variables are from the accelerometers in smart phones.  Each variable name is self-explanatory and will not be detailed below.  The measured variable names are writen according to the following convention:

        pName.stat...C

        p .prefix
                .t is for frequency domain
                .f is for frequency domain
        Name .Name of Measurement
        stat .type of statistic applied to measurement
                .mean is for mean of measured data
                .std is for mean of std data
        C .co-ordiate direction of measurement (only used where appropriate)
        
In addition, each measurement is categorised by ID and activity (see below for description) and then averaged.

Here is an example:

        tBodyAcc.mean...X
                Units: m/s^2
                Time domain mean body acceleration along the x axis averaged (mean) for each ID and activity grouping.

### Code Book

        ID
                Case (person) ID
                        1..30 .Person ID range from 1 to 30
        
        activity
                 Activity being performed
                        1 .WALKING 
                        2 .WALKING_UPSTAIRS 
                        3 .WALKING_DOWNSTAIRS 
                        4 .SITTING 
                        5 .STANDING 
                        6 .LAYING 
        set
                Set of data to which case is randomly assigned
                        1 .test
                        2. train
                
        tBodyAcc.mean...X
        tBodyAcc.mean...Y
        tBodyAcc.mean...Z
        tBodyAcc.std...X
        tBodyAcc.std...Y
        tBodyAcc.std...Z
        tGravityAcc.mean...X
        tGravityAcc.mean...Y
        tGravityAcc.mean...Z
        tGravityAcc.std...X
        tGravityAcc.std...Y
        tGravityAcc.std...Z
        tBodyAccJerk.mean...X
        tBodyAccJerk.mean...Y
        tBodyAccJerk.mean...Z
        tBodyAccJerk.std...X
        tBodyAccJerk.std...Y
        tBodyAccJerk.std...Z
        tBodyGyro.mean...X
        tBodyGyro.mean...Y
        tBodyGyro.mean...Z
        tBodyGyro.std...X
        tBodyGyro.std...Y
        tBodyGyro.std...Z
        tBodyGyroJerk.mean...X
        tBodyGyroJerk.mean...Y
        tBodyGyroJerk.mean...Z
        tBodyGyroJerk.std...X
        tBodyGyroJerk.std...Y
        tBodyGyroJerk.std...Z
        tBodyAccMag.mean..
        tBodyAccMag.std..
        tGravityAccMag.mean..
        tGravityAccMag.std..
        tBodyAccJerkMag.mean..
        tBodyAccJerkMag.std..
        tBodyGyroMag.mean..
        tBodyGyroMag.std..
        tBodyGyroJerkMag.mean..
        tBodyGyroJerkMag.std..
        fBodyAcc.mean...X
        fBodyAcc.mean...Y
        fBodyAcc.mean...Z
        fBodyAcc.std...X
        fBodyAcc.std...Y
        fBodyAcc.std...Z
        fBodyAccJerk.mean...X
        fBodyAccJerk.mean...Y
        fBodyAccJerk.mean...Z
        fBodyAccJerk.std...X
        fBodyAccJerk.std...Y
        fBodyAccJerk.std...Z
        fBodyGyro.mean...X
        fBodyGyro.mean...Y
        fBodyGyro.mean...Z
        fBodyGyro.std...X
        fBodyGyro.std...Y
        fBodyGyro.std...Z
        fBodyAccMag.mean..
        fBodyAccMag.std..
        fBodyBodyAccJerkMag.mean..
        fBodyBodyAccJerkMag.std..
        fBodyBodyGyroMag.mean..
        fBodyBodyGyroMag.std..
        fBodyBodyGyroJerkMag.mean..
        fBodyBodyGyroJerkMag.std..