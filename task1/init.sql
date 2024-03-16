USE master;
GO
CREATE DATABASE product_audit_db;
GO
USE product_audit_db;
GO

CREATE TABLE product
(
    id          bigint IDENTITY(1,1) PRIMARY KEY,
    name        varchar(140) NOT NULL,
    department  varchar(50)  NOT NULL,
    description varchar(500) NULL,
    components  varchar(500) NULL,
    scopes      varchar(500) NULL
);

CREATE TABLE audit_year_part
(
    id         bigint IDENTITY(1,1) PRIMARY KEY,
    name       varchar(50) NOT NULL,
    start_date date        NOT NULL,
    end_date   date        NOT NULL,
    is_closed  bit default 0
);

CREATE TABLE [user]
(
    id       bigint IDENTITY(1,1) PRIMARY KEY,
    name     varchar(200) NOT NULL,
    is_admin bit default 0,
    is_active bit default 1
);

CREATE TABLE product_audit
(
    id                 bigint IDENTITY(1,1) PRIMARY KEY,
    audit_year_part_id bigint NOT NULL,
    status             varchar(30) NULL,
    date_of_audit      date NULL,
    result             float NULL,
    product_id         bigint NOT NULL,
    user_id            bigint NOT NULL,
    components         varchar(500) NULL,
    scopes             varchar(500) NULL,
    FOREIGN KEY (audit_year_part_id) REFERENCES audit_year_part (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user] (id) ON DELETE CASCADE
);

CREATE TABLE product_team_member
(
    id         bigint IDENTITY(1,1) PRIMARY KEY,
    user_id    bigint NOT NULL,
    product_id bigint NOT NULL,
    type       varchar(50) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user] (id) ON DELETE CASCADE
);

INSERT INTO product (name, department, description, components, scopes) VALUES
('Product 1', 'Department 1', 'Description 1', 'Components 1', 'Scopes 1'),
('Product 2', 'Department 2', 'Description 2', 'Components 2', 'Scopes 2'),
('Product 3', 'Department 3', 'Description 3', 'Components 3', 'Scopes 3');

INSERT INTO [user] (name, is_admin, is_active) VALUES
('User 1', 1, 1),
('User 2', 0, 1),
('User 3', 0, 1);

INSERT INTO audit_year_part (name, start_date, end_date, is_closed) VALUES
('Audit 1', '2020-01-01', '2020-12-31', 0),
('Audit 2', '2021-01-01', '2021-12-31', 0),
('Audit 3', '2022-01-01', '2022-12-31', 0);

INSERT INTO product_audit (audit_year_part_id, status, date_of_audit, result, product_id, user_id, components, scopes) VALUES
(1, 'Status 1', '2020-01-01', 1.1, 1, 1, 'Components 1', 'Scopes 1'),
(1, 'Status 2', '2020-01-02', 1.2, 2, 1, 'Components 2', 'Scopes 2'),
(1, 'Status 3', '2020-01-03', 1.3, 3, 1, 'Components 3', 'Scopes 3');

INSERT INTO product_team_member (user_id, product_id, type) VALUES
(1, 1, 'Type 1'),
(2, 1, 'Type 2'),
(3, 1, 'Type 3');