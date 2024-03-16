-- Kamil Bednarek 254148
-- Damian Biskupski 254150

USE YourDatabaseName;


-- Select procedure and loop
CREATE PROCEDURE select_Products_By_Name
    @name NVARCHAR(50)
AS
BEGIN
    SELECT * FROM product
    WHERE name LIKE '%' + @name + '%';
END;

EXEC select_Products_By_Name 'Product 1'

CREATE PROCEDURE log_all_products_audit
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @TotalRows INT;
    DECLARE @auditId bigint, @auditYearPartId bigint, @status varchar(30), @dateOfAudit date, @result float, @productId bigint, @userId bigint, @components varchar(500), @scopes varchar(500);

    SELECT @TotalRows = COUNT(*) FROM product_audit;

    WHILE @Counter <= @TotalRows
    BEGIN
        SELECT @auditId = id,
               @auditYearPartId = audit_year_part_id,
               @status = status,
               @dateOfAudit = date_of_audit,
               @result = result,
               @productId = product_id,
               @userId = user_id,
               @components = components,
               @scopes = scopes
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY id) AS RowNum, id, audit_year_part_id, status, date_of_audit, result, product_id, user_id, components, scopes
            FROM product_audit
        ) AS RowNumbered
        WHERE RowNum = @Counter;

        PRINT 'Audit ID: ' + CAST(@auditId AS varchar(10));
        PRINT 'Audit Year Part ID: ' + CAST(@auditYearPartId AS varchar(10));
        PRINT 'Status: ' + @status;
        PRINT 'Date of Audit: ' + CONVERT(varchar, @dateOfAudit, 120);
        PRINT 'Result: ' + CAST(@result AS varchar(20));
        PRINT 'Product ID: ' + CAST(@productId AS varchar(10));
        PRINT 'User ID: ' + CAST(@userId AS varchar(10));
        PRINT 'Components: ' + @components;
        PRINT 'Scopes: ' + @scopes;
        PRINT '-----------------------------------';

        SET @Counter = @Counter + 1;
    END
END;

EXEC log_all_products_audit;


-- Insert procedure with if statement
CREATE PROCEDURE insert_Product
    @name varchar(140),
    @department varchar(50),
    @description varchar(500),
    @components varchar(500),
    @scopes varchar(500)
AS
BEGIN
    IF LEN(@name) > 0
    BEGIN
        INSERT INTO product (name, department, description, components, scopes)
        VALUES (@name, @department, @description, @components, @scopes);
    END
    ELSE
    BEGIN
        PRINT 'Error: Product name cannot be empty.';
    END
END;

EXEC insert_Product '', 'Department 1', 'Description 1', 'Components 1', 'Scopes 1'
EXEC insert_Product 'Product 1', 'Department 1', 'Description 1', 'Components 1', 'Scopes 1'


-- Update procedure with exception handling
CREATE Procedure check_Description
    @description VARCHAR(500)
AS
BEGIN
    IF LEN(@description) > 0
    BEGIN
        PRINT 'Description is valid.';
    END
    ELSE
    BEGIN
        Raiserror ('Description cannot be empty.', 16, 1);
    END
END;

CREATE PROCEDURE update_Product_Description
    @id INT,
    @description VARCHAR(500)
AS
BEGIN
    BEGIN TRY
        EXEC check_Description @description;
        UPDATE product
        SET description = @description
        WHERE id = @id;
    END TRY
    BEGIN CATCH
        print 'Error: ' + ERROR_MESSAGE();
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;

EXEC update_Product_Description 1, 'Description 1'
EXEC update_Product_Description 1, ''


-- select function
CREATE FUNCTION dbo.GetProductInfoById
(
    @productId bigint
)
RETURNS TABLE
AS
RETURN
(
    SELECT name, department, description, components, scopes
    FROM product
    WHERE id = @productId
);

SELECT * FROM dbo.GetProductInfoById(1);


-- select funtion with cursor
CREATE FUNCTION dbo.GetProductCountByDepartment
(
    @departmentName VARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @ProductCount INT;
    DECLARE @ProductName VARCHAR(100);

    -- Declare and initialize cursor
    DECLARE productCursor CURSOR FOR
    SELECT name
    FROM product
    WHERE department = @departmentName;

    -- Initialize count
    SET @ProductCount = 0;

    -- Open the cursor
    OPEN productCursor;

    -- Fetch the first row
    FETCH NEXT FROM productCursor INTO @ProductName;

    -- Loop through the cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Increment the count for each row fetched
        SET @ProductCount = @ProductCount + 1;

        -- Fetch the next row
        FETCH NEXT FROM productCursor INTO @ProductName;
    END;

    -- Close and deallocate the cursor
    CLOSE productCursor;
    DEALLOCATE productCursor;

    -- Return the product count
    RETURN @ProductCount;
END;

SELECT dbo.GetProductCountByDepartment('Department 1') as ProductCount;


-- Triggers

--DML Triggers
CREATE TRIGGER user_admin_protection
ON [user]
AFTER INSERT
AS
BEGIN
    DECLARE @IsAdmin INT;
    SELECT @IsAdmin = is_admin FROM inserted;

    IF @IsAdmin = 1
    BEGIN
        ROLLBACK;
        RAISERROR ('Admin cannot be added.', 16, 1);
    END
END;

INSERT INTO [user] (name, is_admin, is_active) VALUES
('Admin 10', 1, 1);

Select * from [user] where name = 'Admin 10';

CREATE TRIGGER user_deactivate_instead_of_delete
ON [user]
INSTEAD OF DELETE
AS
BEGIN
    UPDATE [user]
    SET is_active = 0
    WHERE id IN (SELECT id FROM deleted);
END;

    INSERT INTO [user] (name, is_admin, is_active) VALUES
('TestUser 1', 0, 1);

DELETE FROM [user] WHERE name = 'TestUser 1';

SELECT * FROM [user] WHERE name = 'TestUser 1';

CREATE TRIGGER user_action_Trigger
ON [user]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        PRINT 'Following data has been inserted or updated:';
        SELECT * FROM INSERTED;
    END

    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        PRINT 'Following data has been deleted:';
        SELECT * FROM DELETED;
    END
END;

INSERT INTO [user] (name, is_admin, is_active) VALUES
('TestUser 2', 0, 1);

-- Job Scheduling

USE msdb;
GO

-- Step 1: Create a SQL Server Agent job
EXEC dbo.sp_add_job
    @job_name = N'BackupMonthlyDatabaseJob';

-- Step 2: Define a backup task
EXEC dbo.sp_add_jobstep
    @job_name = N'BackupMonthlyDatabaseJob',
    @step_name = N'BackupDatabaseStep',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE YourDatabaseName TO DISK = ''C:\YOUR_PATH\YourDatabaseName_backup.bak'' WITH INIT',
    @retry_attempts = 5,
    @retry_interval = 5;

-- Step 3: Schedule the job to run monthly
EXEC dbo.sp_add_schedule
    @schedule_name = N'BackupMonthlySchedule',
    @freq_type = 4,  -- Monthly frequency
    @freq_interval = 1,  -- Every month
    @active_start_time = 0;  -- 00:00:00

-- Attach the schedule to the job
EXEC dbo.sp_attach_schedule
    @job_name = N'BackupMonthlyDatabaseJob',
    @schedule_name = N'BackupMonthlySchedule';