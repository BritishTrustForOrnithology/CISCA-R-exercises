#AIM: add polygons of background data onto the map to show habitat or topography
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ---------------------------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data


#read the basemap we already created ---------------------------------------------------------------------------
load(file = 'data_processed/basemap_outline.RData')


#initialise a ggplot2 object with the basemap ------------------------------------------------------------------
basemap <- ggplot() +
  geom_sf(data = basemap_outline, fill = 'white')

#nothing happened...why?
basemap

#let's add some protected areas and waterbodies onto the map
#https://www.wri.org/resources/data-sets/kenya-gis-data#basedata
#create folders
dir.create('data_gis/ke_protected-areas') 
dir.create('data_gis/ke_waterbodies') 
#download
download.file(url = 'https://s3.amazonaws.com/wriorg/docs/ke_protected-areas.zip' , destfile = 'data_gis/ke_protected-areas/protectedareas.zip')
download.file(url = 'https://s3.amazonaws.com/wriorg/docs/ke_waterbodies.zip' , destfile = 'data_gis/ke_waterbodies/waterbodies.zip')
#****** manually virus check the file before doing anything else ****** --------------------------------------------------------------------
#then unzip, specifying the file to unzip and where to put it
unzip('data_gis/ke_protected-areas/protectedareas.zip', exdir = 'data_gis/ke_protected-areas')
unzip('data_gis/ke_waterbodies/waterbodies.zip', exdir = 'data_gis/ke_waterbodies')

#read and trasnform the data so they match the projection of our basemap
p_areas <- st_read("data_gis/ke_protected-areas/ke_protected-areas.shp")
p_areas <- st_transform(p_areas, 4326)
waterbodies <- st_read("data_gis/ke_waterbodies/ke_waterbodies.shp")
waterbodies <- st_set_crs(waterbodies, 4326)



#add the protected area polygons as a new layer on the basemap
basemap +
  geom_sf(data = waterbodies, col = NA, fill = 'blue') +
  geom_sf(data = p_areas, col = NA, fill = 'red') +
  coord_sf()

#that's a bit bold - change colour, or make transparent
basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  coord_sf()

#where are we?
nairobi <- data.frame(latitude = -1.2921, longitude = 36.8219)

basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  geom_point(data = nairobi, aes(x = longitude, y = latitude)) +
  coord_sf()

#change the style of the dot
#change the colour
basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  geom_point(data = nairobi, aes(x = longitude, y = latitude), colour = 'blue') +
  coord_sf()

#make the dot bigger
basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  geom_point(data = nairobi, aes(x = longitude, y = latitude), colour = 'blue', size = 4) +
  coord_sf()

#change symbol
#what are the shapes we can use?
# A look at all 25 symbols
df2 <- data.frame(x = 1:5 , y = 1:25, z = 1:25)
s <- ggplot(df2, aes(x, y))
s + geom_point(aes(shape = z), size = 4) +
  scale_shape_identity()

#but edges and centres can be coloured differently
df2 <- data.frame(x = 1:5 , y = 1:25, z = 1:25)
s <- ggplot(df2, aes(x, y))
s + geom_point(aes(shape = z), size = 4, col = 'red', fill = 'blue') +
  scale_shape_identity()

#a dark grey square to indicate the city
basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  geom_point(data = nairobi, aes(x = longitude, y = latitude), colour = 'blue', size = 4, shape = 15) +
  coord_sf()

#add some text too
basemap +
  geom_sf(data = p_areas, col = NA, fill = 'red', alpha = 0.25) +
  geom_point(data = nairobi, aes(x = longitude, y = latitude), colour = 'blue', size = 4, shape = 15) +
  geom_text(data = nairobi, aes(x = longitude, y = latitude, label = 'N'), colour = 'white', size = 3, nudge_y = 0.05) +
  coord_sf()

#add Mombasa (-4.0437, 39.6607) to the map
