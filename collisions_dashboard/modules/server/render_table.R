render_table = function(data) {
    DT::renderDataTable(server = TRUE, {
        datatable(data, rownames = FALSE, class = c('compact', 'stripe'), width = '100%',
                  style = 'bootstrap', selection = 'none',
                  options = list(dom = 'tlpr', pageLength = 5, ordering = TRUE, scrollY = '200px',
                                 fixedHeader = TRUE, deferRender = TRUE, processing = FALSE))
    })
}
