#' custom_legend
#' 
#' Create a custom legend for a map layer.
#' 
#' @param fill_colors vector of colors
#' @param border_colors vector of border colors
#' @param labels labels for each color
#' @param sizes size of symbols in pixels
#' @param shapes shape on legend, either cirlce or square
#' 
#' @return HTML

custom_legend = function(title, fill_colors, border_colors, labels, size, shapes) {
    
    if(shapes %in% c('square', 'circle')) {
        make_shapes = function(fill_colors, border_colors, size, shapes) {
            shapes = str_replace_all(shapes, 'circle', '50%') %>% str_replace_all('square', '0%')
            paste0(fill_colors, '; width: ', size, 'px; height: ', size, 'px; border: 3px solid ', border_colors,
                   '; border-radius: ', shapes)
        }
    } else {
        make_shapes = function(fill_colors, border_colors, size, shapes) {
            shapes = str_replace_all(shapes, 'circle', '50%') %>% str_replace_all('square', '0%')
            paste0(fill_colors, '; width: ', size, 'px; height: ', 1, 'px; border: 2px solid ', border_colors,
                   '; border-radius: 0%; margin-top: 8px;')
        }
    }
    
    make_labels = function(size, labels) {
        paste0("<div style = 'display: inline-block; height: ", size, 'px; margin-top: 4px; line-height: ',
               size - 8, "px;'>", labels, '</div>')
    }
    
    create_div = function(title, legend_colors, legend_labels) {
        if(is.null(title)) {
            div(id = 'legend', class = 'info legend',
                HTML(paste0('<i style="background: ', legend_colors, '"></i> ', legend_labels, '<br>'))
            )
        } else {
            div(id = 'legend', class = 'info legend',
                span(title, style = 'font-weight: bold; font-size: 14px; color: #33acdc;'),
                br(),
                HTML(paste0('<i style="background: ', legend_colors, '"></i> ', legend_labels, '<br>'))
            )   
        }
    }
    
    legend_colors = make_shapes(fill_colors, border_colors, size, shapes)
    legend_labels = make_labels(size, labels)
    
    create_div(title, legend_colors, legend_labels)
    
}
