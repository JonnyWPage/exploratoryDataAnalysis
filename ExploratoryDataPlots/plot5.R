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

# Extract data from Baltimore
baltDf <- mergeDf[mergeDf$fips=="24510",]

# Extract data from motor vehicles
matching_levels_veh <- grep("vehicles",tolower(baltDf$EI.Sector))
matching_levels_loc <- grep("locomotives",tolower(baltDf$EI.Sector))

matching_levels <- c(matching_levels_veh,matching_levels_loc)
motorDf <- baltDf[matching_levels,]

# group by year
by_year <- group_by(motorDf,year)

# get means for each year
byYear <- summarise(by_year,emissions=mean(Emissions))

# plot data
png(filename="Plot5.png")
with(byYear,plot(year,emissions,main="Mean emissions from 1998-2008 by motor vehicles in Baltimore City",
                 pch=0,xlab="Year",ylab="PM2.5 Emitted (Tons)"))
lines(byYear$year,byYear$emissions)
dev.off()