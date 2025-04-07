/*
  Rate neighborhoods by their bus stop accessibility for wheelchairs.
  Use OpenDataPhilly's neighborhood dataset along with an appropriate dataset
  from the Septa GTFS bus feed. Use the GTFS documentation for help. Use some
  creativity in the metric you devise in rating neighborhoods.
*/
with neighborhood_stops as (
    select
        nhoods.mapname,
        count(stops.stop_name) as num_stops,
        sum(case when stops.wheelchair_boarding = 1 then 1 else 0 end) as num_wheelchair_stops
    from phl.neighborhoods as nhoods
    inner join septa.bus_stops as stops
        on public.st_intersects(nhoods.geog, stops.geog)
    group by nhoods.mapname
)
select *,
    round(num_wheelchair_stops::numeric / num_stops::numeric * 100, 2) as wheelchair_accessibility
from neighborhood_stops
order by wheelchair_accessibility asc


with nh_stops as (
    select
        nhoods.mapname,
        nhoods.geog as nh_geog,
        count(stops.stop_name) as num_stops,
        sum(case when stops.wheelchair_boarding = 1 then 1 else 0 end) as num_wheelchair_stops,
        public.st_buffer(stops.geog, case when stops.wheelchair_boarding = 1 then 400 else 0 end) as ada_buffer
    from phl.neighborhoods as nhoods
    inner join septa.bus_stops as stops
        on public.st_intersects(nhoods.geog, stops.geog)
    group by nhoods.mapname, stops.geog, nhoods.geog, stops.wheelchair_boarding
)
select
    nh_stops.mapname,
    round(nh_stops.num_wheelchair_stops::numeric / nh_stops.num_stops::numeric * 100, 2) as wheelchair_accessibility,
    public.st_area(public.st_intersection(ada_buffer, nh_stops.nh_geog)) / public.st_area(nh_stops.nh_geog) * 100 as ada_area_pct
from nh_stops
order by ada_area_pct desc

with nh_stops as (
    select
        nhoods.mapname,
        count(stops.stop_name) as num_stops,
        sum(case when stops.wheelchair_boarding = 1 then 1 else 0 end) as num_wheelchair_stops
    from phl.neighborhoods as nhoods
    inner join septa.bus_stops as stops
        on public.st_intersects(nhoods.geog, stops.geog)
    group by nhoods.mapname
)
select *,
    round(nh_stops.num_wheelchair_stops::numeric / nh_stops.num_stops::numeric * 100, 2) as wheelchair_accessibility
from nh_stops
order by wheelchair_accessibility desc

with test_union as(
	select
    	public.st_buffer(geog,
			case when wheelchair_boarding = 1 then 400 else 0 end) as ada_buffer
	from septa.bus_stops)
select
	public.st_union(ada_buffer::geometry)::geography as union_var
from test_union

with test_union as(
	select
    	public.st_buffer(geog,
			case when wheelchair_boarding = 1 then 400 else 0 end) as ada_buffer
	from septa.bus_stops)
select
	*
from test_union
