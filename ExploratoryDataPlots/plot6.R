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

# Extract data from Los Angeles County
lacDf <- mergeDf[mergeDf$fips=="06037",]

# Extract data from motor vehicles
balt_matching_levels_veh <- grep("vehicles",tolower(baltDf$EI.Sector))
balt_matching_levels_loc <- grep("locomotives",tolower(baltDf$EI.Sector))

balt_matching_levels <- c(balt_matching_levels_veh,balt_matching_levels_loc)
balt_motorDf <- baltDf[balt_matching_levels,]

lac_matching_levels_veh <- grep("vehicles",tolower(lacDf$EI.Sector))
lac_matching_levels_loc <- grep("locomotives",tolower(lacDf$EI.Sector))

lac_matching_levels <- c(lac_matching_levels_veh,lac_matching_levels_loc)
lac_motorDf <- lacDf[lac_matching_levels,]

# group by year
balt_by_year <- group_by(balt_motorDf,year)
lac_by_year <- group_by(lac_motorDf,year)

# get means for each year
balt_byYear <- summarise(balt_by_year,emissions=mean(Emissions))
lac_byYear <- summarise(lac_by_year,emissions=mean(Emissions,na.rm=TRUE))

# construct data frame for plotting
to_plotDf <- data.frame(year=balt_byYear$year,
                        balt=balt_byYear$emissions,
                        lac=lac_byYear$emissions)
                        
# format plotting environment
par(mfrow=c(2,1))

# plot
with(balt_byYear,plot(year,emissions,main="Mean emissions from 1998-2008 by motor vehicles in Baltimore City",
                 pch=0,col="black",xlab="Year",ylab="PM2.5 Emitted (Tons)",cex.main=0.75))
lines(balt_byYear$year,balt_byYear$emissions)
with(lac_byYear,plot(year,emissions,main="Mean emissions from 1998-2008 by motor vehicles in Los Angeles County",
                      pch=0,col="red",xlab="Year",ylab="PM2.5 Emitted (Tons)",cex.main=0.75))
lines(lac_byYear$year,lac_byYear$emissions,col="red")
dev.copy(png,"Plot6.png")
dev.off()
