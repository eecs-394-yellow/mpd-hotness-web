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

create procedure usp_get_places(loc Point, rating_age_minutes int, max_distance int)
begin
    select place_id, X(p.location) lat, Y(p.location) lon, 
           haversine(loc, location) distance, rating, ifnull(rating_count, 0) rating_count  
    from places p
    left join (select place_id, avg(rating) rating, count(rating) rating_count
               from ratings 
               where ratings.time > date_sub(now(), interval rating_age_minutes minute)
               group by place_id) ratings_sq using(place_id)
    having distance <= max_distance
    order by distance asc;
end//

drop procedure if exists usp_get_place//

create procedure usp_get_place(place_id_ char(40), max_age_minutes int)
begin
    select avg(rating) rating, count(rating) rating_count
    from ratings
    where ratings.time > date_sub(now(), interval max_age_minutes minute)
    and place_id = place_id_;
end//
