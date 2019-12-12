library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(stringr)
library(sf)

f_name = '~/Downloads/Collisions.csv'

x = read_csv(f_name)

x = select(x, INCDATE, LOCATION, COLLISIONTYPE, SEVERITYDESC, PEDCOUNT, PEDCYLCOUNT, VEHCOUNT,
           INATTENTIONIND, UNDERINFL, SPEEDING, WEATHER, ROADCOND, LIGHTCOND, SDOT_COLDESC, X, Y)

x$PEDCOUNT[str_detect(x$SDOT_COLDESC, 'PEDESTRIAN')] = 1
x$PEDCYLCOUNT[str_detect(x$SDOT_COLDESC, 'PEDALCYCLIST')] = 1

x = x %>% mutate(DISTRACTED = case_when(INATTENTIONIND == 'Y' ~ 1,
                                        is.na(INATTENTIONIND) ~ 0),
                 UNDER_THE_INFLUENCE = case_when(UNDERINFL %in% c(1, 'Y') ~ 1,
                                                 UNDERINFL %in% c(0, 'N') ~ 0,
                                                 is.na(UNDERINFL) ~ 0),
                 SPEEDING = case_when(SPEEDING == 'Y' ~ 1,
                                      is.na(SPEEDING) ~ 0),
                 INCLEMENT_WEATHER = case_when(WEATHER %in% c('Blowing Sand or Dirt or Snow',
                                                              'Fog/Smog/Smoke', 'Other', 'Raining',
                                                              'Severe Crosswind',
                                                              'Sleet/Hail/Freezing Rain',
                                                              'Snowing') ~ 1,
                                               is.na(WEATHER) ~ 0),
                 INCLEMENT_WEATHER = replace_na(INCLEMENT_WEATHER, 0),
                 HAZARDOUS_ROAD_CONDITIONS = case_when(ROADCOND %in% c('Ice', 'Oil', 'Other',
                                                                       'Sand/Mud/Dirt',
                                                                       'Snow/Slush',
                                                                       'Standing Water',
                                                                       'Wet') ~ 1),
                 HAZARDOUS_ROAD_CONDITIONS = replace_na(HAZARDOUS_ROAD_CONDITIONS, 0),
                 LOW_LIGHT = case_when(LIGHTCOND %in% c('Dark - No Street Lights',
                                                        'Dark - Street Lights Off',
                                                        'Dark - Street Lights On', 'Dawn', 'Dusk',
                                                        'Other') ~ 1,
                                       is.na(LIGHTCOND) ~ 0),
                 LOW_LIGHT = replace_na(LOW_LIGHT, 0),
                 NONE = case_when(DISTRACTED == 0 & UNDER_THE_INFLUENCE == 0 & SPEEDING == 0 & 
                                  INCLEMENT_WEATHER == 0 & HAZARDOUS_ROAD_CONDITIONS == 0 & 
                                  LOW_LIGHT == 0 ~ 1),
                 NONE = replace_na(NONE, 0),
                 VEHICLE_ONLY = case_when(PEDCOUNT == 0 & PEDCYLCOUNT == 0 ~ 1,
                                          PEDCOUNT > 0 | PEDCYLCOUNT > 0 ~ 0),
                 PEDESTRIAN_INVOLVED = case_when(PEDCOUNT > 0 ~ 1,
                                                 PEDCOUNT == 0 ~ 0),
                 CYCLIST_INVOLVED = case_when(PEDCYLCOUNT > 0 ~ 1,
                                              PEDCYLCOUNT == 0 ~ 0),
                 MODE = case_when(VEHICLE_ONLY == 1 ~ 'Vehicle Only',
                                  CYCLIST_INVOLVED == 1 & PEDESTRIAN_INVOLVED == 0 ~ 'Cyclist',
                                  PEDESTRIAN_INVOLVED == 1 ~ 'Pedestrian'))

x = select(x, INCDATE, LOCATION, SEVERITY = SEVERITYDESC, MODE, DISTRACTED, UNDER_THE_INFLUENCE,
           SPEEDING, INCLEMENT_WEATHER, HAZARDOUS_ROAD_CONDITIONS,  LOW_LIGHT, NONE, VEHICLE_ONLY,
           PEDESTRIAN_INVOLVED, CYCLIST_INVOLVED, X, Y) %>%
    mutate(INCDATE = ymd(INCDATE), INCWEEK = floor_date(INCDATE, unit = 'week'),
           INCMONTH = floor_date(INCDATE, unit = 'month'),
           INCQUAR = floor_date(INCDATE, unit = 'quarter'),
           INCYEAR = floor_date(INCDATE, unit = 'year'),
           ID = 1:nrow(x))

y = st_as_sf(filter(x, !is.na(X), !is.na(Y)), coords = c('X', 'Y'), crs = 4326)

save(x, file = 'collisions.Rdata')
save(y, file = 'geo.Rdata')
