#' format_kable
#' 
#' Format an HTML table for leaflet popup.
#' 
#' @param field_names
#' @param field_aliases
#' 
#' @return HTML

format_kable = function(field_names, field_aliases) {
    field_names = paste0('{', field_names, '}')
    df          = data.frame('Attribute' = field_aliases, 'Value' = field_names)
    kable(df) %>%
        kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
        column_spec(1, width_min = '150px', bold = TRUE, include_thead = TRUE) %>%
        column_spec(2, width_min = '150px', include_thead = TRUE) %>% as.character() %>% str_replace_all('\"', "'") %>%
        str_replace_all('\n ', '') %>% str_replace_all('\n', '')
}
