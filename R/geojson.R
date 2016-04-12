library(leaflet)
library(rgdal)

# Public Use Microdata Area (PUMA) from NYC Planning
pumaURL <- "http://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/nypuma/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=geojson"
download.file(pumaURL, destfile="puma.geojson", method="auto")
puma <- readOGR("puma.geojson", "OGRGeoJSON", require_geomType="wkbPolygon")

# Neighborhood Tabulation Area (NTA) from NYC Planning
ntaURL <- "http://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/nynta/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=geojson"
download.file(ntaURL, destfile="nta.geojson", method="auto")
nta <- readOGR("nta.geojson", "OGRGeoJSON", require_geomType="wkbPolygon")

map <- leaflet() %>% 
  #addTiles() %>%
  addProviderTiles("Stamen.Toner") %>%
  addPolygons(data=nta, color="purple") %>%
  addPolygons(data=puma)
map
