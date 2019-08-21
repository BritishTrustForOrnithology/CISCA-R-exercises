#AIM: read some shapefiles and make a basic map showing the location of my study region
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ----------------------------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data


#download a shapefile of African countries from www.maplibrary.org ----------------------------------------------
#create a folder for it first
dir.create('data_gis/admin_boundaries') 
#download
download.file(url = 'http://www.maplibrary.org/library/stacks/Africa/Africa_SHP.zip' , destfile = 'data_gis/admin_boundaries/Africa.zip')
#****** manually virus check the file before doing anything else ****** --------------------------------------------------------------------
#then unzip, specifying the file to unzip and where to put it
unzip('data_gis/admin_boundaries/Africa.zip', exdir = 'data_gis/admin_boundaries')

#read the shapefile using st_read() function --------------------------------------------------------------------
#remember ?st_read to find out the syntax
africa_boundary <- st_read("data_gis/admin_boundaries/Africa.shp")

#check the Coordinates Reference System. We may need this if other data we read in has different projection
st_crs(africa_boundary)

#no CRS set, so assign WSGB84 lat-long CRS
#see https://geocompr.robinlovelace.net/reproj-geo-data.html#which-crs-to-use
#see https://epsg.io/4326 for some suggestions
africa_boundary <- st_set_crs(africa_boundary, 4326)


#map it to check it looks sensible -----------------------------------------------------------------------------
ggplot() +
  geom_sf(data = africa_boundary)


#have a look at what data are associated with the map ----------------------------------------------------------
names(africa_boundary)
head(africa_boundary)
str(africa_boundary)

#OK so we could colour code the map by the country code
ggplot() +
  geom_sf(data = africa_boundary, aes(fill = CODE))

#but I just want to highlight the country I am working in
#so lets produce a new variable with 1 for Kenya, and 0 for everything else
africa_boundary$studyarea <- ifelse(africa_boundary$CODE == 'KEN', 1, 0)

#and replot
ggplot() +
  geom_sf(data = africa_boundary, aes(fill = studyarea))

#OK that's not quite right - I didn't mean to have a continuous scale
africa_boundary$studyarea <- ifelse(africa_boundary$CODE == 'KEN', '1', '0')

#and replot
africa_map <- ggplot() +
  geom_sf(data = africa_boundary, aes(fill = studyarea))
africa_map

#export
ggsave(africa_map, file = 'results/africa_map.png', width = 5, height = 5, units = 'in')
