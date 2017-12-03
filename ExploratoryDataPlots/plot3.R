library(dplyr)
library(ggplot2)

# Set working directory
setwd("C:/Users/jonny/Documents/Coursera/Emissions")

# Read in data
src <- readRDS("Source_Classification_Code.rds")
dat <- readRDS("summarySCC_PM25.rds")

# Manipulate data
dat$date <- as.factor(dat$year)

by_year <- group_by(dat,date)

by_fips <- by_year[by_year$fips=="24510",]

byFips <- summarise(by_fips,mean(Emissions))
byFips$newDat <- c(1999,2002,2005,2008)

# Get mean emissions from each type
point_to_plot <- by_fips[by_fips$type=="POINT",]
pointPlot <- summarise(point_to_plot,Emissions=mean(Emissions))

nonpoint_to_plot <- by_fips[by_fips$type=="NONPOINT",]
nonpointPlot <- summarise(nonpoint_to_plot,Emissions=mean(Emissions))

onroad_to_plot <- by_fips[by_fips$type=="ON-ROAD",]
onroadPlot<-summarise(onroad_to_plot,Emissions=mean(Emissions))

nonroad_to_plot <- by_fips[by_fips$type=="NON-ROAD",]
nonroadPlot<-summarise(nonroad_to_plot,Emissions=mean(Emissions))

# Construct dataframe for plotting
typeDat <- data.frame(year=rep(c(1999,2002,2005,2008),4),
                      emission=c(pointPlot$Emissions,nonpointPlot$Emissions,
                                 onroadPlot$Emissions,nonroadPlot$Emissions),
                      type=c(rep("Point",4),rep("Nonpoint",4),
                             rep("On-Road",4),rep("Non-Road",4)))

# Plot
ggplot(typeDat, aes(x=year,y=emission,color=type))+
  labs(title="Mean PM2.5 Emissions of Different Types",y="Mean PM2.5 Emissions (Tons)",x="Year")+
  geom_point()+geom_line()

# Save Figure
ggsave("Plot3.png")
