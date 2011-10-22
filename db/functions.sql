drop function if exists binary_from_uuid;

-- gives a binary representation of a uuid for storage
create function binary_from_uuid(uuid CHAR(36))
  returns binary(16)
  return unhex(replace(uuid, '-', ''));

drop function if exists uuid_from_binary;
delimiter //
-- gives a string representation of a uuid
create function uuid_from_binary(uuid_bin binary(16))
returns char(36)
begin
    set @uuid = hex(uuid_bin);
    return concat_ws('-', substring(@uuid from 1 for 8),
                          substring(@uuid from 9 for 4),
                          substring(@uuid from 13 for 4),
                          substring(@uuid from 17 for 4),
                          substring(@uuid from 21 for 12));
end//
delimiter ;

delimiter //
drop function if exists haversine //

-- haversine calculates distance between gps coordinates
create function haversine(a Point, b Point)
returns decimal(30, 15)
deterministic
begin
    declare radius decimal(30, 15);
    declare lat1 decimal(30, 15);
    declare lat2 decimal(30, 15);
    declare lon1 decimal(30, 15);
    declare lon2 decimal(30, 15);
    set radius = 3963.1676;
    set lat1 = radians(x(a)), lat2 = radians(x(b)), lon1 = radians(y(a)), lon2 = radians(y(b));
    return radius * ACOS(COS(lat1) * COS(lat2) * COS(lon1 - lon2) + SIN(lat1) * SIN(lat2));
end //
delimiter ;
