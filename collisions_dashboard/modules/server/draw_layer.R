#' draw_layer
#' 
#' Redraw a layer when the map bounds change.
#' 
#' @param layer layer metadata from `feature_services` list
#' @param bounds the current map bounds
#' 
#' @return HTML

draw_layer = function(layer, bounds) {
    
    construct_envelope = function(n, s, e, w) {
        paste0('/query?geometryType=esriGeometryEnvelope&geometry=', w, ',', s, ',', e, ',', n)
    }
 
    envelope = construct_envelope(bounds$north, bounds$south, bounds$east, bounds$west)
    leafletProxy('map') %>% clearGroup(layer$group)
    
    if(layer$type == 'point') {
        leafletProxy('map') %>%
            addEsriFeatureLayer(paste0(layer$service_url, envelope), group = layer$group, markerType = 'circleMarker',
                                markerOptions = markerOptions(fillColor = layer$fill_color, color = layer$color,
                                                              fillOpacity = 1, opacity = 1, radius = 3),
                                options = featureLayerOptions(where = layer$query, fields = layer$out_fields,
                                                              minZoom = layer$min_zoom, precision = 5),
                                clusterOptions = layer$cluster_opts)   
    }
    
    if(layer$type == 'polygon') {
        leafletProxy('map') %>%
            addEsriFeatureLayer(paste0(layer$service_url, envelope), group = layer$group,
                                pathOptions = pathOptions(fillColor = layer$fill_color, color = layer$color,
                                                          fillOpacity = layer$fill_opacity, opacity = layer$opacity,
                                                          weight = layer$weight),
                                options = featureLayerOptions(where = layer$query, fields = layer$out_fields,
                                                              minZoom = layer$min_zoom, precision = 5)) 
    }
    
    if(layer$type == 'polyline') {
        leafletProxy('map') %>%
            addEsriFeatureLayer(paste0(layer$service_url, envelope), group = layer$group,
                                pathOptions = pathOptions(fillColor = NULL, color = layer$color, fillOpacity = 0,
                                                          opacity = layer$opacity, weight = layer$weight, fill = FALSE),
                                options = featureLayerOptions(where = layer$query, fields = layer$out_fields,
                                                              minZoom = layer$min_zoom, precision = 5)) 
    }
    
    delay(ms = 200, {
        # bind popups and update layer style if applicable
        runjs(paste0("var el  = document.getElementById('map');
                      var map = $(el).data('leaflet-map');
                      var lyr =  map.layerManager.getLayerGroup('", layer$group, "');
                      lyr.bindPopup(function (layer) { return L.Util.template(\"<span style = 'font-weight: bold; font-size: 14px; color: #33acdc;'>",
                      layer$name,"</span><hr style = 'margin-top: 4px; margin-bottom: 4px;'>", layer$table,
                      "\", layer.feature.properties); });",
                      if(!is.null(layer$style)) {
                          paste0("lyr.setStyle(", layer$style, ");")
                      }
        ))
        # update cluster options if applicable
        if(!is.null(layer$cluster_opts)) {
            runjs(paste0("var el  = document.getElementById('map');
                          var map = $(el).data('leaflet-map');
                          var lyr =  map.layerManager.getLayerGroup('", layer$group, "');
                          lyr.eachLayer(function(layer) { layer.cluster.options.iconCreateFunction = ",
                              layer$cluster_icon, ";
                              layer.cluster.options.spiderLegPolylineOptions = {weight: 1, color: '#000000', opacity: 0.2, interactive: false};
                          });
                          lyr.eachLayer(function(layer) { layer.cluster.refreshClusters() });"
            ))
        }
    })
       
}
