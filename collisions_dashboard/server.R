shinyServer(function(input, output, session) {
    
    load('data/collisions.Rdata')
    load('data/geo.Rdata')
    
    collisions_js =  JS(read_file('www/collisions.js'))
    
    # animate icons for collapsible layer panels
    runjs("$('.panel-collapse').on('show.bs.collapse', function () {
               $(this).siblings('.panel-heading').addClass('active');
           });
           $('.panel-collapse').on('hide.bs.collapse', function () {
               $(this).siblings('.panel-heading').removeClass('active');
           });")
    
    # load default map #############################################################################
    
    shinyjs::show('spinner')
    
    output$map = renderLeaflet({
        leaflet::leaflet(options = leafletOptions(minZoom = 9, maxZoom = 18, zoomControl = FALSE)) %>%
            addTiles(urlTemplate = paste0('https://api.mapbox.com/styles/v1/byollin/cjtgfplhk000c1frqfylhjqnw/tiles/',
                                          '256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYnlvbGxpbiIsImEiOiJjanNleDR0enAx',
                                          'OXZ5NDRvYXMzYWFzejA2In0.GGB4yI6z0leM1_BwGEYfiQ'),
                     attribution = '<a href="https://carto.com/attribution/" title="CARTO">CARTO ©</a> | \
                                    Map data provided by <a href="https://www.openstreetmap.org/copyright" \
                                    title="OpenStreetMap Contributors">OpenStreetMap © Contributors</a>') %>%
            setView(lng = -122.32838630676271, lat = 47.61269460166813, zoom = 16)
    })
    
    delay(ms = 200, { shinyjs::hide('spinner') })
    
    # update #######################################################################################
    
    waitress = call_waitress("#card")
    
    observe({
        
        waitress$start()
        
        # filter
        collisions = x %>% filter(INCDATE >= as.Date(input$date[1]), INCDATE <= as.Date(input$date[2]))
        if(length(input$severity) > 0) {
            collisions = collisions %>% filter(SEVERITY %in% input$severity)
        }
        if(length(input$circumstances) > 0) {
            collisions = collisions %>% filter_at(vars(input$circumstances), any_vars(. == 1))
        }
        if(length(input$involving) > 0) {
            collisions = collisions %>% filter_at(vars(input$involving), any_vars(. == 1))
        }
        
        # 
        by_date = collisions %>% group_by(!!sym(input$agg)) %>% summarise(Collisions = n())
        
        by_mode = collisions %>% group_by(!!sym(input$agg), MODE) %>% summarise(Collisions = n())
        by_mode = dcast(by_mode, get(input$agg)~MODE, value.var = 'Collisions')
        
        by_severity = collisions %>% group_by(!!sym(input$agg), SEVERITY) %>% summarise(Collisions = n())
        by_severity = by_severity %>% group_by(SEVERITY) %>% summarise(Collisions = sum(Collisions))
        
        by_intersection = collisions %>% filter(!is.na(LOCATION)) %>% group_by(LOCATION) %>% summarise(Collisions = n()) %>% arrange(desc(Collisions)) %>% top_n(10, Collisions)
        
        # charts
        
        output$ts_collisions = render_timeseries(by_date)
        
        agg_name = switch(input$agg, 'INCDATE' = 'day', 'INCWEEK' = 'week', 'INCMONTH' = 'month', 'INCQUAR' = 'quarter', 'INCYEAR' = 'year')
        
        output$ts_collisions_desc = renderText({
            paste0('Total collisions by ', agg_name)
        })
    
        output$ts_mode = render_barchart(by_mode)
        
        output$ts_mode_desc = renderText({
            paste0('Total collisions by road user by ', agg_name)
        })
    
        output$donut_severity = render_donut(by_severity)
    
        output$table_intersections = render_table(by_intersection)
        
        # metrics
        output$total_collisions = renderText({
            formatC(sum(by_date$Collisions), digits = 0, big.mark = ',')
        })
        output$total_collisions_desc = renderText({
            paste0('Total collisions between ', input$date[1], ' and ', input$date[2])
        })
        output$injuries = renderText({
            injuries = filter(by_severity, SEVERITY %in% c('Injury Collision'))
            formatC(sum(injuries$Collisions), digits = 0, big.mark = ',')
        })
        output$injuries_desc = renderText({
            paste0('Injuries related to collisions occuring between ', input$date[1], ' and ', input$date[2])
        })
        output$serious_injuries = renderText({
            serious_injuries = filter(by_severity, SEVERITY %in% c('Serious Injury Collision'))
            formatC(sum(serious_injuries$Collisions), digits = 0, big.mark = ',')
        })
        output$serious_injuries_desc = renderText({
            paste0('Serious injuries related to collisions occuring between ', input$date[1], ' and ', input$date[2])
        })
        output$fatalities = renderText({
            fatalities = filter(by_severity, SEVERITY %in% c('Fatality Collision'))
            formatC(sum(fatalities$Collisions), digits = 0, big.mark = ',')
        })
        output$fatalities_desc = renderText({
            paste0('Fatalities due to collisions occuring between ', input$date[1], ' and ', input$date[2])
        })
        
        # map
        if(input$page == 'Map') {
            shinyjs::show('spinner')
            y = y %>% filter(ID %in% collisions$ID)
            labels = sprintf("<strong>%s</strong><br/><hr style=\"margin-top: 1px; margin-bottom: 1px;\">
                  <table class=\"table table-condensed\" style=\"width: auto !important; margin-left: auto; margin-right: auto;\">
                    <tbody>
                      <tr>
                        <td style=\"text-align:left; font-weight: bold; font-size: x-small; border-color:#ffffff00;\"> Location </td>
                        <td style=\"text-align:right; border-color: #ffffff00; font-size: x-small;\"> %s </td>
                      </tr>
                      <tr>
                        <td style=\"text-align:left; font-weight: bold; font-size: x-small; border-color:#ffffff00;\"> Severity </td>
                        <td style=\"text-align:right; border-color:#ffffff00; font-size: x-small;\"> %s </td>
                      </tr>
                      <tr>
                        <td style=\"text-align:left; font-weight: bold; font-size: x-small; border-color:#ffffff00;\"> Road Users </td>
                        <td style=\"text-align:right; border-color:#ffffff00; font-size: x-small;\"> %s </td>
                      </tr>
                    </tbody>
                </table>", y$INCDATE, y$LOCATION, y$SEVERITY, y$MODE) %>% lapply(htmltools::HTML)
            leafletProxy('map') %>% clearGroup('collisions') %>%
                addCircleMarkers(data = y, group = 'collisions', fillColor = '#ff5c33', color = '#661400',
                                 fillOpacity = 1, opacity = 1, radius = 3, weight = 2, label = labels,
                                 clusterOptions = markerClusterOptions())
            shinyjs::delay(ms = 200, {
                shinyjs::toggle('spinner')
            })
        }
        
        waitress$hide()
        
    })
    
})
