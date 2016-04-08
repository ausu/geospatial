# Load libraries
library(plyr)
library(ggplot2)
library(maptools)

# Load flow data
input <- read.csv("C:\\Users\\Susan\\Documents\\flows\\wu03ew_v1.csv", 
                  sep=",", header=T)

# Select origin and destination information
input <- input[,1:3]
names(input) <- c("origin", "destination", "total")

# Lookup for coordinates
coords <- read.csv("C:\\Users\\Susan\\Documents\\flows\\msoa_popweightedcentroids.csv", 
                   header=T)

# Add xy coordinates
start.xy <- merge(input, coords, by.x="origin", by.y="Code")
names(start.xy) <- c("origin", "destination", "trips", "oName", "oX", "oY")
end.xy <- merge(start.xy, coords, by.x="destination", by.y="Code")
names(end.xy) <- c("origin", "destination", "trips", "oName", "oX", "oY", "dName", "dX", "dY")
all.xy <- end.xy[,c("origin", "oName", "oX", "oY", "destination", "dName", "dX", "dY", "trips")]
  
# Plotting with ggplot2
# Remove axes in resulting plot
xquiet <- scale_x_continuous("", breaks=NULL)
yquiet <- scale_y_continuous("", breaks = NULL)
quiet <- list(xquiet, yquiet)

# Specify dataframe and filter excluding flows of <10
g <- ggplot(all.xy[which(all.xy$trips>100),], aes(oX, oY))


g + geom_segment(aes(x = oX, y = oY, xend = dX, yend = dY, alpha = trips), col = "white") + 
  scale_alpha_continuous(range = c(0.03, 0.3)) + 
  theme(panel.background = element_rect(fill='black',color='black'))+quiet+coord_equal()

# Create automated profiles for each of the senior centers
# Combine the participants data with the facility data
  