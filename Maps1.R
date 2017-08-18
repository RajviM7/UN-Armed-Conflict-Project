library(Quandl)
#vcData = Quandl("FBI_UCR/USCRIME_TYPE_VIOLENTCRIMERATE")
quandle_test <- read_csv("~/Desktop/UN Armed Conflicts/quandle_test.csv")
vcData = quandle_test
library(readr)
#kable(head(vcData[,1:9]), format = 'html', table.attr = "class=nofluid")
library(reshape2)
datm <- melt(vcData, 'Year', 
             variable.name = 'State',
             value.name = 'Crime'
)
datm <- subset(na.omit(datm), 
               !(State %in% c("United States", "District of Columbia"))
)
#kable(head(datm), format = 'html', table.attr = "class=nofluid")
datm2 <- transform(datm,
                   State = state.abb[match(as.character(State), state.name)],
                   fillKey = cut(Crime, quantile(Crime, seq(0, 1, 1/5)), labels = LETTERS[1:5]),
                   Year = as.numeric(substr(Year, 1, 4))
)
#kable(head(datm2), format = 'html', table.attr = "class=nofluid")
fills = setNames(
  c(RColorBrewer::brewer.pal(5, 'YlOrRd'), 'white'),
  c(LETTERS[1:5], 'defaultFill')
)
library(plyr); library(rMaps); library(rCharts)
dat2 <- dlply(na.omit(datm2), "Year", function(x){
  y = toJSONArray2(x, json = F)
  names(y) = lapply(y, '[[', 'State')
  return(y)
})
options(rcharts.cdn = TRUE)
map <- Datamaps$new()
map$set(
  dom = 'chart_1',
  scope = 'usa',
  fills = fills,
  data = dat2[[1]],
  legend = TRUE,
  labels = TRUE
)
map
map2 = map$copy()
map2$set(
  bodyattrs = "ng-app ng-controller='rChartsCtrl'"
)
map2$addAssets(
  jshead = "http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.1/angular.min.js"
)
map2$setTemplate(chartDiv = "
  <div class='container'>
                 <input id='slider' type='range' min=1960 max=2010 ng-model='year' width=200>
                 <span ng-bind='year'></span>
                 <div id='' class='rChart datamaps'></div>  
                 </div>
                 <script>
                 function rChartsCtrl($scope){
                 $scope.year = 1960;
                 $scope.$watch('year', function(newYear){
                 map.updateChoropleth(chartParams.newData[newYear]);
                 })
                 }
                 </script>"
)
map3 = map2$copy()
map3$setTemplate(chartDiv = "
                 <div class='container'>
                 <button ng-click='animateMap()'>Play</button>
                 <div id='chart_1' class='rChart datamaps'></div>  
                 </div>
                 <script>
                 function rChartsCtrl($scope, $timeout){
                 $scope.year = 1960;
                 $scope.animateMap = function(){
                 if ($scope.year > 2010){
                 return;
                 }
                 mapchart_1.updateChoropleth(chartParams.newData[$scope.year]);
                 $scope.year += 1
                 $timeout($scope.animateMap, 1000)
                 }
                 }
                 </script>"
)
map3
source('ichoropleth.R')
ichoropleth(Crime ~ State,
            data = datm2[,1:3],
            pal = 'PuRd',
            ncuts = 5,
            animate = 'Year'
)
