/*
    What are the top five neighborhoods according to your accessibility metric?
*/
with stops_geog as (
    select
        hoods.mapname,
        sum(case when tst.wheelchair_boarding = 1 then 1 else 0 end)::integer as num_wheelchair_stops,
        sum(case when tst.wheelchair_boarding = 0 then 1 else 0 end)::integer as num_inaccessible,
        public.st_area(public.st_union(public.st_intersection(hoods.geog, public.st_buffer(tst.geog,
            case when tst.wheelchair_boarding = 1 then 225 else 0 end
        ))::public.geometry)::public.geography) / public.st_area(hoods.geog) * 100 as ada_area_pct
    from phl.neighborhoods as hoods
    join septa.bus_stops as tst
        on public.st_intersects(hoods.geog, tst.geog)
    group by hoods.mapname, hoods.geog
)
select
    stops.mapname as neighborhood_name,
    round(stops.ada_area_pct::numeric, 2) as pct_ada_area,
    stops.num_wheelchair_stops as num_bus_stops_accessible,
    stops.num_inaccessible as num_bus_stops_inaccessible
from stops_geog as stops
order by pct_ada_area desc
limit 5
