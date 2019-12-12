render_donut = function(data) {
    renderBillboarder({
        billboarder() %>% bb_donutchart(data = data, label = list(threshold = 0.10))
    })
}
