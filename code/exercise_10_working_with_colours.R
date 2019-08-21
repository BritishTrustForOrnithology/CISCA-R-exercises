#AIM: test different colour palettes 
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#load the necessary R packages ---------------------------------------------------------------
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data
library(RColorBrewer) #for getting useful colour palettes

#load the necessary data ---------------------------------------------------------------------
load(file = 'data_processed/basemap_outline.RData')
load(file = 'data_processed/kenya_endemics_richness_spatial.Rdata')

#initialise a ggplot2 object with the basemap ------------------------------------------------
basemap <- ggplot() +
  geom_sf(data = basemap_outline, fill = 'white')

#get the richness map using default colours
basemap + 
  geom_sf(data = richness, aes(fill = species)) 

#what colours can RColorBrewer offer us?
display.brewer.all()

#be a bit more selective - how about palettes that do or do not work well for colour-blind people?
display.brewer.all(colorblindFriendly = TRUE)
display.brewer.all(colorblindFriendly = FALSE)

#palettes for sequential data - useful to ordered numerical data
display.brewer.all(type = 'seq')

#see what other types there are...
display.brewer.all()

#show just one palette based on its name
display.brewer.pal(n = 5, name = 'YlOrRd')


#OK let's use this palette for our map
basemap + 
  geom_sf(data = richness, aes(fill = species)) +
  scale_fill_brewer(palette = 'YlOrRd')

#OK that didn't work - need to use scale_fill_distiller instead
basemap + 
  geom_sf(data = richness, aes(fill = species)) +
  scale_fill_distiller(palette = 'YlOrRd')

#oops - got the ordering wrong
basemap + 
  geom_sf(data = richness, aes(fill = species)) +
  scale_fill_distiller(palette = 'YlOrRd', direction = 1)

