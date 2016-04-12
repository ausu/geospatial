# Source: http://amsantac.co/blog/en/r/2015/08/11/leaflet-R.html

leaflet() %>% 
  addTiles() %>%   
  
  #fill: fill polygon with color
  #stroke: draw polygon border
  #color: border color
  addPolygons(data = llanos, fill = FALSE, stroke = TRUE, color = "#03F", group = "Study area") %>% 
  addPolygons(data = wrs2, fill = TRUE, stroke = TRUE, color = "#f93", 
              popup = paste0("Scene: ", as.character(wrs2$PATH_ROW)), group = "Landsat scenes") %>% 
  
  # add a legend
  #define the position, colors and labels of the legend
  addLegend("bottomright", colors = c("#03F", "#f93"), 
            labels = c("Study area", "Landsat scenes (path - row)")) %>%   
  
  # add layers control
  #addLayersControl: allows addition of user interface controls to switch layers on and off
  #options: layersControlOptions to be collapsed or not
  addLayersControl(
    overlayGroups = c("Study area", "Landsat scenes"),
    options = layersControlOptions(collapsed = FALSE)
  )