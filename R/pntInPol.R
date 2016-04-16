library(sp)
library(rgdal)
library(raster)
library(spatialEco)

#SppatialPointsDataFrame
coordinates(inPnt) <- c("longitude", "latitude")

#Change projection so objects on same coordinate reference system
proj4string(inPol)
proj4string(inPnt)
spTransform(inPnt, CRS(proj4string(inPol)))

#containment test
insidePoly <- !is.na(over(pnt, as(pol, "SpatialPolygons")))
mean(insidePoly) #fraction of points in polygon

#determine which polygon contains each point
#store polygon name as attribute in points data
pnt$pol <- over(pnt, pol)$name

#Spatial subsetting
spSubset <- inPnt[inPol, ]
# select points of A inside or on some geometry B (polygons)
A[B,]

# Points in polygons: intersection betwen points & polygon
# returns point with polygon's attributes data
#point.in.polygon(pnt.x, pnt.y, pol.x, pol.y)
over(pnt, pol)
point.in.poly(pnt, pol)

#dissolve: aggregate polygons
aggregate(xpoly)


