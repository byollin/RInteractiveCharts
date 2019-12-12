#' layer_ui
#' 
#' Generate the UI elements of a layer. This includes a toggle switch, an opacity slider, a "zoom to layer" button, a
#' a data source button connecting to an external link.
#' 
#' @param layer layer name to include in UI element ID
#' @param layer_label layer label
#' @param on default visibility, TRUE or FALSE
#' @param opacity default opacity, a number between 0 and 100
#' @param up sets the direction in which the popup menu will be oriented
#' 
#' @return HTML

layer_ui = function(layer, layer_label, on = FALSE, opacity = 40, up = FALSE) {
    div(
        div(style = inline_block_css(),
            column(11, style = 'padding-left: 0',
                div(id = paste0('div_', layer),
                    prettyCheckbox(inputId = paste0('toggle_', layer), label = layer_label, value = on, bigger = TRUE,
                                   fill = TRUE, status = 'primary')
                )
            ),
            column(1, style = 'padding-left: 0; margin-top: -5px;',
                br(),
                dropdownButton(icon = icon('ellipsis-h', lib = 'font-awesome'), size = 'xs', up = up, right = TRUE,
                    br(),
                    sliderInput(paste0('opacity_', layer), label = 'Layer opacity:', min = 0, max = 100, ticks = FALSE,
                                step = 5, value = opacity),
                    div(style = 'margin-bottom: 10px;',
                        actionLink(paste0('source_', layer), label = ' Data source', icon = icon('external-link'),
                                   onclick = paste0("window.open('", feature_services[[layer]]$data_url,
                                                    "', '_blank')"))
                    )
                )
            )
        ),
        div(id = paste0('legend_', layer), feature_services[[layer]]$legend) %>% hidden()
    )
}
