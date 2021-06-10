library(raster)
library(rayshader)
library(elevatr)
library(rayvista)
memory.limit(size = 10e10)

topo_map <- topo_map <- raster::brick("2012-11-30-08-08-07_modified.tif")
topo_map <- raster::stack(topo_map)


elevation <- get_elev_raster(topo_map, z = 11, override_size_check = TRUE)
elevation <- raster::crop(elevation, extent(topo_map))

writeRaster(elevation, "icelandelevlarge1.tif")
