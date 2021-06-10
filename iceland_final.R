library(raster)
library(rayshader)

topo_map <- topo_map <- raster::brick("icelandcrop.tif")
topo_map <- raster::stack(topo_map)

elevation1 <- raster::raster("icelandelev11.tif")

names(topo_map) <- c("r", "g", "b")
topo_r <- rayshader::raster_to_matrix(topo_map$r)
topo_g <- rayshader::raster_to_matrix(topo_map$g)
topo_b <- rayshader::raster_to_matrix(topo_map$b)
topo_rgb_array <- array(0, dim = c(nrow(topo_r), ncol(topo_r), 3))

topo_rgb_array[,,1] <- topo_r/255
topo_rgb_array[,,2] <- topo_g/255
topo_rgb_array[,,3] <- topo_b/255

## the array needs to be transposed, just because.

topo_rgb_array <- aperm(topo_rgb_array, c(2,1,3))

elev_mat1 <- raster_to_matrix(elevation1)
elev_mat = resize_matrix(elev_mat1, 0.125)
ray_shadow <- ray_shade(elev_mat, sunaltitude = 40, zscale = 30, multicore = TRUE)
ambient_shadow <- ambient_shade(elev_mat, zscale = 30)


#elev_mat1 = resize_matrix(elev_mat, scale = 2)


elev_mat %>%
  sphere_shade(texture = "bw") %>%
  add_overlay(topo_rgb_array) %>%
  add_shadow(ray_shadow, max_darken = 0.7) %>%
  add_shadow(ambient_shadow, 0.25) %>%
  plot_map()

plot_3d(topo_rgb_array,elev_mat, zscale = 7, windowsize = c(1800,2400), 
        phi = 40, theta = 135, zoom = 0.9, 
        background = "grey30", shadowcolor = "grey5", 
        )
render_camera(theta = 0, phi = 89, zoom = 0.54, fov = 0)

render_highquality('iceland4.png', lightintensity = 600, samples = 400,
                   width = 7200, height = 4800, lightdirection = 135)
