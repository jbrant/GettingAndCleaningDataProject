TidyData Codebook
========================================================

## Human Activity Recognition Dataset Description
*Note: this is taken from the HAR dataset readme.*

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

## Data Sources
The Human Activity Recognition Dataset was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

The following data files are utilized for this analysis:

| Data File           | Description                                      |
|:--------------------|:-------------------------------------------------|
| features.txt        | Mapping of feature key to feature name.          |
| activity_labels.txt | Mapping of activity key to activity description. |
| X_train.txt         | Training dataset.                                |
| y_train.txt         | Training activity label IDs.                     |
| X_test.txt          | Test dataset.                                    |
| y_test.txt          | Test activity label IDs.                         |

## Feature Variables
The tidy dataset contains the following variables (from left to right in the order listed):

| Variable Name                 | Description                                                                              	|
|:-----------------------------	|:-----------------------------------------------------------------------------------------	|
| Subject                     	| ID of subject performing activity.                                                       	|
| ActivityName                	| Name of activity being performed.                                                        	|
| fBodyAcc-mean()-X           	| Mean frequency of body acceleration for X-component of direction.                        	|
| fBodyAcc-mean()-Y           	| Mean frequency of body acceleration for Y-component of direction.                        	|
| fBodyAcc-mean()-Z           	| Mean frequency of body acceleration for Z-component of direction.                        	|
| fBodyAcc-std()-X            	| Standard deviation of frequency of body acceleration for X-component of direction.       	|
| fBodyAcc-std()-Y            	| Standard deviation of frequency of body acceleration for Y-component of direction.       	|
| fBodyAcc-std()-Z            	| Standard deviation of frequency of body acceleration for Z-component of direction.       	|
| fBodyAccJerk-mean()-X       	| Mean frequency of body acceleration jerk for X-component of direction.                   	|
| fBodyAccJerk-mean()-Y       	| Mean frequency of body acceleration jerk for Y-component of direction.                   	|
| fBodyAccJerk-mean()-Z       	| Mean frequency of body acceleration jerk for Z-component of direction.                   	|
| fBodyAccJerk-std()-X        	| Standard deviation of frequency of body acceleration jerk for X-component of direction.  	|
| fBodyAccJerk-std()-Y        	| Standard deviation of frequency of body acceleration jerk for Y-component of direction.  	|
| fBodyAccJerk-std()-Z        	| Standard deviation of frequency of body acceleration jerk for Z-component of direction.  	|
| fBodyAccMag-mean()          	| Mean frequency of body acceleration magnitude.                                           	|
| fBodyAccMag-std()           	| Standard deviation of frequency of body acceleration magnitude.                          	|
| fBodyBodyAccJerkMag-mean()  	| Mean frequency of body acceleration jerk magnitude.                                      	|
| fBodyBodyAccJerkMag-std()   	| Standard deviation of frequency of body acceleration jerk magnitude.                     	|
| fBodyBodyGyroJerkMag-mean() 	| Mean frequency of body momentum jerk magnitude.                                          	|
| fBodyBodyGyroJerkMag-std()  	| Standard deviation of body momentum jerk magnitude.                                      	|
| fBodyBodyGyroMag-mean()     	| Mean frequency of body momentum magnitude.                                               	|
| fBodyBodyGyroMag-std()      	| Standard deviation of body momentum magnitude.                                           	|
| fBodyGyro-mean()-X          	| Mean frequency of body momentum for X-component of direction.                            	|
| fBodyGyro-mean()-Y          	| Mean frequency of body momentum for Y-component of direction.                            	|
| fBodyGyro-mean()-Z          	| Mean frequency of body momentum for Z-component of direction.                            	|
| fBodyGyro-std()-X           	| Standard deviation of frequency of body momentum for X-component of direction.           	|
| fBodyGyro-std()-Y           	| Standard deviation of frequency of body momentum for Y-component of direction.           	|
| fBodyGyro-std()-Z           	| Standard deviation of frequency of body momentum for Z-component of direction.           	|
| tBodyAcc-mean()-X           	| Mean time of body acceleration for X-component of direction.                             	|
| tBodyAcc-mean()-Y           	| Mean time of body acceleration for Y-component of direction.                             	|
| tBodyAcc-mean()-Z           	| Mean time of body acceleration for Z-component of direction.                             	|
| tBodyAcc-std()-X            	| Standard deviation of time of body acceleration for X-component of direction.            	|
| tBodyAcc-std()-Y            	| Standard deviation of time of body acceleration for Y-component of direction.            	|
| tBodyAcc-std()-Z            	| Standard deviation of time of body acceleration for Z-component of direction.            	|
| tBodyAccJerk-mean()-X       	| Mean time for body acceleration jerk for X-component of direction.                       	|
| tBodyAccJerk-mean()-Y       	| Mean time for body acceleration jerk for Y-component of direction.                       	|
| tBodyAccJerk-mean()-Z       	| Mean time for body acceleration jerk for Z-component of direction.                       	|
| tBodyAccJerk-std()-X        	| Standard deviation of time for body acceleration jerk for X-component of direction.      	|
| tBodyAccJerk-std()-Y        	| Standard deviation of time for body acceleration jerk for Y-component of direction.      	|
| tBodyAccJerk-std()-Z        	| Standard deviation of time for body acceleration jerk for Z-component of direction.      	|
| tBodyAccJerkMag-mean()      	| Mean time for body acceleration jerk magnitude.                                          	|
| tBodyAccJerkMag-std()       	| Standard deviation of time for body acceleration jerk magnitude.                         	|
| tBodyAccMag-mean()          	| Mean time for body acceleration magnitude.                                               	|
| tBodyAccMag-std()           	| Standard deviation of time for body acceleration magnitude.                              	|
| tBodyGyro-mean()-X          	| Mean time for body momentum for X-component of direction.                                	|
| tBodyGyro-mean()-Y          	| Mean time for body momentum for Y-component of direction.                                	|
| tBodyGyro-mean()-Z          	| Mean time for body momentum for Z-component of direction.                                	|
| tBodyGyro-std()-X           	| Standard deviation of time for body momentum for X-component of direction.               	|
| tBodyGyro-std()-Y           	| Standard deviation of time for body momentum in Y-component of direction.                	|
| tBodyGyro-std()-Z           	| Standard deviation of time for body momentum for Z-component of direction.               	|
| tBodyGyroJerk-mean()-X      	| Mean time for body momentum jerk for X-component of direction.                           	|
| tBodyGyroJerk-mean()-Y      	| Mean time for body momentum jerk for Y-component of direction.                           	|
| tBodyGyroJerk-mean()-Z      	| Mean time for body momentum jerk for Z-component of direction.                           	|
| tBodyGyroJerk-std()-X       	| Standard deviation of time for body momentum jerk for X-component of direction.          	|
| tBodyGyroJerk-std()-Y       	| Standard deviation of time for body momentum jerk for Y-component of direction.          	|
| tBodyGyroJerk-std()-Z       	| Standard deviation of time for body momentum jerk for Z-component of direction.          	|
| tBodyGyroJerkMag-mean()     	| Mean time for body momentum jerk magnitude.                                              	|
| tBodyGyroJerkMag-std()      	| Standard deviation of time for body momentum jerk magnitude.                             	|
| tBodyGyroMag-mean()         	| Mean time for body momentum magnitude.                                                   	|
| tBodyGyroMag-std()          	| Standard deviation of time for body momentum magnitude.                                  	|
| tGravityAcc-mean()-X        	| Mean time for acceleration due to gravity for X-component of direction.                  	|
| tGravityAcc-mean()-Y        	| Mean time for acceleration due to gravity for Y-component of direction.                  	|
| tGravityAcc-mean()-Z        	| Mean time for acceleration due to gravity for Z-component of direction.                  	|
| tGravityAcc-std()-X         	| Standard deviation of time for acceleration due to gravity for X-component of direction. 	|
| tGravityAcc-std()-Y         	| Standard deviation of time for acceleration due to gravity for Y-component of direction. 	|
| tGravityAcc-std()-Z         	| Standard deviation of time for acceleration due to gravity for Z-component of direction. 	|
| tGravityAccMag-mean()       	| Mean time for acceleration magnitude due to gravity.                                     	|
| tGravityAccMag-std()        	| Standard deviation of time for acceleration magnitude due to gravity.                    	|