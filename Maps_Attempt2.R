library(rMaps)
ichoropleth(Crime ~ State, data = subset(violent_crime, Year == 2010))
ichoropleth(Crime ~ State, data = violent_crime, animate = "Year")
ichoropleth(Crime ~ State, data = violent_crime, animate = "Year", play = TRUE)