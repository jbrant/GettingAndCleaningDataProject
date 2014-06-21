## Install required libraries if missing
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}

require(data.table, quietly=TRUE)
require(reshape2, quietly=TRUE)

file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file.name <- "./UCI HAR Dataset.zip"
data.dir <- "./UCI HAR Dataset"

## Download file if it doesn't exist
if (!file.exists(file.name)) {
  
  cat("Downloading dataset...\n")
  
  if (Sys.info()[["sysname"]] == "Darwin") {
    download.file(url=file.url, destfile=file.name, method="curl", quiet=TRUE)
  }
  else {
    download.file(url=file.url, destfile=file.name, quiet=TRUE)
  }
}

## Extract file if HAR data directory doesn't exist
if (!file.exists(data.dir)) {
  cat("Unzipping dataset...\n")
  unzip(zipfile=file.name)
}

## This function reads the data files first as a data frame then converts to a data table.
## This is because the current revision of data.table has a bug that requires data in the
## first column of the input file (it is blank in this data set).
read.data.files <- function(data.file) {  
  df.dataset <- read.table(data.file)
  dt.dataset <- data.table(df.dataset)
}

## In order to avoid expensive, repeated reads of the data set files, this function caches
## the three datasets we're interested in from both the training and test sets (the activities,
## subjects, and the dataset itself).
cached.dataset <- function(dataset.filepath, 
                          dataset.activities.filepath, 
                          dataset.subjects.filepath) {
  
  ## Initialize data set to NULL
  dataset <- NULL
  dataset.activities <- NULL
  dataset.subjects <- NULL
  
  ## Sets dataset file path to new value and caches it
  set.dataset.filepath <- function(new.dataset.filepath) {
    
    ## Cache dataset file path
    dataset.filepath <<- new.dataset.filepath
    
    ## Reset dataset
    dataset <<- NULL
  }
  
  ## Sets dataset activities file path to new value and caches it
  set.dataset.activities.filepath <- function(new.dataset.activities.filepath) {
    
    ## Cache dataset activities file path
    dataset.activities.filepath <<- new.dataset.activities.filepath
    
    ## Reset dataset activities
    dataset.activities <<- NULL
  }
  
  ## Sets dataset subjects file path to new value and caches it
  set.dataset.subjects.filepath <- function(new.dataset.subjects.filepath) {
    
    ## Cache dataset subjects file path
    dataset.subjects.filepath <<- new.dataset.subjects.filepath
    
    ## Reset dataset subjects
    dataset.subjects <<- NULL
  }
  
  ## Gets the current dataset file path
  get.dataset.filepath <- function() dataset.filepath
  
  ## Gets the current dataset activities file path
  get.dataset.activities.filepath <- function() dataset.activities.filepath
  
  ## Gets the current dataset subjects file path
  get.dataset.subjects.filepath <- function() dataset.subjects.filepath
  
  ## Sets the dataset to new value and caches it
  set.dataset <- function(newDataSet) dataset <<- newDataSet
  
  ## Sets the dataset activities to new value and caches it
  set.dataset.activities <- function(newDataSetActivities) dataset.activities <<- newDataSetActivities
  
  ## Sets the dataset subjects to new value and caches it
  set.dataset.subjects <- function(newDataSetSubjects) dataset.subjects <<- newDataSetSubjects
  
  ## Gets the current dataset
  get.dataset <- function() dataset
  
  ## Gets the current dataset activities
  get.dataset.activities <- function() dataset.activities
  
  ## Gets the current dataset subjects
  get.dataset.subjects <- function() dataset.subjects
  
  ## Returns list of functions
  list(set.dataset.filepath = set.dataset.filepath,
       set.dataset.activities.filepath = set.dataset.activities.filepath,
       set.dataset.subjects.filepath = set.dataset.subjects.filepath,
       get.dataset.filepath = get.dataset.filepath,
       get.dataset.activities.filepath = get.dataset.activities.filepath,
       get.dataset.subjects.filepath = get.dataset.subjects.filepath,
       set.dataset = set.dataset,
       set.dataset.activities = set.dataset.activities,
       set.dataset.subjects = set.dataset.subjects,
       get.dataset = get.dataset,
       get.dataset.activities = get.dataset.activities,
       get.dataset.subjects = get.dataset.subjects)
}

## Handles loading the instance of the dataset object and caching the result.
load.dataset.content <- function(cached.dataset) {
  
  ## Gets the current data set, activities, and subjects
  cur.dataset <- cached.dataset$get.dataset()
  cur.dataset.activities <- cached.dataset$get.dataset.activities()
  cur.dataset.subjects <- cached.dataset$get.dataset.subjects()
  
  ## Load dataset
  cat("Loading dataset...\n")
  if (is.null(cur.dataset)) {
    cached.dataset$set.dataset(read.data.files(cached.dataset$get.dataset.filepath()))
  }
  
  ## Load dataset activities
  cat("Loading dataset activities...\n")
  if (is.null(cur.dataset.activities)) {
    cached.dataset$set.dataset.activities(fread(cached.dataset$get.dataset.activities.filepath()))
  }
  
  ## Load dataset subjects
  cat("Loading dataset subjects...\n")
  if (is.null(cur.dataset.subjects)) {
    cached.dataset$set.dataset.subjects(cur.dataset.subjects <- fread(cached.dataset$get.dataset.subjects.filepath()))
  }
}

## Merges dataset, subjects, and activities and returns the sorted result.
merge.datasets <- function() {
  
  ## Row bind the datasets themselves
  merged.dataset.data <- rbind(training.dataset$get.dataset(), test.dataset$get.dataset())
  
  ## Row bind the subjects and set meaningful name
  merged.subjects <- rbind(training.dataset$get.dataset.subjects(), test.dataset$get.dataset.subjects())
  setnames(merged.subjects, "V1", "Subject")
  
  ## Row bind the activities
  merged.activities <- rbind(training.dataset$get.dataset.activities(), test.dataset$get.dataset.activities())
  setnames(merged.activities, "V1", "ActivityID")
  
  ## Column bind the data, subjects and activities
  merged.result <- cbind(merged.dataset.data, merged.subjects, merged.activities)
  
  ## Sort data table by subject and activity ID
  setkey(merged.result, Subject, ActivityID)
  
  ## Return merged dataset
  merged.result
}

## Extracts only the mean and standard deviation features from the features list
extract.mean.stddev.features <- function(feature.filepath) {
  
  ## Read in the features file
  all.features <- fread(feature.filepath)
  
  ## Cleanup the column names
  setnames(all.features, names(all.features), c("FeatureID", "FeatureName"))
  
  ## Extract mean and standard deviation
  mean.stddev.features <- all.features[grepl(pattern="mean\\(\\)|std\\(\\)", x=FeatureName),]

  ## Align column names to those in merged dataset and store 
  ## in new data table variable
  mean.stddev.features$FeatureCode <- mean.stddev.features[, paste("V", FeatureID, sep="")]
  
  ## Return mean/standard deviation feature vector
  mean.stddev.features
}

#################################################################
## Start Execution
#################################################################

## Establish top level dataset path
#! Update to dynamically read in directory with data files
har.data.dir <- file.path(getwd(), "UCI HAR Dataset")

## Read in activity labels and set new column names
cat("Reading activity labels...\n")
activity.labels <- fread(input=file.path(har.data.dir, "activity_labels.txt"))
setnames(activity.labels, names(activity.labels), c("ActivityID", "ActivityName"))

## Initialize training dataset if it doesn't exist
cat("Initializing training dataset...\n")
if(!exists("training.dataset")) {
  training.dataset <- cached.dataset(dataset.filepath=file.path(har.data.dir, "train", "X_train.txt"),
                      dataset.activities.filepath=file.path(har.data.dir, "train", "y_train.txt"),
                      dataset.subjects.filepath=file.path(har.data.dir, "train", "subject_train.txt"))
}

## Initialize test dataset if it doesn't exist
cat("Initializing test dataset...\n")
if (!exists("test.dataset")) {
  test.dataset <- cached.dataset(dataset.filepath=file.path(har.data.dir, "test", "X_test.txt"),
                             dataset.activities.filepath=file.path(har.data.dir, "test", "y_test.txt"),
                             dataset.subjects.filepath=file.path(har.data.dir, "test", "subject_test.txt"))
}

## Load training dataset
cat("Loading training dataset...\n")
load.dataset.content(cached.dataset=training.dataset)

## Load test dataset
cat("Loading test dataset...\n")
load.dataset.content(cached.dataset=test.dataset)

## Merge the datasets
cat("Merging training and test datasets...\n")
merged.dataset <- merge.datasets()

## Extract mean and standard deviation features
cat("Extract mean and standard deviation features...\n")
features <- extract.mean.stddev.features(feature.filepath=file.path(har.data.dir, "features.txt"))

## Combine feature code columns with merged data set keys (subject and activity)
merged.feature.columns <- c(key(merged.dataset), features$FeatureCode)

## Subset the merged dataset using existing feature codes
merged.dataset <- merged.dataset[, merged.feature.columns, with=FALSE]

## Merge the activity labels into the dataset column headers
cat("Merging activity labels...\n")
merged.dataset <- merge(x=merged.dataset, y=activity.labels, by="ActivityID")

## Sort data table by subject, activity ID, and activity name
setkeyv(x=merged.dataset, cols=c("Subject", "ActivityID", "ActivityName"))  

## Flatten the dataset and add FeatureID as a column (for joining to feature dataset)
cat("Melting to long dataset...\n")
merged.dataset <- as.data.table(melt(data=merged.dataset, id.vars=key(merged.dataset), variable.name="FeatureCode"))

## Merge activity name, joining on feature code
cat("Merging feature labels...\n")
merged.dataset <- merge(x=merged.dataset, y=features[, list(FeatureCode, FeatureName)], by="FeatureCode")

## Sort data table by all labels
setkeyv(x=merged.dataset, cols=c("Subject", 
                                "ActivityID", 
                                "ActivityName", 
                                "FeatureCode", 
                                "FeatureName"))

## Convert to tidy dataset, taking mean by subject and activity
cat("Creating tidy dataset...\n")
tidy.dataset <- dcast(data=merged.dataset, formula=Subject + ActivityName ~ FeatureName, mean)

## Write tidy dataset to output file
cat("Writing tidy dataset...\n")
write.table(x=tidy.dataset, file="./TidyData.txt", row.names=FALSE)

cat("-------------------------------------\n")
cat("Finished!  Output is in TidyData.txt")