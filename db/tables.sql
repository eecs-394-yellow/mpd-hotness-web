-- Create and initialize the Note table
drop table if exists Notes;

create table Notes (
    note_id int not null auto_increment primary key,
    -- device UUID
    device_id binary(16) not null,
    -- username (not really verified)
    user_name varchar(32) not null,
    -- posting time
    time datetime not null,
    -- user's description of their location
    location_description varchar(255) null,
    -- user's location in GPS coordinates
    gps Point not null,
    -- text of user's note
    note_text varchar(255) not null
);

drop view if exists ViewNotes;
create view ViewNotes as
    select note_id,
           uuid_from_binary(device_id) as device_id,
           user_name,
           time,
           location_description,
           AsText(gps) as gps,
           note_text
    from Notes;
