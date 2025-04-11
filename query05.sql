/*
  Rate neighborhoods by their bus stop accessibility for wheelchairs.
  Use OpenDataPhilly's neighborhood dataset along with an appropriate dataset
  from the Septa GTFS bus feed. Use the GTFS documentation for help. Use some
  creativity in the metric you devise in rating neighborhoods.
*/
with stops_geog as (
    select
        hoods.mapname,
        count(tst.stop_name) as num_stops,
        sum(case when tst.wheelchair_boarding = 1 then 1 else 0 end) as num_wheelchair_stops,
        public.st_area(public.st_union(public.st_intersection(hoods.geog, public.st_buffer(tst.geog,
            case when tst.wheelchair_boarding = 1 then 225 else 0 end
        ))::public.geometry)::public.geography) / public.st_area(hoods.geog) * 100 as ada_area_pct
    from phl.neighborhoods as hoods
    join septa.bus_stops as tst
        on public.st_intersects(hoods.geog, tst.geog)
    group by hoods.mapname, hoods.geog
)
select
    stops.mapname,
    stops.num_stops,
    stops.num_wheelchair_stops,
    round(stops.num_wheelchair_stops::numeric / stops.num_stops::numeric * 100, 2) as pct_ada_stops,
    round(stops.ada_area_pct::numeric, 2) as pct_ada_area
from stops_geog as stops
order by pct_ada_stops asc
