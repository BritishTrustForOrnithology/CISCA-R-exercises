#a custom theme for styling a map
#inherits and modifies the theme_few() style
#Simon Gillings
#April 2019

theme_CISCA <- function(...) {
  theme_few() +
    theme(
      #layout
      plot.margin = margin(0, 0, 0, 0, "cm"), #control the margin between the plot and edge of image

      #text formatting
      text = element_text(family = "sans", color = "#386cb0"), #control all text
      
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
      legend.background = element_rect(fill = "white", color = NA)
      
    )
}



