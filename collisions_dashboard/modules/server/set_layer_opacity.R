#' set_layer_opacity
#' 
#' Change the layer opacity.
#' 
#' @param layer layer name
#' @param opacity opacity, a number between 0 and 1
#' 
#' @return JavaScript


set_layer_opacity = function(layer, opacity) {
    shinyjs::runjs(paste0('var el  = document.getElementById("map");
                           var map = $(el).data("leaflet-map");
                           var lyr =  map.layerManager.getLayerGroup("', layer, '")
                           if (map.hasLayer(lyr)) {
                               lyr.setStyle({fillOpacity: ', opacity,', opacity: ', opacity, '})
                           }'
    ))
}