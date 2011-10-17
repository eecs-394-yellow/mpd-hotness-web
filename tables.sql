-- Create and initialize the Note table
drop table if exists Note;

create table Note (
    -- device UUID
    device_id varbinary(16) not null,
    -- username (not really verified)
    user_name varchar(32) not null,
    -- posting time
    time datetime not null,
    -- user's description of their location
    location_description varchar(255) not null,
    -- text of user's note
    note_text varchar(255) not null,
    primary key(device_id, time)
);