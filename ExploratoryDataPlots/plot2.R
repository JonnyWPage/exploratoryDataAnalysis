library(dplyr)

# Set working directory
setwd("C:/Users/jonny/Documents/Coursera/Emissions")

# Read in data
src <- readRDS("Source_Classification_Code.rds")
dat <- readRDS("summarySCC_PM25.rds")

# Manipulate data
dat$date <- as.factor(dat$year)

by_year <- group_by(dat,date)

by_fips <- by_year[by_year$fips=="24510",]

emissions_by_fips <- summarise(by_fips,emission=sum(Emissions))

emissions_by_fips$newDate <- c(1999,2002,2005,2008)

# Plot
png(filename="Plot2.png")
with(emissions_by_fips, 
     plot(newDate,emission,main="Total emissions from 1998-2008 in Baltimore City",
          pch=0,xlab="Date",ylab="PM2.5 Emitted (Tons)"))
lines(emissions_by_fips$newDate,emissions_by_fips$emission)
dev.off()
