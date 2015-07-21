library(reshape2)
library(plyr)

# read features names (measurements)
features <- read.table('data/features.txt', col.names=c('number', 'feature'))
# read activity labels
activityLabels <- read.table('data/activity_labels.txt', col.names=c('code', 'activity'), colClasses=c('factor', 'factor'))

# get indices of needed features (mean and standard deviation)
selectedColumnIndices <- grep("mean|std", features$feature, ignore.case=TRUE)
# get number of selected features 
featureColumnCount <- length(selectedColumnIndices)

# function to produce datasets (train and test)
readDataset <- function(mainDataFile, sibjectFile, activityFile) {
    # read subjects list
    subjectData <- read.table(sibjectFile, col.names=c('subject'), colClasses=c('factor'))
    
    # read activities list
    activityData <- read.table(activityFile, col.names=c('activityCode'), colClasses=c('factor'))
    # add auxiliary column to keep correct order after merging
    activityData$order <- 1:dim(activityData)[1]
    # merging activities list with activity labels
    activityData <- merge(activityData, activityLabels, by.x="activityCode", by.y="code", all.x=TRUE, sort=FALSE)
    # sort to return to correct initial order
    activityData <- arrange(activityData, order)
    
    # read main dataset (with measurements)
    mainData <- read.table(mainDataFile, col.names=features$feature)
    # keep only needed features
    mainData <- mainData[, selectedColumnIndices]  
    # add subjects data
    mainData$subject <- subjectData$subject
    # add activity data
    mainData$activity <- activityData$activity
    
    mainData   
}

# get train data
trainData <- readDataset('data/train/X_train.txt', 'data/train/subject_train.txt', 'data/train/y_train.txt')
# get test data
testData <- readDataset('data/test/X_test.txt', 'data/test/subject_test.txt', 'data/test/y_test.txt')
# merge train and test data
data <- rbind(trainData, testData)

# reshape data to have four columns: subject, activity, measurement name and its value
tidyData <- melt(data, id=c("subject","activity"), measure.vars=names(data)[1:featureColumnCount])
# calculate average of each measurement for each activity and each subject
tidyData <- aggregate(value ~ subject + activity + variable, tidyData, mean)
# add descriptive labels
tidyData <- rename(tidyData, c("variable"="feature", "value"="averageValue"))
# sort data to be grouped by subject and activity
tidyData <- arrange(tidyData, subject, activity, feature)

# write tidy dataset
write.table(tidyData, 'tidyData.txt', row.name=FALSE)

