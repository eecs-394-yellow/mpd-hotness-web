drop table if exists places;
create table places (
    place_id char(40) not null,
    location Point not null,
    primary key(place_id)
);

drop table if exists ratings;
create table ratings (
    rating_id int not null auto_increment,
    place_id char(40) not null,
    rating tinyint not null,
    time datetime not null,
    primary key(rating_id),
    foreign key(place_id) references places
);
