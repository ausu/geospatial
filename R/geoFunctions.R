library(spatstat)
as.ppp(X)
as.ppp(Y)

#find nearest neighbor in Y of each point X; y can be line segment
nncross(X, Y, k=1)

#compute Euclidean distance matrix between set of points
#X and Y are point paterns
crossdist(X, Y)
crossdist(x1, y1, x2, y2)

library(rgeos)
#intersect (analysis/overlay)
gIntersection()
#buffer (analysis/proximity)
gBuffer
#erase (analysis/overlay)
gDifference
#near (analysis/proximity)
gDistance


#Plot pie charts on maps
#http://www.molecularecologist.com/2012/09/making-maps-with-r/
#z: portions of pie charts filled by each given type
#x&y: coordinates for point
#radius: size of circle for pie chart
library(mapplots)
add.pie(z=c(east,west), x=lon, y=lat, radius=sqrt(tot), 
        col=c(alpha("orange", 0.6), alpha("blue", 0.6)),
        labels="")