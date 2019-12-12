#' action_button_css
#' 
#' CSS for formatting an action button
#' 
#' @return character

action_button_css = function() {
    return(paste0('border-radius: 0; ',
                  'box-shadow: 0 8px 10px 1px rgba(0,0,0,0.14), 0 3px 14px 2px rgba(0,0,0,0.12), 0 5px 5px -3px rgba(0,0,0,0.3); ',
                  'background: #008cba; border-color: #008cba; ',
                  'color: white;'))
}
