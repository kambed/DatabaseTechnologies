create table product
(
    id          bigint auto_increment
        primary key,
    name        varchar(140) not null,
    department  varchar(50)  not null,
    description varchar(500) null,
    components  varchar(500) null,
    scopes      varchar(500) null
);

create table audit_year_part
(
    id         bigint auto_increment
        primary key,
    name       varchar(50) not null,
    start_date date        not null,
    end_date   date        not null,
    is_closed  tinyint(1) default false
);

create table user
(
    id       bigint auto_increment
        primary key,
    name     varchar(200) not null,
    is_admin tinyint(1) default false
);

create table product_audit
(
    id                 bigint auto_increment
        primary key,
    audit_year_part_id bigint not null,
    status             varchar(30) null,
    date_of_audit      date null,
    result             float null,
    product_id         bigint not null,
    user_id            bigint not null,
    components         varchar(500) null,
    scopes             varchar(500) null,
    constraint Audit_AuditYearPart_null_fk
        foreign key (audit_year_part_id) references audit_year_part (id)
            ON DELETE CASCADE,
    constraint Audit_Product_null_fk
        foreign key (product_id) references product (id)
            ON DELETE CASCADE
    constraint Audit_User_null_fk
        foreign key (user_id) references user (id)
            ON DELETE CASCADE
);

create table product_team_member
(
    id         bigint auto_increment
        primary key,
    user_id    bigint      not null,
    product_id bigint      not null,
    type       varchar(50) not null,
    constraint AuditTeamMembers_Product_null_fk
        foreign key (product_id) references product (id)
            ON DELETE CASCADE,
    constraint AuditTeamMembers_User_Product_null_fk
        foreign key (user_id) references user (id)
            ON DELETE CASCADE
);