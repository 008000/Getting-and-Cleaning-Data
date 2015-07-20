library(reshape2)
library(plyr)

features <- read.table('data/features.txt', col.names=c('number', 'feature'))
activityLabels <- read.table('data/activity_labels.txt', col.names=c('code', 'activity'), colClasses=c('factor', 'factor'))
selectedColumnIndices <- grep("mean|std", features$feature, ignore.case=TRUE)
featureColumnCount <- length(selectedColumnIndices)

readDataset <- function(mainDataFile, sibjectFile, activityFile) {
    subjectData <- read.table(sibjectFile, col.names=c('subject'), colClasses=c('factor'))
    
    activityData <- read.table(activityFile, col.names=c('activityCode'), colClasses=c('factor'))
    activityData$order <- 1:dim(activityData)[1]
    activityData <- merge(activityData, activityLabels, by.x="activityCode", by.y="code", all.x=TRUE, sort=FALSE)
    activityData <- arrange(activityData, order)
    
    mainData <- read.table(mainDataFile, col.names=features$feature)
    mainData <- mainData[, selectedColumnIndices]   
    mainData$subject <- subjectData$subject
    mainData$activity <- activityData$activity
    
    mainData   
}

trainData <- readDataset('data/train/X_train.txt', 'data/train/subject_train.txt', 'data/train/y_train.txt')
testData <- readDataset('data/test/X_test.txt', 'data/test/subject_test.txt', 'data/test/y_test.txt')
data <- rbind(trainData, testData)

tidyData <- melt(data, id=c("subject","activity"), measure.vars=names(data)[1:featureColumnCount])
tidyData <- aggregate(value ~ subject + activity + variable, tidyData, mean)
tidyData <- rename(tidyData, c("variable"="feature", "value"="averageValue"))
tidyData <- arrange(tidyData, subject, activity, feature)

write.table(tidyData, 'tidyData.txt', row.name=FALSE)

