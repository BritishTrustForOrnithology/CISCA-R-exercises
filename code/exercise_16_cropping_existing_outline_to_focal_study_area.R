#load the necessary R packages ----------------------------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data


#download a shapefile of my country from www.maplibrary.org ----------------------------------------------------
dir.create('data_gis/admin_boundaries')
download.file(url = 'http://www.maplibrary.org/library/stacks/Africa/Cameroon/CAM-level_1_SHP.zip', destfile = 'data_gis/admin_boundaries/CAM-level_1.zip')
#****** manually virus check the file before doing anything else ****** --------------------------------------------------------------------
#then unzip, specifying the file to unzip and where to put it
unzip('data_gis/admin_boundaries/CAM-level_1.zip', exdir = 'data_gis/admin_boundaries')

#read the shapefile using st_read() function --------------------------------------------------------------------
admin_bdy <- st_read("data_gis/admin_boundaries/CAM-level_1.shp")
admin_bdy <- st_set_crs(admin_bdy, 4326)
head(admin_bdy)
table(admin_bdy$CAPTION)

#plot the new set of polygons
ggplot() +
  geom_sf(data = admin_bdy)

admin_bdy <- subset(admin_bdy, CAPTION %in% c('Sud','Sud-Ouest','Littoral'))

#plot the new set of polygons
ggplot() +
  geom_sf(data = admin_bdy)

#create a box to act as the region we want to crop the map to
#first give the corners as a matrix, being careful to close the box (5 points, 1st and 5th identical)
corners <- matrix(c(8,2,8,4.9,10.2,4.9,10.2,2,8,2), ncol = 2, byrow = TRUE)
#make a polygon and convert to sfc class
box <- st_sfc(st_polygon(list(corners)))
#finally convert to sf class, applying crs to be same as base map
box <- st_sf(box, crs = 4326)

#plot to check its in the right place
ggplot() +
  geom_sf(data = admin_bdy) +
  geom_sf(data = box, col = 'red', fill = NA)


#now use the box to crop the state outlines
#note y can also be a set of coordinates, negating the need to do the previous corners --> box steps
cam_coast <- st_crop(x = admin_bdy, y = box)

#plot to check it looks OK
ggplot() +
  geom_sf(data = cam_coast)


#this looks great for a map. But what if we actually wanted the see as a polygon?
#i.e we didn't just want to crop the polygons, but intersect them
#first union the states to make a single 'land' polygon
land <- st_union(admin_bdy)

#now we calculate the difference between the box and the land
cam_sea <- st_difference(box, ab)

#plot to check
ggplot() +
  geom_sf(data = cam_sea, fill='azure') 

#add the land polygons
ggplot() +
  geom_sf(data = cam_sea, fill='azure') +
  geom_sf(data = admin_bdy, fill = 'tan')

#hmm that doesn't look very good. We want the cam_coast polygons which we cropped to the box earlier
ggplot() +
  geom_sf(data = cam_sea, fill='azure') +
  geom_sf(data = cam_coast, fill = 'tan')


