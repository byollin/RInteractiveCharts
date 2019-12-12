#' input_ui
#' 
#' UI wrapper for input elements.
#' 
#' @param input_id Shiny input id of the input element
#' @param input_element input element
#' @param help text to display in help popup
#' 
#' @return HTML

input_ui = function(input_id, input_element, help) {
    div(style = inline_block_css(),
        column(12, style = 'padding-left: 0;',
            input_element,
            absolutePanel(top = 0, right = 15,
                div(style = 'font-size: 10pt;',
                    actionLink(paste0(input_id, '_help'), NULL, icon = icon('question-circle-o', lib = 'font-awesome')),
                    bsPopover(paste0(input_id, '_help'), placement = 'right', trigger = 'hover', title = NULL, content = help,
                              options = list(container = 'body'))
                )
            )
        )
    )
}
