-- Active: 1738783914188@@localhost@5432@assignment02
/*
  Using the bus_shapes, bus_routes, and bus_trips tables from GTFS bus feed,
  find the two routes with the longest trips.
*/
with route_shape as (
    select
        shapes.shape_id,
        public.st_makeline(array_agg(
            public.st_setsrid(
                public.st_makepoint(
                    shapes.shape_pt_lon, shapes.shape_pt_lat
                ), 4326
            )
            order by shapes.shape_pt_sequence
        )) as shape_geog
    from septa.bus_shapes as shapes
    group by shapes.shape_id
)

select
    trips.route_id as route_short_name,
    trips.trip_headsign,
    route_shape.shape_geog,
    round(public.st_length(route_shape.shape_geog::public.geography)::numeric) as shape_length
from route_shape
left join septa.bus_trips as trips on route_shape.shape_id = trips.shape_id
group by trips.route_id, trips.trip_headsign, route_shape.shape_geog
order by shape_length desc
limit 2
