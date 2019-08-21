#AIMS: do something for every species in a data fram
#AUTHOR: Simon Gillings
#DATE: April 2019

#read some bird records
birds <- read.csv('data_raw/birdtrack_records.csv', stringsAsFactors = FALSE)
head(birds)

#in this example I want to do something for every species
#so first I need to get a list of the unique species names
species_list <- unique(birds$Species)

#start by making a very simple loop that doesn't do anything other
#than print the i value that tells us which loop iteration has run
#the first line tells R what object (i in this case) keeps track of which loop iteration
#we are on, and the numbers say where to start (i = 1) and stop (i = 3) the loop
#the colon is the "to" bit, so read 1:3 as "1 to 3"
for(i in 1:3) {
  print(i)
}

#we can make the loop run for any set of values, like:
for(i in 7:13) {
  print(i)
}


#so whatever is in the loop is done as many times as we ask the loop to run
#we can use the i value to get individual species using square brackets applied to
#the species list
for(i in 1:3) {
  #get the name of the ith species
  one_spec_name <- species_list[i]
  
  #and print this name
  print(one_spec_name)
}

#now that we have a way of getting a species name we can then subset the full 
#dataset to get just the data for one species
for(i in 1:3) {
  #get the name of the ith species
  one_spec_name <- species_list[i]
  
  #get records of this species by subsetting the main birds dataframe
  data_for_one_species <- subset(birds, Species == one_spec_name)
  
  print(data_for_one_species)
}

#so now I have the data for a species I could do whatever I want and this 
#would be repeated for each species. That could be to make a graph or run a model
#Beware that sometimes a species might not have enough data to run a model so you might
#need some extra steps in your loops to check how much data is returned 
#before running a model

#so this loop is going to just check how many records there are per species 
#and print this nicely on screen
#instead of setting the for loop to 1:161, I will first find out how many species are
#in the species list so that this code adapts to how much data I have next time I run it

#as species list is a vector I can find out how many elements in it by getting its length
num_specs <- length(species_list)


#then I can use the length as the second part of the "from:to" bit of the for loop
for(i in 1:num_specs) {
  #get the name of a species
  one_spec_name <- species_list[i]
  
  #get records of this species
  data_for_one_species <- subset(birds, Species == one_spec_name)
  
  #how many records
  num_recs_for_species <- nrow(data_for_one_species)
  
  #make nicer output
  cat(one_spec_name,'\n')
  cat('Number of records: ',num_recs_for_species,'\n\n')
}




