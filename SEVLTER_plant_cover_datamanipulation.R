####### To reshape SEV estimated plant biomass (or cover) data to wide format for analysis #############
#######  J Rudgers February 2022 ##############################################################
# give R a blank slate
rm(list=ls(all=TRUE))

# call up libraries
library(reshape2)
library(vegan)
library(tidyverse)

# Set working directory
# Example: setwd("C:/Users/jrudgers/Desktop/SEV Data/NPP/")

# Import data
# Or use this function to import: read.csv(file.choose())
cover <- read.csv("sev330_NPP_quad_cover_height.csv",stringsAsFactors = T)
str(cover)
#year	season	collection_date	site	treatment	transect	
# web	block	plot	subplot	quad	species	obs	cover	height	
# count	field_comments	qaqc_comments	field_sheet_name	collector	quadID

# create unique identifier for each quadrat using all the information
cover$quad_ID<-as.factor(paste(cover$site,cover$treatment,cover$transect,cover$web,cover$block,cover$plot,cover$subplot,cover$quad,sep="_"))

# create total cover per obs by multiplying cover and count
cover$cover.count<-cover$cover*cover$count
# Note: you may want to change this to plant volume by also multiplying height, but we don't measure height for all species, so cover is better

# cast the data to create columns for each plant species  ---------------------
cover_species<-dcast(cover,year+season+site+treatment+transect+web+block+plot+subplot+quadID+quad_ID ~ species,sum,value.var="cover.count",fill=0)
# can do the same for photosynthetic pathway or life history: annual, perennial, grass, forb
# if you first merge the data with the plant species list information on EDI
# at bottom of page you can get R code to import data directly from EDI!
# 
#cover_path<-dcast(cover,year+site+treat+season+web+plot+subplot+quad_ID+quad~path,sum,value.var="weight",fill=0)
#cover_apgf<-dcast(cover_cntrl,year+site+treat+season+web+plot+subplot+quad_ID+quad~apgf,sum,value.var="weight",fill=0)

#get rid of column called EMPTY - this was a placeholder for quadrats that had bare ground, not a real species
levels(cover$species)
cover_species <- cover_species %>% select(-EMPTY)

# calculate total cover
cover_species$totcover<-rowSums(cover_species[,12:302])
# the columns selected are all the columns that are now plant species total covers

# calculate creosote cover for years STEMs were split out from leaves
cover_species$CREO<-cover_species$LATR2+cover_species$STEM
summary(cover_species$CREO)
# might want to look at CREO over time to see if methods affect estimates.
# watch out for blip in 2011 when they died back from freeze

# add plant species richness, diversity, evenness
# uses functions in the vegan package
?vegan
cover_species$richness<-specnumber(cover_species[,12:302])
cover_species$shannonH<-diversity(cover_species[,12:302])
cover_species$evenness<-cover_species$shannonH/log(cover_species$richness+1)

summary(cover_species)
summary(cover_species$evenness)
summary(cover_species$richness)

#subset the data for focal experiments
summary(cover_species$site)
cover_warming <- cover_species %>% filter(site=="warming")
summary(cover_warming)

cover_MVE_black <- cover_species %>% filter(site=="meanvar_black")
summary(cover_MVE_black)

cover_MVE_blue <- cover_species %>% filter(site=="meanvar_blue")
summary(cover_MVE_blue)

cover_MRME <- cover_species %>% filter(site=="MRME")
summary(cover_MRME)

cover_fertilizer <- cover_species %>% filter(site=="fertilizer")
cover_NutNet <- cover_species %>% filter(site=="NutNet")
cover_crust <- cover_species %>% filter(site=="crust_grass")
cover_EDGEblack<- cover_species %>% filter(site=="EDGE_black")

# Write out a new file with quad level data matrix: 
# each row is a quad, observed at one time point

# Examples:
write.csv(cover_MVE_blue, "plant_cover_MVE_PlainsGrassland.csv")
write.csv(cover_MVE_black, "plant_cover_MVE_DesertGrassland.csv")





write.csv(cover_warming, "cover_warming.csv")

write.csv(cover_MRME, "cover_MRME.csv")
write.csv(cover_NutNet, "cover_NutNet.csv")
write.csv(cover_crust, "cover_crust.csv")







