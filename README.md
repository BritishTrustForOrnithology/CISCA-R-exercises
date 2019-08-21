# CISCA-R-exercises
This repository contains R exercises and required data files for practicals given as part of the Citizen Science in Africa training program. The course was a collaboration between BTO, the Tropical Biology Association, Cambridge Zoology Museum and the Nairobi National Museum, Kenya. It was funded by the Cambridge Conservation Initiative's Collaborative Fund.

The purpose of the exercises was to introduce participants to R, showing how it can be used as part of a workflow to import and clean citizen science data and produce maps. For simplicity the code uses as few packages as possible and concentrates on use of the sf package for manipulating spatial data and the ggplot2 package for making map images. Exercises 1 to 13 were given in Nairobi, Kenya (April 2019) so use maps and data relating to Kenya. Subsequent exercises were written after the course to help with outstanding issues and cover other parts of Africa.

#Requirements
Before starting please ensure you have R version >=3.5.1 and the following packages installed (version indicates version used at time of writing):
*ggplot2 (3.2.1)
*ggthemes (4.2.0)
*sf (0.7-7)
*rgbif (1.3.0)
*RColorbrewer (1.1-2)
*devtools (2.1.0)
*rabm (0.1.0; devtools::install_github("davidclarance/rabm"))


# Exercises
Run through the exercises in order as there is some dependency from one to the next (e.g. generating certain saved objects).

##Exercise 1 - Getting started in R
The program checks the course participant's R environment has the required pacakges and creates some folders for later work. It then illustrates some general data manipulation steps such as reading a csv file, accessing bits of data using indexing and subsetting, editing data, saving Rdata files, merging dataframes, loops and writing a function. The last was written interactively with the participants.

##Exercise 2 - Where is my study area
Introduces the basics of the sf package to read a shapefile of African countries, checking for and setting the coordinate reference system. A map is produced, with a country of interest shown in a different colour and saved as an image file.

##Exercise 3 - Making a basemap for my country
More detailed use of sf package to read the administrative states of Kenya, merge them together to produce a single country outline. The outline is simplified for visualisation purposes, showing how to transform to a different projection system. Finally an acceptable country outline for use in all subsequent maps is saved as a Rdata file so it can be used elsewhere.

##Exercise 4 - Adding some basic data to basemap
Now we have a basemap we can add some data to it. In this exercise we import polygons for protected areas and waterbodies and add these to the map. We look at how to change the colour and transparency of plotted objects. And we annotate the map by adding a point and text for Nairobi.

##Exercise 5 - Download and map records from GBIF
This exercise uses the rgbif pacakge to interact with the GBIF database to download records of endemic birds in Kenya. The exercise requires that you have registered with GBIF and it will need to be edited to add your username, registered email address and password in order to download the required data. Once the data have been downloaded they undergo some data checking routines by mapping and subsetting to  remove poor quality records. This illustrates a safe workflow where the original data is untouched, all maniplation is done in code (so can be repeated and documented) and a clean dataset is saved for use elsewhere.

##Exercise 6 - Styling the non-data parts of the map
Using the cleaned GBIF data this exercise looks at how we can make a nice map by styling the static parts of the image, i.e. those bits that are not dependent on the data. It introduces the ggthemes package and how it is possible to apply a custom theme to all maps.

##Exercise 7 - Automating map production
This exercise uses a function and a loop to show how it is possible to iterate through a set of species and repeat actions, in this case produce and save a map image.

##Exercise 8 - Grids, polygons and centroids
As it is often necessary to summarise data within grid squares, this exercise shows how functions in the sf package can be used to create grids, and from these to generate centroid coordinates which can be used in later maps. Grids and centroids are saved for later use.

##Exercise 9 - Chloropleth map of endemic bird richness
Here we use the previously generated grids to summarise the number of endemic bird species recorded in 1-degree grid cells. These summarised data are merged with the grid polygons to enable production of a chlropleth map, with shaded cells indicating variation in species richness.

##Exercise 10 - Working with colours
Examples of how the RColorbrewer package can be used to generate colour palettes for maps, including having consideration of colour blindness.

##Exercise 11 - Linear regression
A simple example of how to perform linear regression in R and to visualise the results.

##Exercise 12 - Anova
A simple example of how to perform an ANOVA in R and to visualise the results.

##Exercise 13 - Writing a loop
Various examples of how to formulate loops that automate some procedures.

##Exercise 14 - Making a shapefile from GPS coordinates
All the examples so far have used existing shapefiles. In this exercise we use coordinates provided in csv files and kml files to create new spatial objects in R. These are plotted onto a national park map. The spatial objects are saved as shapefiles so they can be used in other R programs or in external GIS packages.

##Exercise 15 - Using rabm package to connect to SABAP
David Clarance is developing a package called rabm which directly interfaces with the SABAP database and allows users to extract raw and summary data for countries, pentads and people. This is a work in progress.

##Exercise 16 - Cropping existing outline to focal study area
Sometimes we may want to zoom in to a part of a map, or create custom polygons. In this example we are interested in generating a polygon for the maritime region off the Cameroon coast. The exercise uses various sf functions to intersect the country outline with an arbitrary rectangular bounding box to generate a new polygon for the sea.


##Other files
theme CISCA.R	contains the code for a ggtheme for use in map making.


Simon Gillings
August 2019