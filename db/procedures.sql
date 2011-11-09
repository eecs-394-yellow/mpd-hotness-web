drop procedure if exists usp_rate_place;
delimiter //
create procedure usp_rate_place(place_id_ char(40), rating_ tinyint, location_ Point)
begin
    if (select count(*) from places where place_id = place_id_) = 0 then
        insert into places(place_id, location)
        values (place_id_, location_);
    end if;
    
    insert into ratings(place_id, time, rating)
    values (place_id_, now(), rating_);
end//

drop procedure if exists usp_get_places//

create procedure usp_get_places(loc Point)
begin
    select place_id, X(p.location) lat, Y(p.location) lon, haversine(loc, location) distance, avg(rating) rating from places p
    left join ratings r using(place_id)
    group by place_id
    order by distance asc;
end//
