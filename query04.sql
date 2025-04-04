-- Active: 1738783914188@@localhost@5432@assignment02
/*
  Using the bus_shapes, bus_routes, and bus_trips tables from GTFS bus feed,
  find the two routes with the longest trips.
*/
select * from septa.bus_shapes;
select * from septa.bus_routes;
select * from septa.bus_trips;

select shape_id, public.st_makeline(array_agg(
  public.st_setsrid(public.st_makepoint(shape_pt_lon, shape_pt_lat),4326) order by shape_pt_sequence))
from septa.bus_shapes
group by shape_id
limit 5

with route_shape as (
    select
        shapes.shape_id,
        public.st_makeline(array_agg( public.st_setsrid(public.st_makepoint(shapes.shape_pt_lon,
        shapes.shape_pt_lat),4326) order by shapes.shape_pt_sequence)) as line_geog
    from septa.bus_shapes as shapes 
    group by shape_id
    limit 5
)
select
    route_shape.shape_id,
    public.st_length(route_shape.line_geog) as shape_length,
    route_shape.line_geog,
    trips.trip_headsign,
    trips.route_id
from route_shape
    join septa.bus_trips as trips on route_shape.shape_id = trips.shape_id
limit 5
    
with route_shape as (
    select
        shapes.shape_id,
        public.st_makeline(array_agg( public.st_setsrid(public.st_makepoint(shapes.shape_pt_lon,
        shapes.shape_pt_lat),4326) order by shapes.shape_pt_sequence)) as line_geog,
        trips.trip_headsign,
        trips.route_id
    from septa.bus_shapes as shapes
        join septa.bus_trips as trips on shapes.shape_id = trips.shape_id
    group by shapes.shape_id, trips.trip_headsign, trips.route_id
)
select
    routes.route_short_name,
    route_shape.trip_headsign,
    round(cast(public.st_length(route_shape.line_geog) as numeric)) as shape_length,
    route_shape.line_geog
from route_shape
    join septa.bus_routes as routes on route_shape.route_id = routes.route_short_name
order by shape_length desc
limit 20
