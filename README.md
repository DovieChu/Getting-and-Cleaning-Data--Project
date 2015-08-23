# Getting-and-Cleaning-Data--Project

The Dataset is used to record the result of an experiment carried out with a group of 30 volunteers about the performance of Samsung wearable computing devices.

This code is used to deal with raw data of this experiment.

The raw data includes resluts of both tests and trains from 30 people under 6 kind of activities, every volunteer repeats the experiment several times under each activity, one obeservation is the result of one time of experiment, so there are more ten thousands rows of data. 

We cope with this raw data and get our tidy data which has 180 (30 people * 6 activities) observations and 88variables(as demanded).

Run the code from the beginning to the end and You can get the final tidy data of the experiment.
The detailed operation process can be divided into five steps.

Step1:
Read all the data into R with function "read.table()"
For the there are more than one txt files need to be loaded, use "list.files()"to figure the name of the file and use "paste("./UCI HAR Dataset/test/",testFiles2,sep="")"to form the directory used for reading in the file.

Firstly, read in the basic files, include features information and activities information
Secondly, read in the test files
Thirdly, read in the train files

Finaly, use the function"rbind", merge test data and train data together


Step2:
Extracts the measurements on the mean and standard deviation for each measurement.
Use function "agrep()" to find the measurement containing "mean" and "std"
The mean can be mainly divided into several groups(stand deviation is similar):
  mean of certain information of XYZ(body/gravity acceleration(jerk); body gyration(jerk))--time/frequency
  mean of Magnitude--time/frequency
  mean about angle
In this code, all the measurements related to "mean" or "std" are included.

Subset all the columns needed and get the new dataset "sportData"

Step3:
Uses descriptive activity names to name the activities in the data set
Define the six kinds of activites as factor and set the names of activites as the levels


Step4:
Appropriately labels the data set with descriptive variable names
There are names for the raw data, but with some mistakes, so here our codes mainly correct the original names.
Use the function "gsub()" to achieve the replacement of character
The changes are:
  replace "BodyBody" by "Body"
  delete all the bracket"()"
  delete all "-"
  delete all ","
  replace "mean" by "-Mean"
  replace "std" by "-Std"
  replace "Mag" by "Magnitude"
  replace "Acc" by "Acceleration"
  replace "Gyro" by "Gyration"
  replace "angel" by "angle-"
  replace "t" by "time-"
  replace "f" by "freqency-"

Step5:
Up to Step4, there are still more than ten thousands rows. 
To make the data tidy, we should make sure there is one observation each row.
Firstly, melt the data with "Subject" and "Activities" as ID "sportsDataMelt <- melt(sportsData,id=c("Subject","Activities)"))"
Then use dcast() to get the tidy dataset:
finalData <- dcast(sportsDataMelt,Subject+Activities~variable,mean)
