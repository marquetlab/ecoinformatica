library(leaflet)
library(raster)
library(sf)
library(sp)
library(tidyverse)

ChileSol <- read_rds("RasterSolChile.rds")

PA <- read_rds("PA_SF_Chile.rds") %>% as_Spatial()

crs(ChileSol) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

pal <- colorNumeric(c("#0C2C84", "yellow", "red"), values(ChileSol),
                    na.color = "transparent")

leaflet(PA) %>% addTiles() %>% addRasterImage(ChileSol, colors = pal, opacity = 0.8) %>% addLegend(pal = pal, values = values(ChileSol),title = "Priority")%>%
  addPolygons(color = "green", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 1,
              fillColor = "green",
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE), group = "Protected Area", label = ~NAME, popup = ~NAME) %>%
  # Layers control
  addLayersControl(overlayGroups = c("Protected Area"),
    options = layersControlOptions(collapsed = TRUE)) 


library(raster)
library(leaflet)
r <-  read_rds("RasterSolChile.rds")
crs(r) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
colores <- c("#0C2C84", "red")
at <- c(0, quantile(values(ChileSol),c(0.8), na.rm = T), cellStats(r, "max"))
cb <- colorBin(palette = colores, bins = at, domain = at, na.color = "transparent")

leaflet(PA)%>% addTiles() %>% 
  addRasterImage(r, colors = cb, opacity = 0.8) %>%
  addLegend(pal = cb, values = at) %>% addLegend(pal = pal, values = values(ChileSol),title = "Priority")%>%
  addPolygons(color = "green", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 1,
              fillColor = "green",
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE), group = "Protected Area", label = ~NAME, popup = ~NAME) %>%
  # Layers control
  addLayersControl(overlayGroups = c("Protected Area"),
                   options = layersControlOptions(collapsed = TRUE)) 
