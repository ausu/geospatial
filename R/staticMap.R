#https://andybeger.com/2012/08/25/scale-and-north-arrow-for-maps-in-r/#more-180

# position is in map units, latitude/longitude
library(maps)
map.scale(x=,y=,ratio=False,relwidth=0.2)

library(GISTools)
north.arrow(xb=,yb=,len=,lab="N")

plotVar <-
  nColors <-
  breaks <-
  title <- ""
legend <-""

ThematicMap<-function(plotVar, nColors, breaks, title, legend) {
  require(maptools)
  require(shape)
  require(RColorBrewer)
  require(GISTools)
  require(maps)
  
  #plotvar <- unlist(vector)
  plotColor <- brewer.pal(nColors, palName)
  fillColor <- colorRampPalette(plotColor)
  plotVar[plotVar >= maxY] <- maxY -1
  colCode <- fillColor(maxY)[round(plotvar) + 1]
  
  plot(x, col = colCode, lty = 0, border = "gray")
  plot(y, add=TRUE, lwd=1, border = "gray30")
  #plot(z, add=TRUE, lty="solid", lwd=1.5, col="darkblue")
  
  map.scale(x=15.5, y=42.75, relwidth=0.2, ratio=FALSE)
  north.arrow(xb=15.75, yb=43.25, len=0.05, lab="N")
  
  title(main = title)
  colorlegend(posy = c(0.05,0.9), posx = c(0.9,0.92),
              col = fillRed(maxY),
              zlim=c(0, maxY), zval = breaks,
              main = legend,
              main.cex = 0.9)
  
  par(bg='white')
  
}