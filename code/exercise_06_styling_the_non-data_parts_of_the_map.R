#AIM: styling the map
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#' load the necessary R packages
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data
library(ggthemes)

#get the basemap
load(file = 'data_processed/basemap_outline.RData')

#get the bird data
load(file = 'data_processed/kenya_endemics_gbif.Rdata')

basemap <- ggplot() +
  geom_sf(data = basemap_outline, fill = 'white', col = 'grey50') 
basemap

#make a map for one species using index subsetting. Add a title to the map
#use shape = 16 if need to avoid dot border
#this means we can use alpha value to make the dots transparent
speciesmap <- basemap +
  geom_point(data = kenya_endemics_gbif[kenya_endemics_gbif$species == 'Turdoides hindei',], 
             aes(x = decimalLongitude, y = decimalLatitude),
             col = 'orange', alpha = 0.5, size = 4, shape = 16) +
  labs(title = "Hinde's Babbler")

#show the map
speciesmap

#map looks OK but do we really want the grey shading? do we really need latlongs?
#turn on and off individual elements using theme()
speciesmap +
  theme(axis.title = element_blank(), 
        axis.text = element_blank())
  
#we can adopt existing "themes" from the ggthemes package
speciesmap
speciesmap + theme_bw()
speciesmap + theme_few()

#or define your own theme
#https://timogrossenbacher.ch/2016/12/beautiful-thematic-maps-with-ggplot2-only/
#https://ggplot2.tidyverse.org/reference/theme.html
theme_CISCA <- function(...) {
  theme_few() +
    theme(
      #layout
      plot.margin = margin(0, 0, 0, 0, "cm"), #control the margin between the plot and edge of image

      #text formatting
      text = element_text(family = "sans", color = "DarkGreen"), #control all text
      
      #axis stuff
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      
      #control the grid
      panel.grid = element_line(colour="transparent"), #20190306 this is a workaround as element_blank() is not working (reported bug)
      #panel.grid.major = element_line(color = "red", size = 0.2), #control the main grid
      #panel.grid.minor = element_blank(), #control the minor grid (if shown)
      panel.border = element_blank(),
      
      #control fill colours of backgrounds etc
      #plot.background = element_rect(fill = "red", color = NA), #to change the colour of the canvas
      #panel.background = element_rect(fill = "orange", color = NA), #to change the color of the plot area
      legend.background = element_rect(fill = "#f5f5f2", color = NA)

    )
}

#apply the theme to our species map
final <- speciesmap + theme_CISCA()
final

#save some images
ggsave(final, file = 'results/babbler.png', width = 5, units = 'in')
ggsave(final, file = 'results/babbler.pdf', width = 5, units = 'in')

