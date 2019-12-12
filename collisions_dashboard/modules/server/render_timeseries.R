render_timeseries = function(data) {
    circle = "<g><circle cx='4' cy='4' r='4'></circle><circle cx='4' cy='4' r='3' style='fill:#fff'></circle></g>"
    renderBillboarder({
        billboarder() %>% bb_linechart(data = data, show_point = TRUE) %>%
            bb_point(type = circle) %>%
            bb_x_axis(tick = list(format = '%Y-%m-%d', fit = TRUE, culling = TRUE, width = 80),
                      label = list(text = 'Date', position = 'outer-right')) %>%
            bb_color(palette = '#008cba')
    })
}
