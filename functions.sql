drop function binary_from_uuid;

create function binary_from_uuid(uuid CHAR(36))
  returns binary(16)
  return unhex(replace(uuid, '-', ''));

drop function uuid_from_binary;
delimiter //
create function uuid_from_binary(uuid_bin binary(16))
returns char(36)
begin
    set @uuid = hex(uuid_bin);
    return concat_ws('-', substring(@uuid from 0 for 8), 
                         substring(@uuid from 8 for 4), 
                         substring(@uuid from 12 for 4), 
                         substring(@uuid from 16 for 4),
                         substring(@uuid from 20 for 12));
end//
delimiter ;