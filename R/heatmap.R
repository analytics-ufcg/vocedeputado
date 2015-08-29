library('dplyr')
library('ggplot2')
library('ggmap')

# data preparation
data = read.csv('../data/respostas.csv')
dim(data)
locations = data %>%
  select(lon,lat) %>%
  group_by(lon,lat) %>%
  summarise(freq = n())

locations$lat = as.numeric(locations$lat)
locations$lon = as.numeric(locations$lon)

map_center = as.numeric(geocode("Brazil"))
map = ggmap(get_googlemap(center= map_center, scale = 1, zoom = 17), extent="normal")  
map + geom_point(aes(x=lon, y=lon) , size = locations$freq*0.5, data=locations, col="orange", alpha=0.4) +
  scale_size_continuous(range=range(locations$freq))

## Heatmap
map = get_map(location = ' Brazil', zoom = 7)
ggmap(map, extent = 'device') + geom_density2d(data = locations, aes(x = lon, y = lat), size = 0.3) + 
  stat_density2d(data = locations, 
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)