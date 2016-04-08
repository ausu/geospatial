# Edited: 2016 April 7
# based on code from zevross.com tutoial

# Extract variable from list
# sapply: applies function to elements in list and returns vector, matrix, or list
getListValue <- function(val){
    selectVar <- sapply(dataIn, function(x) x[[val]])
    return(t(selectVar))
}

# Download Data
#install.packages("rjson")
#library(rjson)
#test <- fromJSON(,url)

library(RJSONIO) #read in JSON file
url <- "https://data.cityofnewyork.us/api/views/gtwb-v72z/rows.json?accessType=DOWNLOAD"
dataDL <- fromJSON(url); str(dataDL)
dataIn <- dataDL[['data']]

# Format DFTA Senior Center Map
dataIn[[1]][[14]] #geo
getGeo <- getListValue(14); head(getGeo)

x <- "split the words in a sentence."
strsplit(x,"")

lat <- unlist(getGeo[,2])
long <- unlist(getGeo[,3])
coords <- cbind(lat,long)

getAttr <- as.matrix(sapply(1:13, getListValue))
bindAttrCoords <- cbind(getAttr,coords)

# Final dataframe for senior centers
sc <- as.data.frame(bindAttrCoords[,c(9:15)], stringsAsFactors=F)
names(sc) <- c("name", "sponsor", "boro", "zip", "phone", "lat", "long")
sc$lat <- as.numeric(sc$lat)
sc$long <- as.numeric(sc$long)
str(sc)

library(leaflet)
m <- leaflet() %>%
    
    #map layers
    addTiles(urlTemplate="http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
    addMarkers(sc$long, sc$lat, popup=paste("<b>","NAME: ", "</b>", sc$name,"<br>", 
                                         "<b>", "SPONSOR: ", "</b>", sc$sponsor))

#Print map
m

#SHINY

library(shiny)

app <- shinyApp(
    ui <- fluidPage(leafletOutput('mapApp')),
    server <- function(input, output){
        map <- m
        output$mapApp <- renderLeaflet(map)
    }
)

if(interactive())print(app)


#**********************************************************************************************#
