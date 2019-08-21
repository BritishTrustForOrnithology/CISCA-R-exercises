#AIM: produce a chloropleth map of richness of endemic species 
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ---------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data
library(rgbif) #for downloading data from GBIF

#load the necessary data ---------------------------------------------------------------------
load(file = 'data_processed/basemap_outline.RData')
load(file = 'data_processed/kenya_grid_1_degree_clip.Rdata')
load(file = 'data_processed/kenya_endemics_gbif.Rdata')

#initialise a ggplot2 object with the basemap ------------------------------------------------
basemap <- ggplot() +
  geom_sf(data = basemap_outline, fill = 'white')

#add the species data, colour by species and add the grid
basemap + 
  geom_point(data = kenya_endemics_gbif, aes(x = decimalLongitude, y = decimalLatitude, col = species)) +
  geom_sf(data = kenya_grid_1d_clip, fill=NA)

#to determine how many endemics were recorded in each grid cell first 
#need to convert the records to spatial data
kenya_endemics_gbif_spatial <- st_as_sf(kenya_endemics_gbif, coords = c('decimalLongitude', 'decimalLatitude'), crs = 4326)
class(kenya_endemics_gbif_spatial)
head(kenya_endemics_gbif_spatial)

#check it worked - note the legend has changed
basemap + 
  geom_sf(data = kenya_endemics_gbif_spatial, aes(col = species)) +
  geom_sf(data = kenya_grid_1d_clip, fill=NA)

#which records in each square - use a spatial join to assign the records to their grid square
kenya_endemics_gbif_grid <- st_join(kenya_endemics_gbif_spatial, kenya_grid_1d_clip, join = st_intersects)
#check, noting that columns X and Y from the grid are now on each row
head(kenya_endemics_gbif_grid)

#so now all we need to do is count the number of species in each XY
#first produce a dataframe
species_in_grid <- as.data.frame(kenya_endemics_gbif_grid)
#then remove duplicate records of species in squares using unique()
species_in_grid <- unique(species_in_grid[,c('species','X','Y')])
#check what it looks like
head(species_in_grid)
#use aggregate to count how many species in each square - as there should be one species per row we can just count rows
richness <- aggregate(data = species_in_grid, species ~ X + Y, NROW)


#join the richness data to the grid - use all.x = TRUE to ensure we retain all of the grid
richness <- merge(kenya_grid_1d_clip, richness, by = c('X', 'Y'), all.x = TRUE)
head(richness)

#convert the NA values to zeroes - these are grid squares were there was no corresponding richness data so can assume zeroes
richness$species[is.na(richness$species)] <- 0

#save these data for use later
save(richness, file='data_processed/kenya_endemics_richness_spatial.Rdata')

#and map, using aes to set the fill colour according to species richness
basemap + 
  geom_sf(data = richness, aes(fill = species))

#not a very useful colour scheme, lets replace with a gradient from white to red
basemap + 
  geom_sf(data = richness, aes(fill = species)) +
  scale_fill_gradient(low = 'white', high = 'red')

#are the protected areas in the best places for Kenyan endemics?
p_areas <- st_read("data_gis/ke_protected-areas/ke_protected-areas.shp")

basemap + 
  geom_sf(data = p_areas, fill = 'grey70') +  
  geom_sf(data = richness, aes(fill = species), alpha = 0.75) +
  scale_fill_gradient(low = 'white', high = 'red')


