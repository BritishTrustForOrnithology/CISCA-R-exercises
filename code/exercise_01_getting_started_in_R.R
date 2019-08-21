#AIM: get the project setup and check R is ready for rest of the session.  
#     Re-familiarise with some base R syntax.
#AUTHOR: Simon Gillings (BTO)
#CREATED: March 2019


#check the working directory ---------------------------------------------------------------------------------
getwd()


#check that we already have some of the important folders in this location ---------------------------------------------------
dir.exists('code')
dir.exists('data_raw')
dir.exists('data_gis')

#create the recommended directory structure ------------------------------------------------------------------
dir.create('data_downloads')
dir.create('data_processed')
dir.create('docs')
dir.create('results')

#try to create a code folder - fails because it is already created. 
#Good - means we can't easily overwrite folder by mistake
dir.create('code')


#check some pacakges are all installed ---------------------------------------------------------------
require(ggplot2) 
require(ggthemes) 
require(sf)
require(rgbif)
require(RColorBrewer)


#read some data -----------------------------------------------------------------------------------------
#read a csv file containing some bird records
dat <- read.csv('data_raw/birdtrack_records.csv')

#check the format
class(dat)
head(dat)
str(dat)

#read again but force strings to be read as character format
dat <- read.csv('data_raw/birdtrack_records.csv', stringsAsFactors = FALSE)
str(dat)

#tidy up the variable names
names(dat)
tolower(names(dat))
names(dat) <- tolower(names(dat))



#a reminder about indexing -----------------------------------------------------------------------
#show the 81st row
dat[81,]
#show the 3rd column
dat[,3]
#show the value in the 81st row and the 3rd column
dat[81,3]


# subsetting --------------------------------------------------------------------------------------
#find all the records of Purple Heron - two ways of doing this:
dat[dat$species == 'Purple Heron',]
subset(dat, species == 'Purple Heron')

#find all the records of Grey or Purple Heron using %in% and c()
subset(dat, species %in% c('Purple Heron', 'Grey Heron'))

#find all the records of buzzards using grep to pattern match
dat[grep('Buzzard', dat$species),]



# editing data -------------------------------------------------------------------------------------
#this is misidentified and should be Steppe Buzzard
dat$species <- ifelse(dat$species == 'Buzzard', 'Buzzard (Steppe - vulpinus)', dat$species)
dat$scientific_name <- ifelse(dat$scientific_name == 'Buteo buteo', 'Buteo buteo vulpinus', dat$scientific_name)
#check it worked
dat[grep('Buzzard', dat$species),]


#remove non-native species
#Ring-necked Parakeet, Common Myna, House Crow
dat_native <- subset(dat, !species %in% c('Ring-necked Parakeet', 'Common Myna', 'House Crow') )



#saving data -------------------------------------------------------------------------------------------
#produce and save a species list
spec_list <- unique(dat_native[,1:2])
save(spec_list, file = 'data_processed/birdtrack_species_list.Rdata')



#tabulating and unique() -------------------------------------------------------------------------------------------
#how many places did I visit?
table(dat$place)
unique(dat$place)
length(unique(dat$place))

#which visits were complete lists?
visits_complete <- subset(dat, list_type == 'Complete', select = c('place','date', 'start_time', 'end_time'))
visits_complete <- unique(visits_complete)



#merging dataframes -------------------------------------------------------------------------------------
#get the locations
bt_locs <- read.csv('data_raw/birdtrack_locations.csv', stringsAsFactors = FALSE)
head(bt_locs)
head(dat_native)

#merge using by.x and by.y
dat_native_with_ll <- merge(dat_native, bt_locs, by.x = 'place', by.y = 'locname')

#note number of observations has changed
#note that obs of bt_locs is smaller than in dat

#try merge again with all = TRUE to include all of both dataframes
dat_native_with_ll <- merge(dat_native, bt_locs, by.x = 'place', by.y = 'locname', all = TRUE)
dat_native_with_ll[is.na(dat_native_with_ll$latitude),]

#Fortunately I know what it is - how can we correct these missing values?
#Avdat	30.7922	34.76905


#functions ------------------------------------------------------------------------------------------------
#produce a function to generate some summary information for a species on demand
spec_summary <- function(this_spec) {
  #make a temporary dataset for this species
  temp <- subset(dat_native_with_ll, species == this_spec)
  #count how many rows in total
  nrecs <- nrow(temp)
  
  #get a vector containing the unique site names
  locs <- unique(temp$place)
  #count how long the vector is
  nlocs <- length(nlocs)
  
  #calculate reporting rate - need to merge records from complete lists against list of complete lists
  temp_from_complete <- subset(temp, list_type == 'Complete')
  #make a recorded column
  temp_from_complete$present <- 1
  #merge records against the master list of complete visits to find the visits where the species wasn't present
  temp_from_complete <- merge(temp_from_complete, visits_complete, by = c('place','date','start_time','end_time'), all.y = TRUE)
  #visits were the species was absent will have an NA for present - replace these with a zero
  temp_from_complete$present[is.na(temp_from_complete$present)] <- 0
  #now averaging the 1s and 0s in that column will give the reporting rate, or % of visits on which detected
  reporting_rate <- 100*mean(temp_from_complete$present)
  
  #produce a print out
  cat(toupper(this_spec),'\n')
  cat('Number of records = ', nrecs, '\n')
  cat('Number of occupied sites = ', nlocs, '\n')
  cat('Reporting rate = ', reporting_rate, '\n\n')

  #return the values
  return(data.frame(this_spec, nrecs, nlocs, reporting_rate))
}


spec_summary('Purple Heron')
spec_summary('Dead Sea Sparrow')


#loops --------------------------------------------------------------------------------------------------
#write a simple for() loop to apply this function to each species in the spec_list
for(i in 1:5) {
  #get the name of the ith species in the spec_list
  a_spec <- spec_list$species[i]
  
  #execute the function for this species
  spec_summary(a_spec)
}


