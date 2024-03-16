create table message
(
    id bigint auto_increment primary key,
    username varchar(256) null,
    message varchar(1024) not null
)