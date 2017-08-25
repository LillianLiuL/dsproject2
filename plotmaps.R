#Kristina 25 Aug 2017  Example of plotting maps and drillhole
getwd()

drillholes <- read.csv("drillholes/successful_drillhole.csv")
drillholes <- as.data.frame(drillholes)
drillholes<-drillholes[,c("OBJECTID","LONGITUDE","LATITUDE")]
names(drillholes)<-c("OBJECTID","lon","lat")

#see coord range in sucessful file
summary(drillholes$lon)
summary(drillholes$lat)

library(maps)
df <- world.cities[world.cities$country.etc == "Australia",]

library(ggmap)

myMap <- get_map(location = "South Australia", zoom = 7)

ggmap(myMap)
ggmap(myMap) +
  geom_point(data = drillholes, aes(x=lon, y = lat, colour = "red"))