drop procedure if exists usp_rate_place;
delimiter //
create procedure usp_rate_place(place_id char(36), rating tinyint, location Point)
begin
    if (select count(*) from places where place_name = place_id) = 0 then
        insert into places(place_name, location)
        values (place_id, location);
    end if;
    
    insert into ratings(place_name, time, rating)
    values (place_id, now(), rating);
end//

drop procedure if exists usp_get_places//

create procedure usp_get_places(loc Point)
begin
    select place_name place_uuid, X(p.location) lat, Y(p.location) lon, haversine(loc, location) distance, avg(rating) rating from places p
    left join ratings r using(place_name)
    group by place_name
    order by distance asc;
end//
