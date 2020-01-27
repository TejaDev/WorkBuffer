CREATE DATABASE LenovoDB10
USE LenovoDB10

PRINT 'LENOVO INVOICE GENERATED';

-- CREATION OF TABLES

CREATE TABLE tblCustomer
(
	CustomerID INT PRIMARY KEY,
	CustomerName NVARCHAR(50) NOT NULL,
	CustomerAddress NVARCHAR(50) NOT NULL
) 

GO

CREATE TABLE tblRetailer
(
	RetailerID INT PRIMARY KEY,
	RetailerName NVARCHAR(50) NOT NULL,
	RetailerAddress NVARCHAR(50) NOT NULL
)

GO
CREATE TABLE tblServiceManager
(
	ServiceManagerId INT PRIMARY KEY,
	ServiceManagerName NVARCHAR(50)NOT NULL,
)

GO

CREATE TABLE tblLenovoInvoiceForm
(									
	FormId	INT	PRIMARY KEY,
	InvoiceNumber INT,
	InvDate	DATETIME,
	SubTotal	DECIMAL(10,2),
	BalanceDue	DECIMAL(10,2),
	Shipping	DECIMAL(10,2),
	Discounts	DECIMAL(10,2),
	Total		DECIMAL(10,2)
)

GO

CREATE TABLE tblOrderDetail
(
	OrderDetailId	INT PRIMARY KEY,
	Quantity INT,
	Amount DECIMAL(10,2)
)

GO

CREATE TABLE tblOrder
(
	OrderId INT PRIMARY KEY,
	ItemName NVARCHAR(50),
	Rate DECIMAL(10,2)
)

GO

CREATE TABLE tblItemType
(
	ItemTypeId INT PRIMARY KEY,
	ItemName NVARCHAR(50)
)

GO

PRINT 'Tables created successfully'


--Adding Foreign key Constraints

--a. Customer || --------------------  o< Invoice

	ALTER TABLE tblLenovoInvoiceForm
	ADD CustomerId INT NOT NULL

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT Customer_LenovoInvoiceForm_fk FOREIGN KEY(CustomerId)
	REFERENCES tblCustomer(CustomerId)

--b. Retailer || --------------------- o< LenovoInvoiceForm 
	
	ALTER TABLE tblLenovoInvoiceForm
	ADD RetailerId INT NOT NULL

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT Retailer_LenovoInvoiceForm_fk2 FOREIGN KEY(RetailerId)
	REFERENCES tblRetailer(RetailerId)

--c. Service Manager || -------------------- o< LenovoInvoiceForm

	ALTER TABLE tblLenovoInvoiceForm
	ADD ServiceManagerId INT NOT NULL

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT ServiceManager_LenovoInvoiceForm_fk3 FOREIGN KEY(ServiceManagerId)
	REFERENCES tblServiceManager(ServiceManagerId)

--d. LenovoInvoiceForm || --------------------- |< OrderDetail

	ALTER TABLE tblOrderDetail
	ADD FormId INT NOT NULL

	ALTER TABLE tblOrderDetail
	ADD CONSTRAINT LenovoInvoiceForm_OrderDetail_fk5
	FOREIGN KEY(FormId)
	REFERENCES tblLenovoInvoiceForm(FormId)

--e. Order || -------------------------- o< OrderDetail

	ALTER TABLE tblOrderDetail
	ADD OrderId INT NOT NULL

	ALTER TABLE tblOrderDetail
	ADD CONSTRAINT Order_OrderDetail_fk4 FOREIGN KEY(OrderId)
	REFERENCES tblOrder(OrderId)

--f. ItemType || ----------------------- o< Order

	ALTER TABLE tblOrder
	ADD ItemTypeId INT NOT NULL

	ALTER TABLE tblOrder
	ADD CONSTRAINT ItemType_Order_fk6 FOREIGN KEY(ItemTypeId)
	REFERENCES tblItemType(ItemTypeId)

GO
PRINT 'DONE WITH CREATING FORIEGN CONSTRAINT';


--Constraints

-- Enforce UNIQUE Constraints On Identifiers

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT tblLenovoInvoiceForm_CustomerId
	UNIQUE(CustomerId)

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT tblLenovoInvoiceForm_RetailerId
	UNIQUE(RetailerId)

	ALTER TABLE tblLenovoInvoiceForm
	ADD CONSTRAINT tblLenovoInvoiceForm_ServiceManagerId
	UNIQUE(ServiceManagerId)
	

	ALTER TABLE tblOrderDetail
	ADD CONSTRAINT tblOrderDetail_OrderId
	UNIQUE(OrderId)

GO
PRINT 'DONE WITH UNIQUE CONSTRAINTS'

GO

--MAKE AN EXISTING ATTRIBUTE REQUIRED (NOT NULL)

ALTER TABLE tblCustomer
ALTER COLUMN CustomerName NVARCHAR(50)

ALTER TABLE tblRetailer
ALTER COLUMN RetailerName NVARCHAR(50)

GO
PRINT 'DONE WITH CREATING NOT NULL CONSTRAINT';


--ADD A CHECK CONSTRAINT TO AN EXISTING ATTRIBUTE

	ALTER TABLE tblOrderDetail
	ADD CONSTRAINT QUANTITY_CHECK
	CHECK (QUANTITY > 0)

GO
PRINT 'DONE WITH CREATING CHECK CONSTRAINT';

--Insert into tblCustomer

GO
BEGIN TRY
  BEGIN TRANSACTION

	INSERT INTO tblCustomer(CustomerID,CustomerName,CustomerAddress)
	VALUES (1,'John', '133 East Drive alabama');

	INSERT INTO tblCustomer(CustomerID, CustomerName, CustomerAddress)
	VALUES (2,'Jack', '106 RidgeField alabama');
  
 COMMIT TRANSACTION

  PRINT 'tblCustomer Details Listed'

END TRY
BEGIN CATCH
  DECLARE @ERRORMESSAGE VARCHAR(500)
  SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLEDBACK TRANSACTION: tblCustomer DETAILS HAVE INSERTED PROPERLY.'
  ROLLBACK TRANSACTION
  RAISERROR (@ERRORMESSAGE, 16,1)
END CATCH

--SELECT * FROM tblCustomer;

GO
          
--INSERT INTO tblRetailer

GO
BEGIN TRY
  BEGIN TRANSACTION

    INSERT INTO tblRetailer(RetailerId, RetailerName, RetailerAddress)
	VALUES (1,'Prince Henri', '9A, L-1724 Luxembourg');

	INSERT INTO tblRetailer(RetailerId, RetailerName, RetailerAddress)
	VALUES (2,'George', '10B, g-123 NY');
  
 COMMIT TRANSACTION

  PRINT 'tblRetailer DETAILS SUCCESSFULLY INSERTED...'

END TRY
BEGIN CATCH
  DECLARE @ERRORMESSAGE VARCHAR(500)
  SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLEDBACK TRANSACTION: tblRetailer DETAILS HAVE INSERTED PROPERLY.'
  ROLLBACK TRANSACTION
  RAISERROR (@ERRORMESSAGE, 16,1)
END CATCH

--SELECT * FROM tblRetailer;

GO

-- INSERT THE VALUES INTO tblServiceManager

GO
BEGIN TRY

  BEGIN TRANSACTION

    INSERT INTO tblServiceManager(ServiceManagerId , ServiceManagerName)
	VALUES(1, 'Ranjan Nayar');

	INSERT INTO tblServiceManager(ServiceManagerId, ServiceManagerName)
	VALUES(2, 'Michael Paul');


 COMMIT TRANSACTION

  PRINT 'tblServiceManager DETAILS SUCCESSFULLY INSERTED...'

END TRY
BEGIN CATCH
  DECLARE @ERRORMESSAGE VARCHAR(500)
  SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLEDBACK TRANSACTION: tblServiceManager DETAILS HAVE INSERTED PROPERLY.'
  ROLLBACK TRANSACTION
  RAISERROR (@ERRORMESSAGE, 16,1)
END CATCH

-- INSERT THE VALUES INTO tblLenovoInvoiceForm

GO
BEGIN TRY
    BEGIN TRANSACTION
	 
    INSERT INTO tblLenovoInvoiceForm(FormId, InvoiceNumber,InvDate, SubTotal, BalanceDue, Shipping, Discounts, Total, CustomerId, RetailerId, ServiceManagerId) 
	                         VALUES('1',000010,'11/11/2015','159.93','159.93','4','4.69','159.93', 1,1,1)


    COMMIT TRANSACTION

    PRINT 'tblLenovoInvoiceForm Info Added'
END TRY  
BEGIN CATCH

   DECLARE @ERRORMESSAGE VARCHAR(200)
   SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+'tblLenovoInvoiceForm information is terminated due to error'
   ROLLBACK TRANSACTION
   RAISERROR (@ERRORMESSAGE ,16,1)

END CATCH

--Insert VALUES INTO tblItemType

GO
BEGIN TRY
  BEGIN TRANSACTION

    INSERT INTO tblItemType(ItemTypeId , ItemName)
		VALUES (1,'Windows 10');
    INSERT INTO tblItemType(ItemTypeId , ItemName)
		VALUES (2,'Windows 8.1');
    INSERT INTO tblItemType(ItemTypeId , ItemName)
		VALUES (3,'Windows 8');
    
 COMMIT TRANSACTION

PRINT 'ItemType DETAILS SUCCESSFULLY INSERTED...'

END TRY
BEGIN CATCH
  DECLARE @ERRORMESSAGE VARCHAR(500)
  SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLEDBACK TRANSACTION: ItemType DETAILS HAVE INSERTED PROPERLY.'
  ROLLBACK TRANSACTION
  RAISERROR (@ERRORMESSAGE, 16,1)
END CATCH

GO


--	Insert values into tblOrder
GO

BEGIN TRY
  BEGIN TRANSACTION

    INSERT INTO tblOrder(OrderId,ItemName, Rate, ItemTypeId)
	VALUES (34,'Lenovo Yoga', '349', 1);

	INSERT INTO tblOrder(OrderId,ItemName, Rate, ItemTypeId)
	VALUES (35,'Lenovo(Mouse)', '29',2);
  
 COMMIT TRANSACTION

  PRINT 'tblItemType DETAILS SUCCESSFULLY INSERTED...'

END TRY
BEGIN CATCH
  DECLARE @ERRORMESSAGE VARCHAR(500)
  SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLEDBACK TRANSACTION: tblOrder DETAILS HAVE INSERTED PROPERLY.'
  ROLLBACK TRANSACTION
  RAISERROR (@ERRORMESSAGE, 16,1)
END CATCH


---	Insert values into tblOrderDetail
SELECT * FROM tblOrderDetail
SELECT * FROM tblOrder
SELECT * FROM tblItemType


GO
BEGIN TRY
    BEGIN TRANSACTION
	 
	INSERT INTO tblOrderDetail(OrderDetailId, Quantity, Amount,FormId,OrderId) 
	VALUES(1,1,19.99,1,34)
	
	INSERT INTO tblOrderDetail(OrderDetailId, Quantity, Amount,FormId,OrderId) 
	VALUES(2,1,9.99,1,35)
    
    COMMIT TRANSACTION
	select * from tblOrderDetail
	PRINT 'tblOrderDetail info added'
END TRY

BEGIN CATCH

   DECLARE @ERRORMESSAGE VARCHAR(200)
   SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+'OrderDetail information is terminated due to error'
   ROLLBACK TRANSACTION
   RAISERROR (@ERRORMESSAGE ,16,1)

END CATCH

GO

CREATE PROCEDURE INSERTINTOSERVICEMANAGER
@SERVICEMANAGERID   INT,
@SERVICEMANAGERNAME NVARCHAR(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO tblServiceManager(ServiceManagerId,ServiceManagerName) VALUES(@SERVICEMANAGERID,@SERVICEMANAGERNAME)
		COMMIT TRANSACTION
		PRINT 'NEW ROW INSERTED'
	END TRY
	BEGIN CATCH

		DECLARE @ERRORMESSAGE VARCHAR(50)
		SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+'INSERT FAILED'
		ROLLBACK TRANSACTION
		RAISERROR (@ERRORMESSAGE ,16,1)
	END CATCH
END

-- TEST STATEMENT : EXEC INSERTINTOSERVICEMANAGER 3,'SAITEJA';

GO

CREATE PROCEDURE UPDATETHESERVICEMANAGER
@SERVICEMANAGERNAME NVARCHAR(20),
@SERVICEMANAGERID INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE tblServiceManager
			SET ServiceManagerName=@SERVICEMANAGERNAME
			WHERE ServiceManagerID=@SERVICEMANAGERID
		COMMIT TRANSACTION
		PRINT 'ROW IS UPDATED '
	END TRY
	BEGIN CATCH

		DECLARE @ERRORMESSAGE VARCHAR(50)
		SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+'UPDATE FAILED'
		ROLLBACK TRANSACTION
		RAISERROR (@ERRORMESSAGE ,16,1)
	END CATCH
END

GO

--TEST STATEMENT : EXEC UPDATETHESERVICEMANAGER 'SAI',3;

CREATE PROCEDURE DELETETHESERVICEMANAGER
@SERVICEMANAGERNAME NVARCHAR(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM tblServiceManager
			WHERE ServiceManagerName=@SERVICEMANAGERNAME
		COMMIT TRANSACTION
		PRINT 'ROW IS DELETED'
	END TRY
	BEGIN CATCH

		DECLARE @ERRORMESSAGE VARCHAR(50)
		SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+'DELETE FAILED'
		ROLLBACK TRANSACTION
		RAISERROR (@ERRORMESSAGE ,16,1)
	END CATCH
END

-- TEST STATEMENT : EXEC DELETETHESERVICEMANAGER 'SAI';

--MINIMUM CARDINALITY

GO


CREATE PROCEDURE DELETESERVICEMANAGER
@SMID INT
AS
BEGIN
	IF((SELECT COUNT(*) FROM tblServiceManager WHERE tblServiceManager.ServiceManagerId=@SMID)<2)
	BEGIN
		RAISERROR('SERVICE MANAGER CANNOT BE DELETED AS THE MINIMUM  REACHED',16,1)
		RETURN
	END
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM tblServiceManager 
			WHERE ServiceManagerId=@SMID
		COMMIT TRANSACTION
		PRINT 'DELETIONS SUCCESSFULL'
	END TRY
	
	BEGIN CATCH

		DECLARE @ERRORMESSAGE VARCHAR(100)
		SET @ERRORMESSAGE=ERROR_MESSAGE()+'ROLLBACK TRANSACTION'+' DELETION FAILED'
		ROLLBACK TRANSACTION
		RAISERROR (@ERRORMESSAGE ,16,1)
	END CATCH
END

-- TEST CONDITION : EXEC DELETESERVICEMANAGER 1


--Audit Tables 
GO

CREATE TABLE AudittblSERVICEMANAGER
(
	AuditLogID INT IDENTITY(1,1) PRIMARY KEY,
	ServiceManagerID INT,
	ServiceManagerName varchar(10),
	ChangedBy INT,
	ChangeTime DATETIME DEFAULT GETDATE(),
	ChangeType NVARCHAR(10),
	ImageType NVARCHAR(10)
)


GO

ALTER TABLE tblServiceManager
ADD RECENTCHANGED INT

GO

-- TRIGGERS
UPDATE tblServiceManager
SET RECENTCHANGED=1


GO

CREATE TRIGGER INSERTTRIGGER2 ON tblServiceManager
FOR INSERT
AS
BEGIN

		SELECT 'INSERTED' AS BUFFER,inserted.*
		FROM inserted

		INSERT INTO AudittblSERVICEMANAGER
(ServiceManagerID,ServiceManagerName,ChangedBy,ChangeTime,ChangeType,ImageType)
			SELECT ServiceManagerID,ServiceManagerName,RECENTCHANGED,GETDATE() AS ChangeTime,'INSERT' AS ChangeType,'AFTER' AS ImageType
			FROM inserted
END

GO


INSERT INTO tblServiceManager(ServiceManagerID,ServiceManagerName,RECENTCHANGED) VALUES(3,'SAI TEJA',2)

GO




CREATE TRIGGER UPDATETRIGGER ON tblServiceManager
FOR UPDATE
AS
BEGIN
		
		INSERT INTO AudittblSERVICEMANAGER
(ServiceManagerID,ServiceManagerName,ChangedBy,ChangeTime,ChangeType,ImageType)
			SELECT ServiceManagerId,ServiceManagerName,RECENTCHANGED,GETDATE() AS ChangeTime,'UPDATE' AS ChangeType,'BEFORE' AS ImageType
			FROM deleted
		INSERT INTO AudittblSERVICEMANAGER
(ServiceManagerID,ServiceManagerName,ChangedBy,ChangeTime,ChangeType,ImageType)
			SELECT ServiceManagerId,ServiceManagerName,RECENTCHANGED,GETDATE() AS 
ChangeTime,'UPDATE' AS ChangeType,'AFTER' AS ImageType
			FROM inserted
END

GO

UPDATE tblServiceManager
SET ServiceManagerName='SAI'
WHERE ServiceManagerId=3

GO

CREATE TRIGGER DELETETRIGGER ON tblServiceManager
FOR DELETE
AS
BEGIN
		
		INSERT INTO AudittblSERVICEMANAGER
(ServiceManagerID,ServiceManagerName,ChangedBy,ChangeTime,ChangeType,ImageType)
			SELECT ServiceManagerID,ServiceManagerName,RECENTCHANGED,GETDATE() AS 
ChangeTime,'DELETE' AS ChangeType,'BEFORE' AS ImageType
			FROM deleted
END

GO

DELETE FROM tblServiceManager
WHERE ServiceManagerId=3;

GO

-- SELECT * FROM tblServiceManager
-- SELECT * FROM AudittblSERVICEMANAGER


CREATE VIEW vwGBH
AS
SELECT FormID,SUM(Amount) AS FID
FROM tblOrderDetail
GROUP BY FormId
HAVING SUM(Amount) > 10

GO
--SELECT * FROM vwGROUPBYHAVING;

PRINT 'VIEW CREATED '

GO
					

CREATE VIEW vwNESTEDQUERY
AS
SELECT	tblCustomer.CustomerId, tblCustomer.CustomerName, tblCustomer.CustomerAddress,
		tblRetailer.RetailerId

FROM tblCustomer,tblRetailer,tblLenovoInvoiceForm

WHERE tblCustomer.CustomerId = tblLenovoInvoiceForm.CustomerId
		AND tblRetailer.RetailerID = tblLenovoInvoiceForm.RetailerId	

GO

SELECT * FROM vwNESTEDQUERY;

GO