rm(list=ls(all.names=T))
wd <- getwd()
setwd(wd)

###########################  Step 1  ###################################

##read basic files into R
basicFiles <- list.files("./UCI HAR Dataset")
actLabels <- read.table(paste("./UCI HAR Dataset/",basicFiles[1],sep=""))
colnames(actLabels) <- c("Lables","Activity")

features <- read.table(paste("./UCI HAR Dataset/",basicFiles[2],sep=""))
colnames(features) <- c("FeatureNum","Feature")

##read test files into R
testFiles2 <- list.files("./UCI HAR Dataset/test")
testDir2 <- paste("./UCI HAR Dataset/test/",testFiles2,sep="")

subjectTest <- read.table(testDir2[2])
colnames(subjectTest)<-"Subject"

XTest <- read.table(testDir2[3])
colnames(XTest) <- features$Feature

YTest <- read.table(testDir2[4])
colnames(YTest)<-"Activities"

testData <- cbind(subjectTest,YTest,XTest)


##read train files into R
trainFiles2 <- list.files("./UCI HAR Dataset/train")
trainDir2 <- paste("./UCI HAR Dataset/train/",trainFiles2,sep="")

subjectTrain <- read.table(trainDir2[2])
colnames(subjectTrain)<-"Subject"

XTrain <- read.table(trainDir2[3])
colnames(XTrain) <- features$Feature

YTrain <- read.table(trainDir2[4])
colnames(YTrain)<-"Activities"

trainData <- cbind(subjectTrain,YTrain,XTrain)

##merge all data together
sportsDataTotal <- rbind(testData,trainData)

##################  Step2  ##########################

featureName <- as.character(features[ ,2])
featureMean <- agrep(c("mean"),featureName)
featureStd <- agrep(c("std"),featureName)
NumFeatureQ2 <- c(featureMean,featureStd)

sportsData=rbind(cbind(subjectTest,YTest,XTest[ ,NumFeatureQ2]),cbind(subjectTrain,YTrain,XTrain[ ,NumFeatureQ2]))

#################  Step3   #########################
actFac <- NA
actFac <- sportsData$Activities
for( k in 1:6){
  actFac[sportsData$Activities==k]=as.character(actLabels[k,2])
}
sportsData$Activities <- factor(actFac,levels=as.character(actLabels[ ,2]))

################# Step4  ##########################
namesOriginal <- names(sportsData)

namesNew <- gsub("BodyBody","Body",namesOriginal)
namesNew <- gsub("[(.*)]","",namesNew)  #delete"()"
namesNew <- gsub("-","",namesNew)
namesNew <- gsub("mean","-Mean",namesNew)
namesNew <- gsub("Mean","-Mean",namesNew)
namesNew <- gsub("std","-Std",namesNew)
namesNew <- gsub("Mag","Magnitude",namesNew)

colnames(sportsData) <- namesNew

##################  Step 5  #####################

library(reshape2)
sportsDataMelt <- melt(sportsData,id=c("Subject","Activities"))
finalData <- dcast(sportsDataMelt,Subject+Activities~variable,mean)

write.table(finalData,file="tidyData of Project.txt",row.name=FALSE)
