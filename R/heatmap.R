library('dplyr')
library('ggplot2')
library('ggmap')
library(rjson)
# data preparation
data = read.csv('../data/respostas.csv')
locations = distinct(data, usuario, lat, lon)
locations
locations = filter(locations, lat != 'None' & lon != 'None')

locations$lat = as.numeric(as.character(locations$lat))
locations$lon = as.numeric(as.character(locations$lon))

locations = locations %>%
  select(lon,lat) %>%
  group_by(lon,lat) %>%
  summarise(count = n())


json_file <- toJSON(unname(split(locations, 1:nrow(locations))))
json_file
write(json_file, "../web/localidades.json")