library("ggmap")
library(maptools)
library(maps)

visited <- c("SFO", "Chennai", "London", "Melbourne", "Johannesbury, SA")
ll.visited <- geocode(visited)
visit.x <- ll.visited$lon
visit.y <- ll.visited$lat
#> dput(visit.x)
#c(-122.389979, 80.249583, -0.1198244, 144.96328, 28.06084)
#> dput(visit.y)
#c(37.615223, 13.060422, 51.5112139, -37.814107, -26.1319199)


#USING MAPS
map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(visit.x,visit.y, col="red", pch=16)