#AIM: explore grids, polygons and centroids. Produce a 1 degree grid for use later
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019


#' load the necessary R packages
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data

#load the basemap outline
load(file = 'data_processed/basemap_outline.RData')

#remind outselves what this looks like
basemap <- ggplot()  +
  geom_sf(data = basemap_outline, col = 'blue', fill = NA)
basemap

#make a 1 degree grid
kenya_grid <- st_make_grid(x = basemap_outline, #use existing object for the extent we want to grid
                           cellsize = 1, #size of the grid
                           what = 'polygons', #we want polygons (could have centres for points)
                           square = TRUE) #a square/rectangular grid, not hexagons

#check how this looks
basemap  +
  geom_sf(data = kenya_grid, fill=NA, col= 'red') 

#the grid is offset - because by default the grid starts at the SW corner of the bounding box of the basemap
basemap_bbox <- st_bbox(basemap_outline)
basemap_bbox

#so start the grid at the right place using offset
kenya_grid_1d <- st_make_grid(x = basemap_outline, #use existing object for the extent we want to grid
                           cellsize = 1, #size of the grid
                           offset = c(33,-5),
                           what = 'polygons', #we want polygons (could have centres for points)
                           square = TRUE) #a square/rectangular grid, not hexagons

#check how this looks
basemap  +
  geom_sf(data = kenya_grid_1d, fill=NA, col= 'red') 

#this is a sfc_POLYGON class - need to convert to a sf object so we can add data
class(kenya_grid_1d)
kenya_grid_1d <- st_sf(kenya_grid_1d)
class(kenya_grid_1d)

#get centroid of each grid cell
kenya_grid_1d_centroid <- st_centroid(kenya_grid_1d)
class(kenya_grid_1d_centroid)

#map the centroids
basemap  +
  geom_sf(data = kenya_grid_1d, col = 'red', fill = NA) + 
  geom_sf(data = kenya_grid_1d_centroid) 

#get the coordinates of each point and use these as attributes for the grid so that we can (later) merge
#biological data from elsewhere
st_coordinates(kenya_grid_1d_centroid)
kenya_grid_1d <- cbind(kenya_grid_1d, st_coordinates(kenya_grid_1d_centroid))
head(kenya_grid_1d)

#save for later
save(kenya_grid_1d, file = 'data_processed/kenya_grid_1_degree.Rdata')


#clip the grid to the country outline
kenya_grid_1d_clip <- st_intersection(basemap_outline, kenya_grid_1d)
basemap  +
  geom_sf(data = kenya_grid_1d_clip, fill=NA, col= 'red') 


#save for later
save(kenya_grid_1d_clip, file = 'data_processed/kenya_grid_1_degree_clip.Rdata')

