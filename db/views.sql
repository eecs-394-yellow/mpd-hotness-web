drop view if exists place_summaries;
create view place_summaries as
    select place_id, avg(r.rating) rating,
           X(location) lat, Y(location) lon
    from places p
    left outer join ratings r using(place_id)
    group by p.place_id;
