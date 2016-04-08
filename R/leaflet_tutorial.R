library(leaflet)
library(rgdal)
library(maps)
library(dplyr) #select

# Import shapefiles of three states from maps library
mapStates <- map("state", fill=TRUE, plot=FALSE,
                 region=c('california','oregon','washington:main'))

# Create map widget with leafelt()
m <- leaflet() %>%
    
    #set view: centre and extent on map
    setView(lng=) %>%
    
    #map layers
    addTiles(urlTemplate="http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
    addMarkers(lng=-116.4697, lat=32.60758, popup="Campo") %>%
    addMarkers(lng=-120.7816, lat=49.06465, popup="Manning Park, Canada") %>%
    addPolygons(data=mapStates, fillColor = heat.colors(3, alpha=NULL), stroke=FALSE) %>%
    
    #legend
    addLegend(position='topright', colors='blue', labels='PCT', opacity=0.4, title='Legend')

# Print map
m 

library(shiny)

app <- shinyApp(
    ui <- fluidPage(leafletOutput('myMap')),
    server <- function(input, output) {
        map <- m
        output$myMap <- renderLeaflet(map)
    }
)

if (interactive()) print(app)

library(tigris)
library(acs)
library(stringr)

# FIPS code: NY (36), Bronx (005), Kings (047), New York (061), Queens (081), Richmond (085) 
# Get spatial data with tigris
counties <- c("Bronx", "Kings", "New York", "Queens", "Richmond")
counties <- c(5, 47, 61, 81, 85)
tracts <- tracts(state = 'NY', county = counties, cb = TRUE)

# Set API key from US Census (need for acs)
api.key.install(key = "79bec82d8e28287b335b67d734b05b28c6c87318")

# Create geographic set to get tabular data with acs
geo <- geo.make(state = c("NY"),
                county = c(5,47,61,81,85), tract = "*")

# list of items available in income
# colnames="pretty: full column definitions
# col.names="auto": Census variable IDs
income <- acs.fetch(endyear = 2012, span = 5, geography = geo, 
                    table.number = "B19001", col.names = "pretty")

#income <- acs.fetch(endyear = 2012, span = 5, geography = geo, 
#                    table.number = "B19001", col.names = "auto")

names(attributes(income))
attr(income, "acs.colnames")

# convert to data.frame
income_df <- data.frame(paste0(str_pad(income@geography$state, 2, "left", pad="0"),
                              str_pad(income@geography$county, 3, "left", pad="0"),
                              str_pad(income@geography$tract, 6, "left", pad="0")),
                       income@estimate[,c("Household Income: Total:",
                                          "Household Income: $200,000 or more")],
                       stringsAsFactors = FALSE)

income_df <- select(income_df, 1:3)
rownames(income_df) <- 1:nrow(income_df)
names(income_df) <- c("GEOID", "total", "over200")
income_df$percent <- 100*(income_df$over200/income_df$total) #need to normalize population size

# merge spatial and tabular data with tigris
income_merged <- geo_join(tracts, income_df, "GEOID", "GEOID")
# exclude tracs with no land
income_merged <- income_merged[income_merged$ALAND>0,]

# leaflet map
popup <- paste("GEOID: ", income_merged$GEOID, "<br>", 
               "Percent of Household above $200K: ", round(income_merged$percent,2))
pal <- colorNumeric(
    palette = "YlGnBu",
    domain = income_merged$percent
)

mapCD <- leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(data=income_merged,
                fillColor = ~pal(percent),
                color="#b2aeae",
                fillOpacity=0.7,
                weight=1,
                smoothFactor=0.2,
                popup=popup) %>%
    addLegend(pal=pal,
              values=income_merged$percent,
              position="bottomright",
              title="Percent of Households <br> above $200k",
              labFormat = labelFormat(suffix="%"))



