setwd("/Users/Rajvi/Desktop/UN Armed Conflicts/")
#make sure that rcharts is selected
vcData = read.csv("asd.csv", header = TRUE)
library(knitr)
kable(head(vcData[,1:9]), format = 'html', table.attr = "class=nofluid")
library(reshape2)
datm <- melt(vcData, 'Year', 
             variable.name = 'State',
             value.name = 'Crime'
)
datm2 <- transform(datm,
                   State = state.abb[match(as.character(State), state.name)],
                   fillKey = cut(Crime, quantile(Crime, seq(0, 1, 1/5)), labels = LETTERS[1:5]),
                   Year = as.numeric(substr(Year, 1, 4))
)
fills = setNames(
  c(RColorBrewer::brewer.pal(5, 'YlOrRd'), 'gray'),
  c(LETTERS[1:5], 'defaultFill')
)
library(plyr); library(rMaps); library(rMaps)
dat2 <- dlply(na.omit(datm2), "Year", function(x){
  y = toJSONArray2(x, json = F)
  names(y) = lapply(y, '[[', 'State')
  return(y)
})
# datm$fillKey<- "E"
# for(x in 1:9) {
#   if (datm[x,3] < 500) {
#     datm[x,4] <- "D"
#   }
#   if (datm[x,3] < 400) {
#     datm[x,4] <- "C"
#   }
#   if (datm[x,3] < 300) {
#     datm[x,4] <- "B"
#   }
#   if (datm[x,3] < 200) {
#     datm[x,4] <- "A"
#   }
#   x = x+1
# }

options(rcharts.cdn = TRUE)
map <- Datamaps$new()
map$set(
  dom = 'chart_1',
  scope = 'world',
  fills = fills,
  data = dat2[[1]],
  legend = TRUE,
  labels = FALSE
)
map