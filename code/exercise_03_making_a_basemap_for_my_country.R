#AIM: read a shapefile to make an outline of the country, including outline simplification if necessary
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ----------------------------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data


#download a shapefile of my country from www.maplibrary.org ----------------------------------------------------
#download
download.file(url = 'http://www.maplibrary.org/library/stacks/Africa/Kenya/KEN-level_1_SHP.zip', destfile = 'data_gis/admin_boundaries/KEN-level_1.zip')
#****** manually virus check the file before doing anything else ****** --------------------------------------------------------------------
#then unzip, specifying the file to unzip and where to put it
unzip('data_gis/admin_boundaries/KEN-level_1.zip', exdir = 'data_gis/admin_boundaries')

#read the shapefile using st_read() function --------------------------------------------------------------------
admin_bdy <- st_read("data_gis/admin_boundaries/KEN-level_1.shp")

#check the Coordinates Reference System. We may need this if other data we read in has different projection
st_crs(admin_bdy)

#assign WSGB84 lat-long CRS
#see https://geocompr.robinlovelace.net/reproj-geo-data.html#which-crs-to-use
#see https://epsg.io/4326 for some suggestions
admin_bdy <- st_set_crs(admin_bdy, 4326)


#double check that this is working in lat-longs rather than in metres (as a projected map would be)
st_is_longlat(admin_bdy)


#map it to check it looks sensible -----------------------------------------------------------------------------
ggplot() +
  geom_sf(data = admin_bdy)

#have a look at what data are associated with the map
names(admin_bdy)
head(admin_bdy)
str(admin_bdy)

#the map is nice but we don't really want the individual districts
#we need to dissolve the districts to make a country outline
#to do this use st_union - see ?st_union
#?st_union
country_outline <- st_union(admin_bdy)

ggplot() +
  geom_sf(data = country_outline)


#the map is OK but it is a very high resolution outline, possibly too high for print production
#especially obvious if we need a thicker outline for some purposes
ggplot() +
  geom_sf(data = country_outline, size = 2)



#so simplify the outline

#need to transform to a projected system suitable for the part of the world we are looking at
#here I will use UTM zone 36S:
#see https://epsg.io/21036
country_outline_proj = st_transform(country_outline, 21036)
#check what the CRS now is
st_crs(country_outline_proj)
#and confirm its no longer a lat-long object
st_is_longlat(country_outline_proj)


#simplify - bit of trial and error to get the right amount of simplification (for what output)
#see https://geocompr.robinlovelace.net/geometric-operations.html#geo-vec
country_outline_proj_1000 <- st_simplify(country_outline_proj, dTolerance = 1000)  # 1 km
country_outline_proj_5000 <- st_simplify(country_outline_proj, dTolerance = 5000)  # 5 km
country_outline_proj_10000 <- st_simplify(country_outline_proj, dTolerance = 10000)  # 10 km
country_outline_proj_20000 <- st_simplify(country_outline_proj, dTolerance = 20000)  # 20 km

ggplot() +
  geom_sf(data = country_outline_proj, size = 1.5) +
  labs(title = 'Original')
ggplot() +
  geom_sf(data = country_outline_proj_1000, size = 1.5) +
  labs(title = '1000')
ggplot() +
  geom_sf(data = country_outline_proj_5000, size = 1.5) +
  labs(title = '5000')
ggplot() +
  geom_sf(data = country_outline_proj_10000, size = 1.5) +
  labs(title = '10000')
ggplot() +
  geom_sf(data = country_outline_proj_20000, size = 1.5) +
  labs(title = '20000')


#compare on same map
ggplot() +
  geom_sf(data = country_outline_proj, col = 'black') +
  geom_sf(data = country_outline_proj_5000, col = 'red', fill = NA) +
  geom_sf(data = country_outline_proj_10000, col = 'blue', fill = NA) 
  

#too simplified? Can we zoom in to the SE coast a bit?
ggplot() +
  geom_sf(data = country_outline_proj, col = 'black') +
  geom_sf(data = country_outline_proj_5000, col = 'red', fill = NA) +
  geom_sf(data = country_outline_proj_10000, col = 'blue', fill = NA) +
  coord_sf(xlim = c(38,42), ylim = c(-5, 2))

#oops - what happened?
#problem is the axes are shown in degrees lat-long but the value are actually in metres
#we can force (temporarily) the axes to be shown in metres to know what part to zoom in with by saying the datum crs() is same as the map
ggplot() +
  geom_sf(data = country_outline_proj, col = 'black') +
  geom_sf(data = country_outline_proj_5000, col = 'red', fill = NA) +
  geom_sf(data = country_outline_proj_10000, col = 'blue', fill = NA) +
  coord_sf(datum = st_crs(21036))

#read off the new axes to set the xlim and ylim we want
ggplot() +
  geom_sf(data = country_outline_proj, col = 'black') +
  geom_sf(data = country_outline_proj_5000, col = 'red', fill = NA) +
  #geom_sf(data = country_outline_proj_10000, col = 'blue', fill = NA) +
  coord_sf(xlim = c(1300000,1500000), ylim = c(9600000, 9900000))

#the 5000 version looks OK for now so lets save it for later use
#Save as Rdata so we don't need to do any formatting/manipulation when reloading it
#also rename to something shorter
basemap_outline <- country_outline_proj_5000

#before saving we're also going to convert it back to a geographical CRS instead of projected so we can easily add lat-long points
basemap_outline <- st_transform(basemap_outline, 4326)

#and finally, converted to a class sf as this makes some later spatial analyses easier
basemap_outline <- st_sf(basemap_outline)

save(basemap_outline, file = 'data_processed/basemap_outline.RData')
