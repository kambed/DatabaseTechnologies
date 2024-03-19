-- Kamil Bednarek 254148
-- Damian Biskupski 254150

USE product_audit_db;

-- Select procedure
-- CREATE PROCEDURE select_Products_By_Name
--     @name NVARCHAR(50)
-- AS
-- BEGIN
--     SELECT * FROM product
--     WHERE name LIKE '%' + @name + '%';
-- END;

EXEC select_Products_By_Name 'Better mobile app'

-- Insert procedure with if statement and exception handling
-- CREATE PROCEDURE insert_Product
--     @name varchar(140),
--     @department varchar(50),
--     @description varchar(500) = NULL,
--     @components varchar(500) = NULL
-- AS
-- BEGIN
--     IF LEN(@name) > 0
--     BEGIN
--         INSERT INTO product (name, department, description, components)
--         VALUES (@name, @department, @description, @components);
--     END
--     ELSE
--     BEGIN
--         Raiserror ('Product name cannot be empty.', 10, 1);
--     END
-- END;

EXEC insert_Product '', 'Backend', 'A better Jenkins instance', 'Backend, DevOps'
EXEC insert_Product 'Better Jenkins', 'Backend', 'A better Jenkins instance', 'Backend, DevOps'
EXEC insert_Product 'Better Jenkins2', 'Backend'
SELECT * FROM product;

-- Insert procedure with if statement and exception handling
-- CREATE PROCEDURE start_audit
--     @productName NVARCHAR(50),
--     @auditDate DATE
-- AS
-- BEGIN
--     DECLARE @productId INT;
--     DECLARE @auditYearPartId INT;
--     DECLARE @auditYearPart VARCHAR(10);
--     SELECT @productId = id FROM product WHERE name = @productName;
--
--     IF @productId IS NOT NULL
--     BEGIN
--         SET @auditYearPart = CAST(YEAR(@auditDate) AS VARCHAR) + 'H' + CASE WHEN MONTH(@auditDate) <= 6 THEN '1' ELSE '2' END;
--         IF NOT EXISTS (SELECT * FROM audit_year_part WHERE name = @auditYearPart)
--         BEGIN
--             IF MONTH(@auditDate) <= 6
--             BEGIN
--                 INSERT INTO audit_year_part (name, start_date, end_date)
--                 VALUES (@auditYearPart, CAST(YEAR(@auditDate) AS VARCHAR(4)) + '-01-01', CAST(YEAR(@auditDate) AS VARCHAR(4)) + '-06-30');
--             END
--             ELSE
--             BEGIN
--                 INSERT INTO audit_year_part (name, start_date, end_date)
--                 VALUES (@auditYearPart, CAST(YEAR(@auditDate) AS VARCHAR(4)) + '-07-01', CAST(YEAR(@auditDate) AS VARCHAR(4)) + '-12-31');
--             END
--         END
--         SELECT @auditYearPartId = id FROM audit_year_part WHERE name = @auditYearPart;
--
--         INSERT INTO product_audit (product_id, audit_year_part_id, audit_date)
--         VALUES (@productId, @auditYearPartId, @auditDate);
--         PRINT 'Audit started, audit ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR(10));
--     END
--     ELSE
--     BEGIN
--         Raiserror ('Product not found.', 10, 1);
--     END
-- END;

EXEC start_audit 'Product 1', '2021-01-01';
EXEC start_audit 'Better mobile app', '2024-01-01';
EXEC start_audit 'Better React app', '2024-02-01';
SELECT * FROM product_audit;

-- Update procedure with if statement and exception handling
-- CREATE PROCEDURE audit_product
--     @auditId INT,
--     @score INT,
--     @comment VARCHAR(500),
--     @userId INT
-- AS
-- BEGIN
--     IF @score >= 1 AND @score <= 5
--     BEGIN
--         UPDATE product_audit SET audit_score = @score, comment = @comment, user_id = @userId WHERE id = @auditId;
--     END
--     ELSE
--     BEGIN
--         Raiserror ('Score must be between 1 and 5.', 10, 1);
--     END
-- END;

EXEC audit_product 9, 6, 'Good product', 1;
EXEC audit_product 9, 3, 'Good product', 1;
EXEC audit_product 10, 2, 'Not good enough', 1;
SELECT * FROM product_audit;

-- Update procedure with cursor loop
-- CREATE PROCEDURE close_audit_year_part
--     @auditYearPart VARCHAR(10)
-- AS
-- BEGIN
--     DECLARE @auditYearPartId INT;
--     DECLARE @ProductName VARCHAR(140);
--     DECLARE @ProductDepartment VARCHAR(50);
--     DECLARE @AuditScore INT;
--     DECLARE @AuditComment VARCHAR(500);
--     DECLARE @ProductScoreSum INT = 0;
--     DECLARE @ProductCount INT = 0;
--     SELECT @auditYearPartId = id FROM audit_year_part WHERE name = @auditYearPart;
--
--     UPDATE audit_year_part
--     SET end_date = GETDATE(), is_closed = 1
--     WHERE name = @auditYearPart;
--
--     PRINT 'Audit year part closed.';
--     PRINT '------------------------------------';
--     DECLARE auditCursor CURSOR FOR
--     SELECT p.name, p.department, pa.audit_score, pa.audit_comment
--     FROM product_audit pa
--     JOIN product p on pa.product_id = p.id
--     WHERE audit_year_part_id = @auditYearPartId;
--
--     -- Open the cursor
--     OPEN auditCursor;
--
--     -- Fetch the first row
--     FETCH NEXT FROM auditCursor INTO @ProductName, @ProductDepartment, @AuditScore, @AuditComment;
--
--     -- Loop through the cursor
--     WHILE @@FETCH_STATUS = 0
--     BEGIN
--         -- Increment the count for each row fetched
--         SET @ProductCount = @ProductCount + 1;
--         SET @ProductScoreSum = @ProductScoreSum + @AuditScore;
--         PRINT 'Product: ' + @ProductName + ', Department: ' + @ProductDepartment + ', Score: ' + CAST(@AuditScore AS VARCHAR) + ', Comment: ' + @AuditComment;
--
--         -- Fetch the next row
--         FETCH NEXT FROM auditCursor INTO @ProductName, @ProductDepartment, @AuditScore, @AuditComment;
--     END;
--
--     -- Close and deallocate the cursor
--     CLOSE auditCursor;
--     DEALLOCATE auditCursor;
--     PRINT '------------------------------------';
--     PRINT 'Total products audited: ' + CAST(@ProductCount AS VARCHAR);
--     PRINT 'Average score: ' + CAST(@ProductScoreSum / @ProductCount AS VARCHAR);
--     PRINT '------------------------------------';
-- END;
-- GO

SELECT * FROM audit_year_part;
EXEC close_audit_year_part '2024H1';
SELECT * FROM audit_year_part;

-- CREATE TRIGGER audit_product_trigger
-- ON product_audit
-- AFTER INSERT, UPDATE
-- AS
-- BEGIN
--     DECLARE @score INT;
--     SELECT @score = audit_score FROM inserted;
--
--     IF @score IS NOT NULL
--     BEGIN
--         IF @score >= 3
--         BEGIN
--             UPDATE product_audit SET status = 'PASSED' WHERE id IN (SELECT id FROM inserted);
--         END
--         ELSE
--         BEGIN
--             UPDATE product_audit SET status = 'FAILED' WHERE id IN (SELECT id FROM inserted);
--         END
--     END
-- END;

SELECT * FROM product_audit;

-- CREATE TRIGGER user_admin_protection
-- ON [user]
-- AFTER INSERT
-- AS
-- BEGIN
--     DECLARE @IsAdmin INT;
--     SELECT @IsAdmin = is_admin FROM inserted;
--
--     IF @IsAdmin = 1
--     BEGIN
--         ROLLBACK;
--         RAISERROR ('Admin cannot be added.', 16, 1);
--     END
-- END;

INSERT INTO [user] (nickname, email, firstname, lastname, is_admin, is_active) VALUES
('eeee', 'eeee@gmail.com', 'Eeeee', 'Kubica', 1, 1);
SELECT * FROM [user]

-- CREATE TRIGGER user_deactivate_instead_of_delete
-- ON [user]
-- INSTEAD OF DELETE
-- AS
-- BEGIN
--     UPDATE [user]
--     SET is_active = 0
--     WHERE id IN (SELECT id FROM deleted);
-- END;

INSERT INTO [user] (nickname, email, firstname, lastname, is_admin, is_active) VALUES
('TestUser 1', 'test@gmail.com', 'Test', 'User', 0, 1);
DELETE FROM [user] WHERE nickname = 'TestUser 1';
SELECT * FROM [user];

