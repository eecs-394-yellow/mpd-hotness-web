drop table if exists places;
create table places (
    place_name varchar(32) not null,
    location Point not null,
    primary key(place_name)
);

drop table if exists ratings;
create table ratings (
    place_name varchar(32) not null,
    rating tinyint not null,
    time datetime not null,
    foreign key(place_name) references places
);
