/*
  Using the Philadelphia Water Department Stormwater Billing Parcels dataset,
  pair each parcel with its closest bus stop. The final result should give the parcel address,
  bus stop name, and distance apart in meters, rounded to two decimals.
  Order by distance (largest on top).
*/

with parcel_bus_dist as(
    select 
        parcels.parcel_address as parcel_address,
        parcels.geog
    from phl.pwd_parcels as pwd
    inner join septa.bus_stops
)


with septa_bus_stop_blockgroups as (
    select
        stops.stop_id,
        '1500000US' || bg.geoid as geoid
    from septa.bus_stops as stops
    inner join census.blockgroups_2020 as bg
        on public.st_dwithin(stops.geog, bg.geog, 800)
    where bg.geoid like '42101%'
),
select * from phl.pwd_parcels limit 5