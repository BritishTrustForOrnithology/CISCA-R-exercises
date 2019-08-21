#AIM: add some data to our basemap from a data frame
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019

#' load the necessary R packages
library(ggplot2) #for making nice graphics
library(sf) #for reading and basic manipulation of spatial data
library(rgbif) #for downloading data from GBIF


#get data from GBIF
#This section of code only needs to be run once, so it is commented out at present
#To run it you will need to have registered an account with GBIF, and you will need the 
#username, email address and password in the download request below
#
#install.packages("rgbif")
#see https://cran.r-project.org/web/packages/rgbif/vignettes/downloads.html

#Here is the list of Kenyan endemics:
#Hinde's Babbler 2493301
#Clarke's Weaver 2494010
#Sharpe's Longclaw 6094232
#Aberdare Cisticola 2492789
#William's Lark = 2490590
#Taita Apalis = 5788692
#Tana River Cisticola = 2492829
#Kikuyu White-eye = 5846029
#Taiti Thrush = 5789050

#create a download request
# endemics_request <- occ_download('taxonKey = 2493301,2494010,6094232,2492789,2490590,5788692,2492829,5846029,5789050',
#             user = 'GBIF_username', 
#             pwd = 'GBIF_password', 
#             email = 'GBIF_email')

#check the status of the request...
# occ_download_meta(endemics_request)

#...when it has succeeded, then get the file (this just downloads a zip file)
# endemics_file <- occ_download_get(endemics_request, overwrite = TRUE, path = 'data_downloads')

#now import the file into R
# kenya_endemics_gbif <- occ_download_import(endemics_file)
#if running in a later session and wanting to re-import the file, use the following code, substituting the key
#for the long numerical file name of the zip file in data_downloads :
kenya_endemics_gbif <- occ_download_import(key = '0000617-190307172214381', path = 'data_downloads')


#check out the file
dim(kenya_endemics_gbif)
#970 records with 237 variables!
names(kenya_endemics_gbif)

#for now just reduce to some important variables
kenya_endemics_gbif <- subset(kenya_endemics_gbif, 
                              select = c(decimalLatitude, 
                                         decimalLongitude, 
                                         countryCode,
                                         eventDate, 
                                         species, 
                                         vernacularName,
                                         year, 
                                         hasCoordinate, 
                                         hasGeospatialIssues))


#check taxonomic and name info
species_info <- unique(kenya_endemics_gbif[,c('species','vernacularName')])
print(species_info, n = nrow(species_info))

#which ones do we want to keep? Save as a species lookup
species_lookup <- species_info[c(1,9,10,11,12,13,14,15,16),]
save(species_lookup, file = 'data_processed/species_lookup.Rdata')

#remove vernacularName column
kenya_endemics_gbif$vernacularName <- NULL

#check all records are mappable
table(kenya_endemics_gbif$hasCoordinate)
kenya_endemics_gbif <- subset(kenya_endemics_gbif, hasCoordinate == TRUE)


#add the records to the map
basemap + 
  geom_point(data = kenya_endemics_gbif, aes(x = decimalLongitude, y = decimalLatitude))

#OK we have a problem record
table(kenya_endemics_gbif$hasGeospatialIssues)

#inspect
subset(kenya_endemics_gbif, hasGeospatialIssues == TRUE)

#remove this record
kenya_endemics_gbif <- subset(kenya_endemics_gbif, hasGeospatialIssues == FALSE)
#save the data for later use

#also, note the year - any other old records we don't really want?
table(kenya_endemics_gbif$year)
#yes, trim to recent period
kenya_endemics_gbif <- subset(kenya_endemics_gbif, year >=1990)


#try mapping again
basemap + 
  geom_point(data = kenya_endemics_gbif, aes(x = decimalLongitude, y = decimalLatitude))

#we still have some records of endemics that are apparently outside Kenya!
#check the country of the records
table(kenya_endemics_gbif$countryCode, kenya_endemics_gbif$species)
#these records need following up but for now remove
kenya_endemics_gbif <- subset(kenya_endemics_gbif, countryCode != 'TZ')

#recheck map
basemap + 
  geom_point(data = kenya_endemics_gbif, aes(x = decimalLongitude, y = decimalLatitude))

#ok save the cleaned data file for later use
save(kenya_endemics_gbif, file = 'data_processed/kenya_endemics_gbif.Rdata')






