#AIM: get data from SABAP database using package by David Clarance
#AUTHOR: Simon Gillings (BTO)
#CREATED: August 2019

#download the rabm pacakge only needs to be done once
# install.packages("devtools") #if not already installed
# library(devtools)
# install_github("davidclarance/rabm")

library(rabm)
#Vignette: https://davidclarance.github.io/rabm/articles/rabm-vignette.html

# get species list for nigeria
nigeria_species_list <- get_species_list("nigeria")
head(nigeria_species_list)

#get data for one pentad (Jos)
pentad_data <- extract_all(start_date = '2007-01-01',
            end_date = '2019-08-20',
            region_type = 'pentad',
            region_id = '0955c0855'
            )

head(pentad_data)
names(pentad_data)
