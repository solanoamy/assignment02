copy septa.bus_stops (
    stop_id,
    stop_name,
    stop_lat,
    stop_lon,
    location_type,
    parent_station,
    zone_id,
    wheelchair_boarding
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/gtfs_public/google_bus/stops.txt'
with (format csv, header true, delimiter ',');

copy septa.bus_routes (
    route_id,
    route_short_name,
    route_long_name,
    route_type,
    route_color,
    route_text_color,
    route_url
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/gtfs_public/google_bus/routes.txt'
with (format csv, header true, delimiter ',');

copy septa.bus_trips (
    route_id,
    service_id,
    trip_id,
    trip_headsign,
    block_id,
    direction_id,
    shape_id
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/gtfs_public/google_bus/trips.txt'
with (format csv, header true, delimiter ',');

copy septa.bus_shapes (
    shape_id,
    shape_pt_lat,
    shape_pt_lon,
    shape_pt_sequence
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/gtfs_public/google_bus/shapes.txt'
with (format csv, header true, delimiter ',');

copy septa.rail_stops (
    stop_id,
    stop_name,
    stop_desc,
    stop_lat,
    stop_lon,
    zone_id,
    stop_url
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/gtfs_public/google_rail/stops.txt'
with (format csv, header true, delimiter ',');

copy census.population_2020 (
    geoid,
    geoname,
    total
)
from '/Users/amysolano/Documents/GitHub/assignment02/data/DECENNIALPL2020.P1_2025-03-31T194026/DECENNIALPL2020.P1-Data.csv'
with (format csv, header true, delimiter ',');
