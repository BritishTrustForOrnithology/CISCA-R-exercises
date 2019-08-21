#AIMS: simple linear regression example
#AUTHOR: Simon Gillings
#DATE: April 2019

#read a csv file containing information on the water content of soil
#and the density of worm casts
worms <- read.csv(file = 'data_raw/water_and_worms.csv', stringsAsFactors = FALSE)

#check what the data look like
class(worms)
head(worms)
str(worms)

#oh, there's a typo in one of the variable names
#use names() to get the names, and use square brackets to decide
#which one of the names to fix
names(worms)[1] <- 'percent_water'

#get some simple summary stats of all the variables 
summary(worms)

#get summary stats for just one variable
summary(worms$percent_water)

#plot the relationship - we expect it might be a positive relationship
library(ggplot2)
#as we are using just one dataset we can name it when we girst call ggplot()
ggplot(data = worms) +
  geom_point(aes(x = percent_water, y = worm_cast_density))

#now I would like to produce a simple linear regression model 
#to test how strong the evidence is that water is related to worms
#I use the lm() function which requires I tell it which data to 
#use and a formula to say which is the response variable (on left of ~)
#and which variable(s) is the covariates
lm(data = worms, worm_cast_density ~ percent_water)

#OK so that printed some basic info to the screen because I did not
#assign the model I created to an object 
#now run it again, this time assigning the results of the model
#to a new object called my_model
my_model <- lm(data = worms, worm_cast_density ~ percent_water)

#let's just check what we got
class(my_model)

#we can get a summary of this model. Note that whereas summary of a 
#dataframe (above) gave us the min, max, mean etc of the variables
#if we do summary of an lm object we get all the info on model fit etc
summary(my_model)

#we  might want to not only print this stuff, we might want to use
#any the values in other calculations. 
#so let's check what things we got within the model 
names(my_model)

#and we can access these just like in a data frame
my_model$coefficients
#...and assign particular ones to new variables
slope <- my_model$coefficients[2]

#ggplot has some nice ways of visualising the relationships
#using geom_smooth
ggplot(data = worms) +
  geom_point(aes(x = percent_water, y = worm_cast_density)) +
  geom_smooth(aes(x = percent_water, y = worm_cast_density), method = 'lm')

