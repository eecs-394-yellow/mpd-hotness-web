drop procedure if exists usp_rate_place;
delimiter //
create procedure usp_rate_place(place_id char(36), rating tinyint, location VARCHAR(32))
begin
    if (select count(*) from places where place_name = place_id) = 0 then
        insert into places(place_name, location)
        values (place_id, geomFromText(location));
    end if;
    
    insert into ratings(place_name, time, rating)
    values (place_id, now(), rating);
end//
