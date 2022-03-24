# SEVLTER_plant_cover_datamanipulation
Converting plant quadrat data from long to wide format

This script contains code for data manipulations that are often necessary before analyzing plant quadrat data. 

The Sevilleta LTER  NPP (net primary production) dataset includes cover measurements for each individual plant in each of many one-square-meter quadrats. This code will reshape the data to a wide format with a row for each quadrat/sampling event, and a column for each species, containing the total percent cover of that species in that quadrat.
