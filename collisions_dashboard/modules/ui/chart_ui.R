#' chart_ui
#' 
#' Chart card with title, description and output chart
#' 
#' @param col
#' @param title
#' @param description
#' @param chart
#' 
#' @return HTML

chart_ui = function(col, title, description, chart) {
    column(col, style = 'padding: 0; height: 50%;',
        div(id = 'card',
            div(id = 'content', style = 'padding: 2px 10px 20px 10px;',
                h4(title, style = 'color: #333333;'),
                p(description, style = 'font-weight: 400; color: #607d8b;'),
                chart
            )
        )
    )  
}
