drop view if exists place_summaries;
create view place_summaries as
    select place_name place_uuid, avg(r.rating) rating,
           X(location) lat, Y(location) lon
    from places p
    inner join ratings r using(place_name)
    group by p.place_name;
