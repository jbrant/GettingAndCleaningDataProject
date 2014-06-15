require(data.table)

## This function reads the data files first as a data frame then converts to a data table.
## This is because the current revision of data.table has a bug that requires data in the
## first column of the input file (it is blank in this data set).
readDataFiles <- function(dataFile) {
  dfDataSet <- read.table(dataFile)
  dtDataSet <- data.table(dfDataSet)
}

## In order to avoid expensive, repeated reads of the data set files, this function caches
## the three datasets we're interested in from both the training and test sets (the activities,
## subjects, and the dataset itself).
cachedDataSet <- function(dataSetFilePath, 
                          dataSetActivitiesFilePath, 
                          dataSetSubjectsFilePath) {
  
  ## Initialize data set to NULL
  dataSet <- NULL
  dataSetActivities <- NULL
  dataSetSubjects <- NULL
  
  ## Sets dataset file path to new value and caches it
  setDataSetFilePath <- function(newDataSetFilePath) {
    
    ## Cache dataset file path
    dataSetFilePath <<- newDataSetFilePath
    
    ## Reset dataset
    dataSet <<- NULL
  }
  
  ## Sets dataset activities file path to new value and caches it
  setDataSetActivitiesFilePath <- function(newDataSetActivitiesFilePath) {
    
    ## Cache dataset activities file path
    dataSetActivitiesFilePath <<- newDataSetActivitiesFilePath
    
    ## Reset dataset activities
    dataSetActivities <<- NULL
  }
  
  ## Sets dataset subjects file path to new value and caches it
  setDataSetSubjectsFilePath <- function(newDataSetSubjectsFilePath) {
    
    ## Cache dataset subjects file path
    dataSetSubjectsFilePath <<- newDataSetSubjectsFilePath
    
    ## Reset dataset subjects
    dataSetSubjects <<- NULL
  }
  
  ## Gets the current dataset file path
  getDataSetFilePath <- function() dataSetFilePath
  
  ## Gets the current dataset activities file path
  getDataSetActivitiesFilePath <- function() dataSetActivitiesFilePath
  
  ## Gets the current dataset subjects file path
  getDataSetSubjectsFilePath <- function() dataSetSubjectsFilePath
  
  ## Sets the dataset to new value and caches it
  setDataSet <- function(newDataSet) dataSet <<- newDataSet
  
  ## Sets the dataset activities to new value and caches it
  setDataSetActivities <- function(newDataSetActivities) dataSetActivities <<- newDataSetActivities
  
  ## Sets the dataset subjects to new value and caches it
  setDataSetSubjects <- function(newDataSetSubjects) dataSetSubjects <<- newDataSetSubjects
  
  ## Gets the current dataset
  getDataSet <- function() dataSet
  
  ## Gets the current dataset activities
  getDataSetActivities <- function() dataSetActivities
  
  ## Gets the current dataset subjects
  getDataSetSubjects <- function() dataSetSubjects
  
  ## Returns list of functions
  list(setDataSetFilePath = setDataSetFilePath,
       setDataSetActivitiesFilePath = setDataSetActivitiesFilePath,
       setDataSetSubjectsFilePath = setDataSetSubjectsFilePath,
       getDataSetFilePath = getDataSetFilePath,
       getDataSetActivitiesFilePath = getDataSetActivitiesFilePath,
       getDataSetSubjectsFilePath = getDataSetSubjectsFilePath,
       setDataSet = setDataSet,
       setDataSetActivities = setDataSetActivities,
       setDataSetSubjects = setDataSetSubjects,
       getDataSet = getDataSet,
       getDataSetActivities = getDataSetActivities,
       getDataSetSubjects = getDataSetSubjects)
}

## Handles loading the instance of the dataset object and caching the result.
loadDataSetContent <- function(cachedDataSet) {
  
  ## Gets the current data set, activities, and subjects
  curDataSet <- cachedDataSet$getDataSet()
  curDataSetActivities <- cachedDataSet$getDataSetActivities()
  curDataSetSubjects <- cachedDataSet$getDataSetSubjects()
  
  ## Load dataset
  if (is.null(curDataSet)) {
    message("setting cached dataset")
    cachedDataSet$setDataSet(readDataFiles(cachedDataSet$getDataSetFilePath()))
  }
  
  ## Load dataset activities
  if (is.null(curDataSetActivities)) {
    message("setting cached dataset activities")
    cachedDataSet$setDataSetActivities(fread(cachedDataSet$getDataSetActivitiesFilePath()))
  }
  
  ## Load dataset subjects
  if (is.null(curDataSetSubjects)) {
    message("setting cached dataset subjects")
    cachedDataSet$setDataSetSubjects(curDataSetSubjects <- fread(cachedDataSet$getDataSetSubjectsFilePath()))
  }
  
  ## Return the data table with content loaded
  #cachedDataSet
}

## Merges dataset, subjects, and activities and returns the sorted result.
mergeDataSets <- function() {
  
  ## Row bind the datasets themselves
  mergedDataSetData <- rbind(trainingDataSet$getDataSet(), testDataSet$getDataSet())
  
  ## Row bind the subjects and set meaningful name
  mergedSubjects <- rbind(trainingDataSet$getDataSetSubjects(), testDataSet$getDataSetSubjects())
  setnames(mergedSubjects, "V1", "Subject")
  
  ## Row bind the activities
  mergedActivities <- rbind(trainingDataSet$getDataSetActivities(), testDataSet$getDataSetActivities())
  setnames(mergedActivities, "V1", "Activity")
  
  ## Column bind the data, subjects and activities
  mergedResult <- cbind(mergedDataSetData, mergedSubjects, mergedActivities)
  
  ## Set subject and activity as the composite key
  setkey(mergedResult, Subject, Activity)
  
  ## Return merged dataset
  mergedResult
}

## Extracts only the mean and standard deviation features from the features list
extractMeanAndStdDevFeatures <- function(featureFilePath) {
  
  ## Read in the features file
  allFeatures <- fread(featureFilePath)
  
  ## Cleanup the column names
  setnames(allFeatures, names(allFeatures), c("FeatureID", "FeatureName"))
  
  ## Extract mean and standard deviation
  meanStdFeatures <- allFeatures[grepl(pattern="mean\\(\\)|std\\(\\)", x=FeatureName),]

  ## Align column names to those in merged dataset and store 
  ## in new data table variable
  meanStdFeatures$FeatureCode <- meanStdFeatures[, paste("V", FeatureID, sep="")]
  
  ## Return mean/standard deviation feature vector
  meanStdFeatures
}

## Concatenate the merged dataset keys with the feature codes and subset the
## merged dataset to only include data for mean and standard deviation features
subsetMergedDataSet <- function() {
  
  ## Combine feature code columns with merged data set keys (subject and activity)
  mergeFeatureColumns <- c(key(mergedDataset), features$FeatureCode)
  
  ## Subset the merged dataset using existing feature codes
  mergedDataset <- mergedDataset[, mergeFeatureColumns, with=FALSE]
  
  ## Return subsetted merged dataset
  mergedDataset
}

addActivityNames <- function() {
  
  ## 
  setnames(activityLabels, names(activityLabels), c("ActivityID", "ActivityName"))
}

## Establish top level dataset path
#! Update to dynamically read in directory with data files
harDataDir <- file.path(getwd(), "UCI HAR Dataset")

## Read in activity labels
activityLabels <- fread(input=file.path(harDataDir, "activity_labels.txt"))

## Initialize training dataset if it doesn't exist
if(!exists("trainingDataSet")) {
  trainingDataSet <- cachedDataSet(dataSetFilePath=file.path(harDataDir, "train", "X_train.txt"),
                      dataSetActivitiesFilePath=file.path(harDataDir, "train", "y_train.txt"),
                      dataSetSubjectsFilePath=file.path(harDataDir, "train", "subject_train.txt"))
}

## Initialize test dataset if it doesn't exist
if (!exists("testDataSet")) {
  testDataSet <- cachedDataSet(dataSetFilePath=file.path(harDataDir, "test", "X_test.txt"),
                             dataSetActivitiesFilePath=file.path(harDataDir, "test", "y_test.txt"),
                             dataSetSubjectsFilePath=file.path(harDataDir, "test", "subject_test.txt"))
}

## Load training dataset
loadDataSetContent(cachedDataSet=trainingDataSet)

## Load test dataset
loadDataSetContent(cachedDataSet=testDataSet)

## Merge the datasets
mergedDataset <- mergeDataSets()

## Extract mean and standard deviation features
features <- extractMeanAndStdDevFeatures(featureFilePath=file.path(harDataDir, "features.txt"))

## Subset the merged dataset using on the mean and standard deviation features
mergedDataset <- subsetMergedDataSet()