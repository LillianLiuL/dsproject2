#Kristina  25 Aug 2017  To simulate merge between data source (lon,lat)
require(sp)
require(raster)
require(rgdal)
require(formattable)
require(rgeos)
require(dplyr)

setwd("DSP2")
getwd()

drillholes <- read.csv("drillholes/successful_drillhole.csv")
drillholes <- as.data.frame(drillholes)
drillholes<-drillholes[,c("OBJECTID","LONGITUDE","LATITUDE")]
names(drillholes)<-c("objectid","lon","lat")


sp_dh<-drillholes
coordinates(sp_dh)<-~lon+lat


gravity<- readGDAL("gravity/south_australia/SA_GRAV.ers")
gravity<-as.data.frame(as(gravity, "SpatialGridDataFrame"))
gravity$nearest_grav_coord_id<-seq.int(nrow(gravity))
names(gravity)<-c("gravity","lon","lat","nearest_grav_coord_id")


sp_grav<-gravity
coordinates(sp_grav)<-~lon+lat


magnetic  <- readGDAL("magnetic/south_australia/SA_TMI_RTP.ers")

magnetic  <- readGDAL("magnetic/south_australia/SA_TMI_RTP.ers")
magnetic<-as.data.frame(as(magnetic, "SpatialGridDataFrame"))
magnetic$nearest_mag_coord_id<-seq.int(nrow(magnetic))
names(magnetic)<-c("magnetic","lon","lat","nearest_mag_coord_id")
head(magnetic)

sp_mag<-magnetic
coordinates(sp_mag)<-~lon+lat

drillholes$nearest_grav_coord_id<-apply(gDistance(sp_grav,sp_dh, byid=TRUE),1,which.min)

drillholes$nearest_mag_coord_id<-apply(gDistance(sp_mag,sp_dh, byid=TRUE),1,which.min)


output<-merge(drillholes, magnetic,  by=c("nearest_mag_coord_id"))
output<-merge(output, gravity,  by=c("nearest_grav_coord_id"))

head(output)
