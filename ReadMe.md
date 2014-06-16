Getting and Cleaning Data Project
========================================================

## Project Layout

The root level of the repository contains the following files:
* run_analysis.R
* ReadMe.md (currently viewing)
* Codebook.md
* GenerateCodebook.Rmd (code for generating formatted codebook)

## Running the analysis script

Once the project has been downloaded from Git, navigate to the project directory (i.e. **./GettingAndCleaningData**).  Type the following command to execute the **run_analysis.R** script:

```{r}
source('./run_analysis.R')
```

Below is an excerpt of the script output.  Please ensure that the "Finished" message is printed at the bottom.
```{r}

```

## Detailed Script Steps

The script will perform the following steps (in the order listed):

1. The required libraries will be loaded (and download them if they don't exist).  These include **data.table** and **reshape2**.
2. If the UCI HAR dataset zip file and/or directory do not exist, they will be downloaded and automatically extracted into the working directory.
3. The following data files will be read in (note that if the script has already been executed once within the current workspace, all of the below will be cached in order to speed execution):
  * Training dataset (./UCI HAR Dataset/train/X_train.txt)
  * Test dataset (./UCI HAR Dataset/test/X_test.txt)
  * Training subjects (./UCI HAR Dataset/train/subject_train.txt)
  * Test subjects (./UCI HAR Dataset/test/subject_test.txt)
  * Training activities (./UCI HAR Dataset/train/y_train.txt)
  * Test activities (./UCI HAR Dataset/test/y_test.txt)
  * Activity labels (./UCI HAR Dataset/activity_labels.txt)
4. The training and test datasets will be merged.
5. The features dataset will be loaded (./UCI HAR Dataset/features.txt) and subsetted to only include mean and standard deviation features.
  * Note that only features including the text "mean()" or "std()" will be extracted - ommiting "meanFreq" as we're only considering the mean of the signal itself.
6. The features will then be used to subset the training/test dataset to only include data corresponding to mean and standard deviation measures.
7. Activity labels are then merged with the aforementioned dataset, joining by the activity identifier (i.e. "V<n>").
8. The dataset will then be melted to produce a narrow, long dataset with a derived column titled FeatureCode (again, of the format of "V<n>") for the purposes of joining to the feature dataset.
9. The feature code and feature name variables (from the features dataset) will then be merged with the existing dataset, joining by the previously derived feature code.
10. The tidy dataset will then be created by dcasting with subject and activity name on rows and features on columns, with each intersection showing the mean for that distinct combination of subject, activity, and feature.