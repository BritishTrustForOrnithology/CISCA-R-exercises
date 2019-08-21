#AIM: automating the production of maps in a consistent way
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ---------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data
library(ggthemes) #for customising plots

#use source to recall the custom theme
source('code/theme_CISCA.r')

#load the necessary data ---------------------------------------------------------------------
load(file = 'data_processed/basemap_outline.RData')
load(file = 'data_processed/kenya_endemics_gbif.Rdata')
load(file = 'data_processed/species_lookup.Rdata')

#initialise a ggplot2 object with the basemap ------------------------------------------------
basemap <- ggplot() +
  geom_sf(data = basemap_outline, fill = 'white', col = 'grey50')

#working -------------------------------------------------------------------------------------
#which species do we have to map?


#how many species do we have to map?
nrow(species_lookup)
  
#write a function to produce a map for a particular species
map_a_species <- function(this_scientific, this_vernacular) {
  cat(this_scientific, this_vernacular, '\n')
  
  #subset the data to this species
  onespec <- subset(kenya_endemics_gbif, species == this_scientific)
  
  #produce the map
  speciesmap <- basemap + 
    geom_point(data = onespec, 
               aes(x = decimalLongitude, y = decimalLatitude),
               col = 'orange', alpha = 0.5, size = 2, shape = 16) +
    labs(title = this_vernacular) +
    theme_CISCA()
  
  #create the filename
  fname <- paste0('results/', this_scientific, '.png')
  
  #export using this filename
  ggsave(speciesmap, file = fname, width = 5, units = 'in')
  
}

#test the function
map_a_species(this_scientific = 'Turdus helleri', this_vernacular = 'Taita Thrush')


#loop through the species_lookup and run the mapping function for each species
for(s in 1:nrow(species_lookup)) {
  map_a_species(this_scientific = species_lookup$species[s],
                this_vernacular = species_lookup$vernacularName[s])
}