##Getting and Cleaning Data Course Project

###Repository Content

* `data` folder - the project data (withoud Inertial Signals)
* `CodeBook.md` - the code book describing the variables of the tidy dataset
* `run_analysis.R` - the script to create the tidy dataset

###Script Steps

* read features list `features.txt` and activity labels `activity_labels.txt`
* find needed features names (the measurements on the mean and standard deviation)
* read test and train data sets
    * read subject data
    * read activities data
    * merge activities codes with activity labels
    * read measurements data
    * keep only needed columns in measurements data
    * merge subject, activities and measurements datasets
* merge test and train data sets
* reshape data set to have four columns: subject, activity, measurement name and its value
* calculate average of each measurement for each activity and each subject
* add descriptive column labels
* sort data to be grouped by subject and activity
* write the tidy data set to `tidyData.txt`

