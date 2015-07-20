features <- read.table('data/features.txt', col.names = c('number', 'feature'))
activityLabels <- read.table('data/activity_labels.txt', col.names = c('code', 'activity'), colClasses = c('factor', 'factor'))

readDataset <- function(mainDataFile, sibjectFile, activityFile) {
    # TODO: read all data (remove nrow limit)
    mainData <- read.table(mainDataFile, nrows = 40, col.names = features$feature)
    subjectData <- read.table(sibjectFile, nrows = 40, col.names = c('subject'), colClasses = c('factor'))
    activityData <- read.table(activityFile, nrows = 40, col.names = c('activityCode'), colClasses = c('factor'))
    
    selectedColumns <- grep("mean|std", names(mainData), ignore.case = TRUE)
    mainData <- mainData[, selectedColumns]
    
    activityData = merge(activityData, activityLabels, by.x = "activityCode", by.y = "code", all.x = TRUE, sort = FALSE)
    mainData$subject <- subjectData$subject
    mainData$acivity <- activityData$activity
    
    mainData   
}

trainData <- readDataset('data/train/X_train.txt', 'data/train/subject_train.txt', 'data/train/y_train.txt')
testData <- readDataset('data/test/X_test.txt', 'data/test/subject_test.txt', 'data/test/y_test.txt')

data <- rbind(trainData, testData)
