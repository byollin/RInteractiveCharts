render_barchart = function(data) {
    circle = "<g><circle cx='4' cy='4' r='4'></circle><circle cx='4' cy='4' r='3' style='fill:#fff'></circle></g>"
    renderBillboarder({
        billboarder() %>% bb_barchart(data = data, stacked = TRUE) %>%
            bb_x_axis(tick = list(fit = TRUE, culling = list(max = 6), width = 80),
                      label = list(text = 'Date', position = 'outer-right')) %>%
            bb_color(palette = c('#E68310', '#7F3C8D', '#11A579'))
    })
}
