drop procedure if exists usp_insert_note;
delimiter //
create procedure usp_insert_note(deviceId CHAR(36), author VARCHAR(32), location VARCHAR(255), notes VARCHAR(255))
begin
    insert into Note(device_id, user_name, time, location_description, note_text)
                values(deviceId, author, NOW(), location, notes);
end//
