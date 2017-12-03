library(dplyr)
library(ggplot2)

# Set working directory
setwd("C:/Users/jonny/Documents/Coursera/Emissions")

# Read in data
src <- readRDS("Source_Classification_Code.rds")
dat <- readRDS("summarySCC_PM25.rds")

# Merge src and dat data frames
srcDf <- data.frame(src)
datDf <- data.frame(dat)

mergeDf <- merge(srcDf,datDf,by="SCC")

# Find observations relating to coal
matchingLevels <- grep("coal",tolower(mergeDf$Short.Name))

coalObvs <- mergeDf[matchingLevels,]

# Group by year
by_year <- group_by(coalObvs,year)

byYear <- summarise(by_year,emissions=mean(Emissions))

# Plot
png(filename="Plot4.png")
with(byYear,plot(year,emissions,main="Mean emissions from 1998-2008 by Coal Sources",
                 pch=0,xlab="Year",ylab="PM2.5 Emitted (Tons)"))
lines(byYear$year,byYear$emissions)
dev.off()