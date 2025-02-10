library(sf)        
library(tidyverse)  
library(viridis)    
library(stars)      
library(ggrepel)    

# Read TIFF
tif <- read_stars("C:/Users/HELAL/Desktop/Population Density/Alexandria/Alexandria_population.tif")

# Convert to sf
sf_alex <- st_as_sf(tif)

# Create percentiles
sf_alex <- sf_alex %>% 
  mutate(pctile = ntile(`Alexandria_population.tif`, 20))

# Set palette
pal <- hcl.colors(20, "viridis", rev = TRUE, alpha = 0.7)

# Read shapefile
alex_shp <- st_read("C:/Users/HELAL/Desktop/Population Density/Alexandria/Alexandria.shp")
plot(alex_shp)
# Base map
base_map <- ggplot() +
  geom_sf(
    data = sf_alex,
    aes(fill = pctile),
    color = NA
  ) +
  scale_fill_gradientn(
    colors = pal,
    name = "Density Percentile"
  ) +
  labs(
    title = "Population Density Map of Alexandria"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    legend.title = element_text(size = 12),
    legend.text  = element_text(size = 10)
  )

# Add boundaries
final_map <- base_map +
  geom_sf(
    data = alex_shp,
    color = alpha("black", 0.5),
    fill = NA,
    size = 0.5
  )

# Add labels
final_map +
  geom_text_repel(
    data = alex_shp,
    aes(label = NAME_2, geometry = geometry),
    stat = "sf_coordinates",
    min.segment.length = 0,
    size = 3,
    fontface = "bold"
  )
