#AIM: creating shapefiles from GPS coordinates
#AUTHOR: Simon Gillings (BTO)
#CREATED: August 2019

#load the necessary R packages ----------------------------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data


#for this exercise we are going to imagine that we are undertaking some monitoring in 
#Nairobi National Park. First, let us get a map of the boundary of the park

#read the shapefile of Nairobi National Park using st_read() function --------------------------------------------------------------------
natpark <- st_read("data_gis/nairobi_np.shp")

#note that the CRS is already defined as 4326 so we don't need to assign or tranform it

#initialise a ggplot2 object using the national park boundary ------------------------------------------------------------------
parkmap <- ggplot() +
  geom_sf(data = natpark, fill = 'tan')

#nothing happened...why? Remember if we assign the plot to an object we have to call the
#object to see it...
parkmap

#Now let us add some data to the map. First we have some GPS data in a csv file for the
#boundary of a lake and an area of scrub
gps_lake <- read.csv('data_raw/gps_fixes_lake.csv')
gps_scrub <- read.csv('data_raw/gps_fixes_scrub.csv')

#look at the data
head(gps_scrub)
str(gps_scrub)

#need to convert these coordinates to a shapefile
#check that the coordinates are closed - i.e. that first and last point are identical
gps_scrub[1,] #show the 1st row
gps_scrub[nrow(gps_scrub),] #show the last row, using nrow to say how many rows

#use st_polygon to make the polygon; it needs a list with numeric matrixes with points in rows
polygon_scrub <- st_polygon(list(as.matrix(gps_scrub)))
class(polygon_scrub)

#OK, can we map it yet?
parkmap + geom_sf(data = polygon_scrub)

#No! it is not in the right format yet as it doesn't have a CRS, R doesn't know if the 
#coordinate we gave it are metres, km, degrees or what. We need to convert it to an sf object
polygon_scrub <- st_sf(st_sfc(polygon_scrub), crs = 4326)
#check the data again
class(polygon_scrub)
head(polygon_scrub)

#try mapping again - now works
parkmap + geom_sf(data = polygon_scrub, fill = 'green')

#convert the lake data as well. Note we can nest these functions within one another rather than doing line by line
polygon_lake <- st_sf(st_sfc(st_polygon(list(as.matrix(gps_lake)))), crs = 4326)

#update the parkmap
parkmap <- parkmap + 
  geom_sf(data = polygon_scrub, fill = 'green') +
  geom_sf(data = polygon_lake, fill = 'blue')
parkmap

#Now lets bring in the route of some transects. These are in KML format - we might have 
#downloaded them from a GPS or digitised them on Google Earth
#We can use st_read to access kml files directly

#read the KML files
t1kml <- st_read("data_raw/transect1.kml")
t2kml <- st_read("data_raw/transect2.kml")
t3kml <- st_read("data_raw/transect3.kml")

#check the format and CRS - all OK (same CRS as the map so should plot in the right place)
head(t1kml)

#add to the map
parkmap + 
  geom_sf(data = t1kml, col = 'red') +
  geom_sf(data = t2kml, col = 'purple') +
  geom_sf(data = t3kml, col = 'black')

#finally let's export some of the data as shapefiles
st_write(t1kml, 'data_gis/transect_1.shp', update = FALSE) #use update = TRUE if you want to overwrite any existing file

#this fails. The error message isn't very helpful so it took me a while to Google to 
#find the problem. It is because the KML file includes latitude (X), longitude (Y) and 
#elevation (Z), but we're trying to export just the lat-longs
#To make it possible to export we need to flatten the transect and remove the 
#elevation (Z) values

#we can use st_zm() to remove the Z values
#?st_zm
t1flat <- st_zm(t1kml, drop = TRUE, what = 'ZM')
t2flat <- st_zm(t2kml, drop = TRUE, what = 'ZM')
t3flat <- st_zm(t3kml, drop = TRUE, what = 'ZM')
#now it should work
#note I have not found how to overwrite an existing shapefile!
st_write(t1flat, 'data_gis/transect_1.shp')

#We could export each transect separately, but it's more likely we would want them combined
#into one shapefile
#first give each object a new variable and assign the transect number
t1flat$transect <- 1
t2flat$transect <- 2
t3flat$transect <- 3

#use rbind to combine the three lines into a single object
all_transects <- rbind(t1flat, t2flat, t3flat)
#remove some redundant variables
all_transects$Name <- NULL
all_transects$Description <- NULL
#check this looks sensible
all_transects

#if we wanted to we could now make a map with the transects coloured differently
#remember that if we wan the map to behave differently based on values in the data
#we need to specify this in the aes() part of the ggplot call
parkmap + 
  geom_sf(data = all_transects, aes(col = factor(transect)) )


#finally, let's save the transects as a shapefile
st_write(all_transects, 'data_gis/transects_all.shp')

