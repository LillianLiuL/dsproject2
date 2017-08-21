---
  title: "Drillholes"

# Hi - just checking how this works (Andrew)
---
  
#  This R source code analyses drillholes for a sample region in South Australia. The region selected was (135.8, -32.0) to (136.3, -32.6). Drillhole data, gravity data, magnetic data and MINDEP data was found using the SARIG "advanced search" facility.

require(sp)
require(raster)
require(rgdal)


setwd("F:\\DSP2\\sample data\\sample data")
# Drillholes

drillholes <- read.csv("drillholes/drillhole_detail.csv")

cat("Number of drillholes:", length(drillholes[,1]), "\n")

#The drillhole columns are:

names(drillholes)

# Gravity data
#The following plot shows the drillhole locations on the gravity data.


gravity  <- readGDAL("gravity/south_australia/SA_GRAV.ers")
plot(gravity)
points(drillholes$LONG_DEG_REAL, drillholes$NEG_LAT_DEG_REAL, cex = 0.1, col = "white")
summary(gravity)

# Magnetic
#The following plot shows the drillhole locations on the magnetic data

bbox(gravity)

magnetic  <- readGDAL("magnetic/south_australia/SA_TMI_RTP.ers")
plot(magnetic)
points(drillholes$LONG_DEG_REAL, drillholes$NEG_LAT_DEG_REAL, cex = 0.1, col = "white")


# MINDEP

#MINDEP data is supposed to give quality information for drillholes, but only three drillholes in the region are included.



require(sp) 
#get dataframe from gravity and magnetic ers files.
gravity_data<-as.data.frame(as(gravity, "SpatialGridDataFrame"))
magnetic_data<-as.data.frame(as(magnetic, "SpatialGridDataFrame"))
#rename columns
colnames(gravity_data) <- c("gravity","LONG_DEG_REAL","NEG_LAT_DEG_REAL")
colnames(magnetic_data) <- c("magnetic","LONG_DEG_REAL","NEG_LAT_DEG_REAL")
#to merge gravity_data and magnetic_data with drillholes, reduce the precision of Lon and Lat
gravity_data$LONG_DEG_REAL1<-round(gravity_data$LONG_DEG_REAL,3)
gravity_data$NEG_LAT_DEG_REAL1<-round(gravity_data$NEG_LAT_DEG_REAL,3)
magnetic_data$LONG_DEG_REAL1<-round(magnetic_data$LONG_DEG_REAL,3)
magnetic_data$NEG_LAT_DEG_REAL1<-round(magnetic_data$NEG_LAT_DEG_REAL,3)
drillholes$LONG_DEG_REAL1<-round(drillholes$LONG_DEG_REAL,3)
drillholes$NEG_LAT_DEG_REAL1<-round(drillholes$NEG_LAT_DEG_REAL,3)
#merge procedure
gravity_data_total <- merge(drillholes,gravity_data,by=c("LONG_DEG_REAL1","NEG_LAT_DEG_REAL1")) 
all_data_total <- merge(gravity_data_total,magnetic_data,by=c("LONG_DEG_REAL1","NEG_LAT_DEG_REAL1")) 