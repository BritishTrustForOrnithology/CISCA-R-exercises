#AIMS: simple anova example
#AUTHOR: Simon Gillings
#DATE: April 2019

library(ggplot2) #for making nice graphics


#read in the data on the richness of beetles in different parts
#of the tree canopy
beetles <- read.csv(file = 'data_raw/beetle_species_richness.csv', stringsAsFactors = FALSE)

#look at the data
head(beetles)
str(beetles)

#to do an ANOVA we need to turn the height class into a factor
beetles$height_class_f <- factor(beetles$height_class)

ggplot(data = beetles) +
  geom_point(aes(x = height_class_f, y = species_richness))

#hmm, OK, nice plot but the classes are in the wrong order
#that's because when we made the factor (Line 17 above) R 
#just used alphabetic ordering. But we can force our own order
beetles$height_class_f <- factor(beetles$height_class, 
                                 levels=c('LOW','MEDIUM','HIGH'))
ggplot(data = beetles) +
  geom_point(aes(x = height_class_f, y = species_richness))

#OK that's much better. But is it true that there are only 3 
#records in the LOW category? Use table() to check
table(beetles$height_class_f)

#OK so some of the dots must be over-plotted. We can fix that in several
#ways. One is to use geom_jitter instead of geom_point to spread
#the points out a bit so we can see there are more data
#use width= to say how much to spread the dots out
ggplot(data = beetles) +
  geom_jitter(aes(x = height_class_f, y = species_richness), width=0.1)

#we could also do a boxplot
ggplot(data = beetles) +
  geom_boxplot(aes(x = height_class_f, y = species_richness))

#OK so looks like some big differences between groups
#let's do an ANOVA to test this
my_anova <- aov(data = beetles, species_richness ~ height_class_f)
#just like the lm we can use summary to get all the stats and fit etc
summary(my_anova)
