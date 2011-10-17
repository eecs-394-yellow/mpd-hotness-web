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
    return concat_ws('-', substring(@uuid, 0, 8), 
                         substring(@uuid, 8, 12), 
                         substring(@uuid, 12, 16), 
                         substring(@uuid, 16, 22));
end//
delimiter ;
