#' navbar_page
#' 
#' navbar page wrapper
#' 
#' @param inputs additional HTML elements to put in navbar
#' 
#' @return HTML

navbar_page = function(..., inputs = NULL) {
    navbar = navbarPage(...)
    if(!is.null(inputs)) {
        form = tags$form(class = 'navbar-form', inputs)
        navbar[[3]][[1]]$children[[1]] = htmltools::tagAppendChild(navbar[[3]][[1]]$children[[1]], form) 
    }
    return(navbar)
}
