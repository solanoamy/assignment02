/*
  Using the Philadelphia Water Department Stormwater Billing Parcels dataset,
  pair each parcel with its closest bus stop. The final result should give the parcel address,
  bus stop name, and distance apart in meters, rounded to two decimals.
  Order by distance (largest on top).
*/

select
    parcels.address as parcel_address,
    stops.stop_name as bus_stop,
    round(cast(stops.dist as numeric), 2)
from phl.pwd_parcels as parcels
cross join lateral (
    select
        stops.stop_name,
        stops.geog operator(public.<->) parcels.geog as dist
    from septa.bus_stops as stops
    order by dist
    limit 1
) as stops
order by stops.dist desc
