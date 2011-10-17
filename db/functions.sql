drop function if exists binary_from_uuid;

create function binary_from_uuid(uuid CHAR(36))
  returns binary(16)
  return unhex(replace(uuid, '-', ''));

drop function if exists uuid_from_binary;
delimiter //
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
