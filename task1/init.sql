USE master;
GO
CREATE DATABASE product_audit_db;
GO
USE product_audit_db;
GO

CREATE TABLE audit_year_part
(
    id         bigint IDENTITY(1,1) PRIMARY KEY,
    name       varchar(50) NOT NULL,
    start_date date        NOT NULL,
    end_date   date        NULL,
    is_closed  bit default 0
);
GO

INSERT INTO audit_year_part (name, start_date, end_date, is_closed) VALUES
('2022H1', '2022-02-01', '2022-02-07', 1),
('2022H2', '2022-08-22', '2022-08-25', 1),
('2023H1', '2023-04-05', '2023-04-06', 1),
('2023H2', '2023-10-10', NULL, 0);
GO

CREATE TABLE product
(
    id          bigint IDENTITY(1,1) PRIMARY KEY,
    name        varchar(140) NOT NULL,
    department  varchar(50)  NOT NULL,
    description varchar(500) NULL,
    components  varchar(500) NULL
);
GO

INSERT INTO product (name, department, description, components) VALUES
('Better mobile app', 'Mobile', 'A better mobile app', 'Frontend, Mobile'),
('Better React app', 'Frontend', 'A better website', 'Frontend, Backend'),
('Better Spring API', 'Backend', 'A better API', 'Backend'),
('Better AI Python API', 'Backend', 'A better AI API', 'Backend'),
('Better MySQL', 'Backend', 'A better database', 'Backend, Database');
GO

CREATE TABLE [user]
(
    id       bigint IDENTITY(1,1) PRIMARY KEY,
    nickname     varchar(200) NOT NULL,
    email        varchar(200) NULL,
    firstname     varchar(200) NULL,
    lastname     varchar(200) NULL,
    is_admin bit default 0,
    is_active bit default 1
    );
GO

INSERT INTO [user] (nickname, email, firstname, lastname, is_admin, is_active) VALUES
('ecoljohn', 'john.colors@gmail.com', 'John', 'Colors', 0, 1),
('ecarjan', 'jane.cargo200@gmail.com', 'Jane', 'Cargo', 0, 0),
('ekowemi', 'qwerty@wp.pl', 'Emil', 'Kowalski', 1, 1);
GO

CREATE TABLE product_team_member
(
    id         bigint IDENTITY(1,1) PRIMARY KEY,
    user_id    bigint NOT NULL,
    product_id bigint NOT NULL,
    type       varchar(50) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user] (id) ON DELETE CASCADE
);
GO

INSERT INTO product_team_member (user_id, product_id, type) VALUES
(1, 1, 'Developer'),
(1, 3, 'Developer'),
(2, 1, 'Tester'),
(3, 2, 'OPO'),
(3, 2, 'Scrum master'),
(3, 2, 'Developer'),
(3, 2, 'Tester');
GO

CREATE TABLE product_audit
(
    id                 bigint IDENTITY(1,1) PRIMARY KEY,
    product_id         bigint NOT NULL,
    audit_year_part_id bigint NOT NULL,
    audit_date         date NULL,
    audit_score        int NULL,
    audit_comment      varchar(500) NULL,
    user_id            bigint NOT NULL,
    FOREIGN KEY (audit_year_part_id) REFERENCES audit_year_part (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user] (id) ON DELETE CASCADE
);
GO

INSERT INTO product_audit (product_id, audit_year_part_id, audit_date, audit_score, audit_comment, user_id) VALUES
(1, 1, '2022-02-01', 4, 'Good job!', 1),
(1, 2, '2022-10-02', 5, 'Great job!', 2),
(2, 2, '2022-10-20', 3, 'Wrong security!', 1),
(2, 3, '2023-04-05', 4, 'Good job!', 1),
(2, 4, '2023-12-10', 5, 'Great job!', 2),
(3, 2, '2022-10-20', 2, 'Not good!!!', 1),
(3, 4, '2023-12-09', 5, 'Great job!', 2),
(4, 2, '2022-10-20', 1, '???', 1);
GO