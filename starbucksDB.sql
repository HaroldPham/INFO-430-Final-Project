CREATE DATABASE team2_starbucksH4
GO
USE team2_starbucksH4
GO
-- 1) We populate tables
-- tblPRODUCT_TYPE -> tblPRODUCT -> tblCART (Lily)
-- tblSTAFF_TYPE -> tblSTAFF (Audrey)
-- tblORDER_TYPE -> tblORDER -> tblORDER_PRODUCT (Christine)
-- tblSTORE_TYPE -> tblSTORE (Audrey)
-- tblCUSTOMER_TYPE -> tblCUSTOMER (Harold)
-- tblRATING -> tblREVIEW (Harold)

/*
Data Types:
People's names: varchar (25) 
Product name: NVARCHAR(60)
Description: varchar (500)
Price: numeric (5,2)
*/

GO
CREATE TABLE tblPRODUCT_TYPE (
   prodTypeID INT PRIMARY KEY IDENTITY(1,1),
   prodTypeName VARCHAR(25) NOT NULL,
   prodTypeDescr VARCHAR(500)
)

GO

CREATE TABLE tblPRODUCT (
   prodID INT PRIMARY KEY IDENTITY(1,1),
   prodName NVARCHAR(60) NOT NULL,
   prodTypeID INT NOT NULL,
   price NUMERIC(5, 2) NOT NULL,
   prodDescr VARCHAR(500)
)

GO

CREATE TABLE tblCART (
   cartID INT PRIMARY KEY IDENTITY(1,1),
   custID INT NOT NULL,
   prodID INT NOT NULL,
   itemCount INT NOT NULL,
   cartDate DATE NOT NULL
)

GO

CREATE TABLE tblORDER_TYPE (
    orderTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
    orderTypeName VARCHAR(25) NOT NULL,
    orderTypeDescr VARCHAR(500) NULL
)

GO

CREATE TABLE tblORDER(
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    custID INT NOT NULL,
    orderTypeID INT NOT NULL,
    storeID INT NOT NULL,
    pointsEarned INT NULL,
    orderTotal NUMERIC(10,2) NOT NULL,
    orderDateTime DATETIME NOT NULL
)

GO

CREATE TABLE tblORDER_PRODUCT (
    orderProdID INT IDENTITY(1,1) PRIMARY KEY,
    prodID INT NOT NULL,
    orderID INT NOT NULL,
    staffID INT NOT NULL,
    prodQuantity INT NOT NULL
)

GO

CREATE TABLE tblSTAFF_TYPE (
    staffTypeID INT IDENTITY(1,1) PRIMARY KEY,
    staffTypeName VARCHAR(50) NOT NULL,
    staffTypeDescr VARCHAR(500) NULL
)


CREATE TABLE tblSTAFF(
    staffID INT IDENTITY(1,1) PRIMARY KEY,
    staffTypeID INT NOT NULL,
    staffFname VARCHAR(50) NOT NULL,
    staffLname VARCHAR(50) NOT NULL,
    staffDOB DATE NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NULL
)

CREATE TABLE tblSTORE_TYPE(
    storeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    storeTypeName VARCHAR(50) NOT NULL,
    storeTypeDescr VARCHAR(500) NULL
)

CREATE TABLE tblSTORE(
    storeID INT IDENTITY(1,1) PRIMARY KEY,
    storeTypeID INT NOT NULL,
    storeName VARCHAR(50) NOT NULL,
    storeAddress VARCHAR(50) NOT NULL
)

CREATE TABLE tblCUSTOMER_TYPE(
    custTypeID INT IDENTITY(1,1) PRIMARY KEY,
    custTypeName varchar(25) NOT NULL,
    custTypeDescr varchar(500) NULL
)

CREATE TABLE tblCUSTOMER(
    custID INT IDENTITY(1,1) PRIMARY KEY,
    custTypeID INT NOT NULL,
    custFname varchar(25) NOT NULL,
    custLname varchar(25) NOT NULL,
    custDOB Date NOT NULL,
    custPhoneNumber Numeric(10,0) NULL,
    custEmail varchar(50) NULL,
    totalRewardStars INT NOT NULL
)

CREATE TABLE tblREVIEW(
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    ratingID INT NOT NULL,
    orderProdID INT NOT NULL,
    reviewContent varchar(500) NOT NULL,
    reviewDate DATE
)

CREATE TABLE tblRATING(
    ratingID INT IDENTITY(1,1) PRIMARY KEY,
    ratingNumber INT NOT NULL,
    ratingDescr varchar(25),
)

-- 2) Alter table statements to add FKs to each of our own tables
ALTER TABLE tblPRODUCT
ADD CONSTRAINT FK_tblPRODUCT_T
FOREIGN KEY (prodTypeID) REFERENCES tblPRODUCT_TYPE(prodTypeID)

ALTER TABLE tblCART
ADD CONSTRAINT FK_tblCART_CUST
FOREIGN KEY (custID) REFERENCES tblCUSTOMER(custID)

ALTER TABLE tblCART
ADD CONSTRAINT FK_tblCART_PROD
FOREIGN KEY (prodID) REFERENCES tblPRODUCT(prodID)

ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_CUSTOMER
FOREIGN KEY (custID) REFERENCES tblCUSTOMER(custID)

ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_ORDERTYPE
FOREIGN KEY (orderTypeID) REFERENCES tblORDER_TYPE(orderTypeID)

ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_STORE
FOREIGN KEY (storeID) REFERENCES tblSTORE(storeID)

ALTER TABLE tblORDER_PRODUCT
ADD CONSTRAINT FK_tblORDER_PRODUCT_P
FOREIGN KEY (prodID) REFERENCES tblPRODUCT(prodID)

ALTER TABLE tblORDER_PRODUCT
ADD CONSTRAINT FK_tblORDER_PRODUCT_Order
FOREIGN KEY (orderID) REFERENCES tblORDER(orderID)

ALTER TABLE tblORDER_PRODUCT
ADD CONSTRAINT FK_tblORDER_PRODUCT_Staff
FOREIGN KEY (staffID) REFERENCES tblSTAFF(staffID)

ALTER TABLE tblSTAFF
ADD CONSTRAINT FK_tblSTAFF_tblSTAFF_TYPE
FOREIGN KEY (staffTypeID)
REFERENCES tblSTAFF_TYPE(staffTypeID)

ALTER TABLE tblSTORE
ADD CONSTRAINT FK_tblSTORE_tblSTORE_TYPE
FOREIGN KEY (storeTypeID)
REFERENCES tblSTORE_TYPE(storeTypeID)

ALTER TABLE tblCUSTOMER
ADD CONSTRAINT FK_CustTypeID
FOREIGN KEY (custTypeID)
REFERENCES tblCUSTOMER_TYPE(custTypeID)

ALTER TABLE tblREVIEW
ADD CONSTRAINT FK_orderProdID
FOREIGN KEY (orderProdID)
REFERENCES tblORDER_PRODUCT(orderProdID)

ALTER TABLE tblREVIEW
ADD CONSTRAINT FK_ratingID
FOREIGN KEY (ratingID)
REFERENCES tblRATING(ratingID)

GO

-- 3) Lab 7 synthetic transaction
-- Tables with more than 1 FKs: tblORDER (Christine), tblORDER_PRODUCT (Audrey), tblCart(Lily), tblREVIEW (Harold)

-- Audrey's Lab 7 

-- tblCustomer (custID, custFname, custLname, custDOB, custPhoneNumber, custEmail, custRewardsStars)
CREATE OR ALTER PROCEDURE uspGetCustID
  @C_Fname VARCHAR(50),
  @C_Lname VARCHAR(50),
  @C_DOB DATE,
  @C_ID INT OUTPUT
  AS
  SET @C_ID = (SELECT custID FROM tblCustomer WHERE custFname = @C_Fname AND custLname = @C_Lname AND custDOB = @C_DOB)
GO

-- tblOrder_Type (orderTypeID, orderTypeName, orderTypeDescr)
CREATE OR ALTER PROCEDURE uspGetOrderTypeID_Audrey
  @OT_Name VARCHAR(50),
  @OT_ID INT OUTPUT
  AS
  SET @OT_ID = (SELECT orderTypeID FROM tblOrder_Type WHERE orderTypeName = @OT_Name)
GO

-- tblStore (storeID, storeName, storeAddress)
CREATE OR ALTER PROCEDURE uspGetStoreID_Audrey
  @S_Name VARCHAR(50),
  @S_Address VARCHAR(50),
  @S_ID INT OUTPUT
  AS
  SET @S_ID = (SELECT storeID FROM tblStore WHERE storeName = @S_Name AND storeAddress = @S_Address)
GO

SELECT *
FROM tblORDER
GO

-- tblOrder (orderID, custID, orderTypeID, storeID, pointsEarned, orderDateTime, orderTotal)
CREATE OR ALTER PROCEDURE uspGetOrderID
  @CustFname VARCHAR(50),
  @CustLname VARCHAR(50),
  @CustDOB DATE,
  @OTName VARCHAR(50),
  @SName VARCHAR(50),
  @SAddress VARCHAR(50),
  @O_DateTime DATETIME,
  @O_ID INT OUTPUT
  AS
  DECLARE @CID INT, @OTID INT, @SID INT
  EXEC uspGetCustID
    @C_Fname = @CustFname,
    @C_Lname = @CustLname,
    @C_DOB = @CustDOB,
    @C_ID = @CID OUTPUT

  IF @CID IS NULL
    BEGIN
      PRINT('Customer does not exist');
      THROW 50001, 'Customer ID not found', 1;
    END

  EXEC uspGetOrderTypeID_Audrey
    @OT_Name = @OTName,
    @OT_ID = @OTID OUTPUT

  IF @OTID IS NULL
    BEGIN
      PRINT('Order type does not exist');
      THROW 50001, 'Order type ID not found', 1;
    END

  EXEC uspGetStoreID_Audrey
    @S_Name = @SName,
    @S_Address = @SAddress,
    @S_ID = @SID OUTPUT

  IF @SID IS NULL
    BEGIN
      PRINT('Store does not exist');
      THROW 50001, 'Store ID not found', 1;
    END

  SET @O_ID = (SELECT orderID FROM tblOrder WHERE custID = @CID AND orderTypeID = @OTID AND storeID = @SID AND orderDateTime = @O_DateTime)
GO

-- tblStaff_Type (staffTypeID, staffTypeName, staffTypeDescr)
CREATE OR ALTER PROCEDURE uspGetStaffTypeID
  @ST_Name VARCHAR(50),
  @ST_ID INT OUTPUT
  AS
  SET @ST_ID = (SELECT staffTypeID FROM tblStaff_Type WHERE staffTypeName = @ST_Name)
GO

-- tblStaff (staffID, staffTypeID, staffFname, staffLname, staffDOB, staffStartDate, staffEndDate)
CREATE OR ALTER PROCEDURE uspGetStaffID
  @S_Fname VARCHAR(50),
  @S_Lname VARCHAR(50),
  @S_DOB DATE,
  @S_ID INT OUTPUT
  AS

  SET @S_ID = (SELECT staffID FROM tblStaff WHERE staffFname = @S_Fname AND staffLname = @S_Lname AND staffDOB = @S_DOB)
GO

-- tblProduct_Type (prodTypeID, prodTypeName, prodTypeDescr)
CREATE OR ALTER PROCEDURE uspGetProdTypeID
  @PT_Name VARCHAR(50),
  @PT_ID INT OUTPUT
  AS
  SET @PT_ID = (SELECT prodTypeID FROM tblProduct_Type WHERE prodTypeName = @PT_Name)
GO

CREATE OR ALTER PROCEDURE uspGetProductID
@product nvarchar(60),
@id INT OUTPUT
AS
SET @id = (SELECT ProdID FROM tblPRODUCT
WHERE prodName = @product)
GO

/**
 * Order_Product Insert Stored Procedure
 * tblOrder_Product (orderProdID, prodID, orderID, staffID, prodQuantity)
 */
CREATE OR ALTER PROCEDURE uspINSERT_ORDER_PRODUCT
  -- productID
  @ProductType_Name VARCHAR(50),
  @Product_Name VARCHAR(50),
  @Order_ID INT,
  -- orderID
  -- @Customer_Fname VARCHAR(50),
  -- @Customer_Lname VARCHAR(50),
  -- @Customer_DOB DATE,
  -- @OrderType_Name VARCHAR(50),
  -- @Store_Name VARCHAR(50),
  -- @Store_Address VARCHAR(50),
  -- @Order_DateTime DATETIME,
  -- staffID
  @StaffType_Name VARCHAR(50),
  @Staff_Fname VARCHAR(50),
  @Staff_Lname VARCHAR(50),
  @Staff_DOB DATE,
  @Staff_StartDate DATE,
  @OP_Quantity INT
AS
DECLARE @ProductID INT, @StaffID INT

-- uspGetProdID
EXEC uspGetProductID
  @product = @Product_Name,
  @id = @ProductID OUTPUT

IF @ProductID IS NULL
  BEGIN
    PRINT('Product does not exist');
    THROW 50001, 'Product ID not found', 1;
  END

-- uspGetStaffID
EXEC uspGetStaffID
  @S_Fname = @Staff_Fname,
  @S_Lname = @Staff_Lname,
  @S_DOB = @Staff_DOB,
  @S_ID = @StaffID OUTPUT

IF @StaffID IS NULL
  BEGIN
    PRINT('Staff does not exist');
    THROW 50001, 'Staff ID not found', 1;
  END

BEGIN TRANSACTION G1
  INSERT INTO tblOrder_Product (prodID, orderID, staffID, prodQuantity)
  VALUES (@ProductID, @Order_ID, @StaffID, @OP_Quantity)

  IF @@ERROR <> 0
    BEGIN
      PRINT('Error inserting into tblOrder_Product')
      ROLLBACK TRANSACTION G1
    END
  ELSE
    COMMIT TRANSACTION G1
GO

/**
 * Synthetic Transaction Wrapper
 */
CREATE OR ALTER PROCEDURE wrapper_uspINSERT_ORDER_PRODUCT
  @Run INT
  AS
  DECLARE
    @ProdTName VARCHAR(50),
    @ProdName VARCHAR(50),
    @CustFname VARCHAR(50),
    @CustLname VARCHAR(50),
    @CustDOB DATE,
    @OrderTName VARCHAR(50),
    @StoreName VARCHAR(50),
    @StoreAddress VARCHAR(50),
    @OrderDateTime DATETIME,
    @StaffTName VARCHAR(50),
    @StaffFname VARCHAR(50),
    @StaffLname VARCHAR(50),
    @StaffDOB DATE,
    @StaffStartDate DATE,
    @OPQty INT

  -- random PK variables
  DECLARE
    @ProdType_PK INT,
    @Prod_PK INT,
    @Order_PK INT,
    @Cust_PK INT,
    @OrderType_PK INT,
    @Store_PK INT,
    @Staff_PK INT,
    @StaffType_PK INT

  -- PK tables row count
  DECLARE @ProdTypeCount INT = (SELECT COUNT(*) FROM tblProduct_Type)
  DECLARE @ProdCount INT = (SELECT COUNT(*) FROM tblProduct)
  DECLARE @OrderCount INT = (SELECT COUNT(*) FROM tblOrder)
  DECLARE @CustCount INT = (SELECT COUNT(*) FROM tblCustomer)
  DECLARE @OrderTypeCount INT = (SELECT COUNT(*) FROM tblOrder_Type)
  DECLARE @StoreCount INT = (SELECT COUNT(*) FROM tblStore)
  DECLARE @StaffCount INT = (SELECT COUNT(*) FROM tblStaff)
  DECLARE @StaffTypeCount INT = (SELECT COUNT(*) FROM tblStaff_Type)

  WHILE @Run > 0
    BEGIN
      SET @ProdType_PK = (SELECT RAND() * @ProdTypeCount + 1)
      SET @Prod_PK = (SELECT RAND() * @ProdCount + 1)
      SET @Order_PK = (SELECT RAND() * @OrderCount + 1)
      SET @Cust_PK = (SELECT RAND() * @CustCount + 1)
      SET @OrderType_PK = (SELECT RAND() * @OrderTypeCount + 1)
      SET @Store_PK = (SELECT RAND() * @StoreCount + 1)
      SET @Staff_PK = (SELECT RAND() * @StaffCount + 1)
      SET @StaffType_PK = (SELECT RAND() * @StaffTypeCount + 1)

      SET @ProdTName = (SELECT prodTypeName FROM tblProduct_Type WHERE prodTypeID = @ProdType_PK)
      SET @ProdName = (SELECT prodName FROM tblProduct WHERE prodID = @Prod_PK)
      SET @CustFname = (SELECT custFname FROM tblCustomer WHERE custID = @Cust_PK)
      SET @CustLname = (SELECT custLname FROM tblCustomer WHERE custID = @Cust_PK)
      SET @CustDOB = (SELECT custDOB FROM tblCustomer WHERE custID = @Cust_PK)
      SET @OrderTName = (SELECT orderTypeName FROM tblOrder_Type WHERE orderTypeID = @OrderType_PK)
      SET @StoreName = (SELECT storeName FROM tblStore WHERE storeID = @Store_PK)
      SET @StoreAddress = (SELECT storeAddress FROM tblStore WHERE storeID = @Store_PK)
      SET @OrderDateTime = (SELECT orderDateTime FROM tblOrder WHERE orderID = @Order_PK)
      SET @StaffTName = (SELECT staffTypeName FROM tblStaff_Type WHERE staffTypeID = @StaffType_PK)
      SET @StaffFname = (SELECT staffFname FROM tblStaff WHERE staffID = @Staff_PK)
      SET @StaffLname = (SELECT staffLname FROM tblStaff WHERE staffID = @Staff_PK)
      SET @StaffDOB = (SELECT staffDOB FROM tblStaff WHERE staffID = @Staff_PK)
      SET @StaffStartDate = (SELECT startDate FROM tblStaff WHERE staffID = @Staff_PK)
      SET @OPQty = (SELECT RAND() * 99 + 1)

      EXEC uspINSERT_ORDER_PRODUCT
        @ProductType_Name = @ProdTName,
        @Product_Name = @ProdName,
        @Order_ID = @Order_PK,
        @StaffType_Name = @StaffTName,
        @Staff_Fname = @StaffFname,
        @Staff_Lname = @StaffLname,
        @Staff_DOB = @StaffDOB,
        @Staff_StartDate = @StaffStartDate,
        @OP_Quantity = @OPQty
      SET @Run = @Run - 1
    END
GO

-- Harold's Lab 7
CREATE OR ALTER PROCEDURE usp_INSERTReview
--Get whatever usp_GETOrderProdID needs to return the fk
@O_IDV3 INT,
@rIDV2 INT,

--Then get what tblREVIEW needs to fill in the rest of the table that isn't fk
@reviewContentV2 VARCHAR(500),
@reviewDateV2 DATE

AS

BEGIN TRANSACTION T1
INSERT INTO tblREVIEW (ratingID, orderProdID, reviewContent, reviewDate)
VALUES(@rIDV2, @O_IDV3, @reviewContentV2, @reviewDateV2)
IF @@ERROR <> 0
    BEGIN
        PRINT 'Something went wrong with inserting into review, rolling back transaction...'
        ROLLBACK TRANSACTION T1
    END
ELSE
    COMMIT TRANSACTION T1
GO

--Begin step 3 making wrapper code
CREATE OR ALTER PROCEDURE wrapper_usp_INSERTReview
@Run INT
AS
DECLARE 
@reviewContentV3 VARCHAR(500),
@reviewDateV3 DATE

DECLARE @opPK INT, @rPK INT

DECLARE @op_count INT = (SELECT COUNT(*) FROM tblORDER_PRODUCT)
DECLARE @r_count INT = (SELECT COUNT(*) FROM tblRATING)

WHILE @Run > 0
BEGIN
--start by getting a random row from both of the fk tables so that we can refer to the row when retrieving other values moving forward.
SET @opPK = (SELECT RAND() * @op_count + 1)
SET @rPK = (SELECT RAND() * @r_count + 1)

    --Since we assume that there isn't anything in the tblREVIEW at the moment, we can't pick anything out of it to fill into these variables. Must hardcode a solution somehow.
    SET @reviewContentV3 = 'asdsadcnahdwqoscai;jidc;asj;ondav;sijn' --Not sure how to randomize this VARCHAR(500)
    SET @reviewDateV3 = (SELECT DATEADD(DAY, -(SELECT RAND() * 10000), GetDate()))


    EXECUTE usp_INSERTReview
    @O_IDV3 = @opPK,
    @rIDV2 = @rPK,
    @reviewContentV2 = @reviewContentV3,
    @reviewDateV2 = @reviewDateV3 

    SET @Run = @Run - 1
END
GO

-- Christine's Lab 7
--- Write the SQL code to create 'GetID' stored procedures for each required FK.
CREATE OR ALTER PROCEDURE uspGetCustomerID
  @CFName VARCHAR(25),
  @CLName VARCHAR(25),
  @CDOB DATE,
  @CID INT OUTPUT
AS
SET @CID = (SELECT custID FROM tblCUSTOMER WHERE custFname = @CFName AND custLname = @CLName AND custDOB = @CDOB)
GO

CREATE OR ALTER PROCEDURE uspGetOrderTypeID
  @OrderTName VARCHAR(25),
  @OrderTID INT OUTPUT
AS
SET @OrderTID = (SELECT orderTypeID FROM tblORDER_TYPE WHERE orderTypeName = @OrderTName)
GO

CREATE OR ALTER PROCEDURE uspGetStoreID
  @SName VARCHAR(50),
  @SID INT OUTPUT
AS
SET @SID = (SELECT storeID FROM tblSTORE WHERE storeName = @SName)
GO

---  Write the SQL code to create another base stored procedure to INSERT 1 new row into the transactional table 
--- while calling the required GetID procedures

CREATE OR ALTER PROCEDURE uspInsertOrder
@CustFName VARCHAR(25),
@CustLName VARCHAR(25),
@CustDOB DATE,
@OrderTypeName VARCHAR(25),
@StoreName VARCHAR(50),
@PointsEarned INT,
@OrderTotal NUMERIC(10, 2),
@OrderDateTime DATETIME
AS 
BEGIN
    DECLARE @CustID INT, @OrderTypeID INT, @StoreID INT

    EXEC uspGetCustomerID
    @CFName = @CustFName, 
    @CLName = @CustLName,
    @CDOB = @CustDOB,
    @CID = @CustID OUTPUT
    IF @CustID IS NULL
    BEGIN 
        PRINT '@CustID could not be found.';
        THROW 55001, 'Customer ID retrieval failed', 1;
    END


    EXEC uspGetOrderTypeID 
    @OrderTName = @OrderTypeName,
    @OrderTID = @OrderTypeID OUTPUT
    IF @OrderTypeID IS NULL
    BEGIN 
        PRINT '@OrderTypeID could not be found.';
        THROW 55002, 'Order Type ID retrieval failed', 1;
    END

    EXEC uspGetStoreID 
    @SName = @StoreName, 
    @SID = @StoreID OUTPUT
    IF @StoreID IS NULL
    BEGIN 
        PRINT '@StoreID could not be found.';
        THROW 55003, 'Store ID retrieval failed', 1;
    END

	BEGIN TRANSACTION G2
    INSERT INTO tblOrder (custID, orderTypeID, storeID, pointsEarned, orderTotal, orderDateTime)
    VALUES (@CustID, @OrderTypeID, @StoreID, @PointsEarned, @OrderTotal, @OrderDateTime)
    IF @@ERROR <> 0
    BEGIN 
        PRINT 'An error occurred while inserting the order.'
        ROLLBACK TRANSACTION G2
    END
    ELSE
    COMMIT TRANSACTION G2
END
GO

--- Write the SQL code to create one more stored procedure 'wrapper' 
--- that will execute the base stored procedure above with a single parameter. 
--- This is a synthetic transaction!

CREATE OR ALTER PROCEDURE wrapper_uspOrder
    @Run INT
AS 
    DECLARE @Firsty VARCHAR(25), @Lasty VARCHAR(25), @DOB Date, @orderT VARCHAR(25), @SName VARCHAR(50), @PointE INT
    DECLARE @OTotal NUMERIC(10, 2), @ODate DATETIME

    DECLARE @CustPK INT, @OrderTypePK INT, @StorePK INT

    DECLARE @CustCount INT = (SELECT COUNT(*) FROM tblCUSTOMER)
    DECLARE @OrderTypeCount INT = (SELECT COUNT(*) FROM tblORDER_TYPE)
    DECLARE @StoreCount INT = (SELECT COUNT(*) FROM tblSTORE)

    WHILE @Run > 0 
    BEGIN 
        SET @CustPK = (SELECT RAND() * @CustCount +1)
        SET @OrderTypePK = (SELECT RAND() * @OrderTypeCount +1)
        SET @StorePK = (SELECT RAND() * @StoreCount +1)

-- Use @CustPK to populate tblCUSTOMER
        SET @Firsty = (SELECT custFname FROM tblCUSTOMER WHERE custID = @CustPK)
        SET @Lasty = (SELECT custLname FROM tblCUSTOMER WHERE custID = @CustPK)
        SET @DOB = (SELECT custDOB FROM tblCUSTOMER WHERE custID = @CustPK)
    
-- Use @OrderTypePK to populate tblORDER_TYPE
        SET @orderT = (SELECT orderTypeName FROM tblORDER_TYPE WHERE orderTypeID = @OrderTypePK)

-- Use @StorePK to populate tblSTORE
        SET @SName = (SELECT storeName FROM tblSTORE WHERE storeID = @StorePK)

-- calculate the remaining required variables (@PointE, @OTotal, and @ODate)
-- for the RegistrationDate, use DateAdd() to 'go backwards' a random number of days from today

-- for points earned from Starbucks, use RAND() to create largests points between 0 and 3000
-- for total order from Starbucks, use RAND() to create greatest order number is up to 5000
        SET @PointE = (SELECT RAND() * 1000)
        SET @OTotal = (SELECT RAND() * 5000 + 1)
        SET @ODate =  (SELECT DATEADD(DAY, -(SELECT RAND() * 10000), GetDate()))

-- now, we are ready to call the base stored procedure we are testing

EXEC uspInsertOrder
    @CustFName = @Firsty, 
    @CustLName = @Lasty, 
    @CustDOB = @DOB, 
    @OrderTypeName = @orderT, 
    @StoreName = @SName, 
    @PointsEarned = @PointE, 
    @OrderTotal = @OTotal, 
    @OrderDateTime = @ODate

SET @Run = @Run - 1
END
GO

-- Lily's Lab 7




/*
2) Write the SQL code to create another base stored procedure to INSERT 1 new row into the transactional table
while calling the required GetID procedures (these are now 'nested' stored procedures).
*/

CREATE OR ALTER PROCEDURE uspInsertCart
@c_first varchar(25),
@c_last varchar(25),
@c_dob DATE,
@p_product nvarchar(60),
@count INT,
@cart_date DATE
AS
DECLARE @c_id INT, @p_id INT

EXEC uspGetCustomerID
@CFName = @c_first,
@CLName = @c_last,
@CDOB = @c_dob,
@CID = @c_id OUTPUT

IF @c_id IS NULL
BEGIN
PRINT 'OUCH';
THROW 51100, '@c_id CANNOT BE EMPTY', 1;
END

EXEC uspGetProductID
@product = @p_product,
@id = @p_id OUTPUT

IF @p_id IS NULL
BEGIN
PRINT 'OUCH';
THROW 51200, '@p_id CANNOT BE EMPTY', 1;
END

BEGIN TRANSACTION G1
INSERT INTO tblCART (custID, prodID, itemCount, cartDate)
VALUES (@c_id, @p_id, @count, @cart_date)

IF @@ERROR <> 0
BEGIN
ROLLBACK TRANSACTION G1
END
ELSE
COMMIT TRANSACTION G1

GO

/*
3) Write the SQL code to create one more stored procedure 'wrapper' that will execute the base stored procedure above
with a single parameter. This is a synthetic transaction!
*/

CREATE OR ALTER PROCEDURE wrapper_uspINSERT_tblCART
@Run INT
AS

DECLARE
@c_firsty varchar(50),
@c_lasty varchar(50),
@c_birthy DATE,
@p_name varchar(50),
@cart_count INT,
@cart_datey DATE
DECLARE @Cust_PK INT, @Prod_PK INT
DECLARE @Cust_Count INT = (SELECT COUNT(*) FROM tblCUSTOMER)
DECLARE @Prod_Count INT = (SELECT COUNT(*) FROM tblPRODUCT)

WHILE @Run > 0
BEGIN
SET @Cust_PK = (SELECT RAND() * @Cust_Count + 1)
SET @Prod_PK = (SELECT RAND() * @Prod_Count + 1)
SET @c_firsty = (SELECT custFname FROM tblCUSTOMER WHERE custID = @Cust_PK)
SET @c_lasty = (SELECT custLname FROM tblCUSTOMER WHERE custID = @Cust_PK)
SET @c_birthy = (SELECT custDOB FROM tblCUSTOMER WHERE custID = @Cust_PK)
SET @p_name = (SELECT prodName FROM tblPRODUCT WHERE prodID = @Prod_PK)
SET @cart_datey = (SELECT DATEADD(DAY, -(SELECT RAND() * 10000), GetDate()))
SET @cart_count = (SELECT FLOOR(RAND()*(100-0+1))+0) -- generate count to a random number from 0-100

EXEC uspInsertCart
@c_first = @c_firsty,
@c_last = @c_lasty,
@c_dob = @c_birthy,
@p_product = @p_name,
@count = @cart_count,
@cart_date = @cart_datey
SET @Run = @Run -1
END
GO

-- 4) Populate our lookup tables and other related tables with real-life data
-- 4.1 Lookup tables

INSERT INTO tblPRODUCT_TYPE (prodTypeName, prodTypeDescr)
VALUES ('Drinks', 'These are all the drinks'), ('Food', 'This includes breakfast, Hot Breakfast, Oatmeal & Yogurt, Bakery, Lunch, Snacks & Sweets'), 
('At Home Coffee', 'This includes Whole Bean, Ground, VIA Instant'), ('Merchandise', 'This includes Cold Cups, Tumblers, Mugs, and Other')

INSERT INTO tblSTAFF_TYPE (staffTypeName, staffTypeDescr)
VALUES ('Barista','Baristas are the face of Starbucks. They are an important part of our customers’ days, and experts in handcrafting delicious, perfect beverages. Baristas personally connect and create moments that make a difference and work together to create a welcoming store environment. They bring our mission and values to life—for our customers and each other—while proudly wearing the green apron.'),
('Shift Manager','Shift managers work in partnership with the store manager to create store plans and ensure the team is working together to make every moment right for our customers. They promote an atmosphere of engagement and pride in creating the Starbucks Experience and achieving goals. (Note, this role is only available in Massachusetts.)'),
('Store Manager','Store Managers run their store as if it belongs to them—from managing daily operations to taking responsibility for financial results. Our managers are front-of-house leaders, spending time on the floor to connect with partners, customers, coach in the moment and identify ways to drive results. The role provides the opportunity to develop your own team, hiring and welcoming new partners and future leaders for your store.'),
('Assistant Store Manager','Assistant Managers inspire our customers while developing management skills on their journey to running a great store on their own. The role provides the opportunity to manage store operations, drive business results, lead a team and develop talent—allowing those partners to become the very best they can.'),
('District Manager','District Managers lead a multi-store portfolio and are accountable for store performance in their district by assessing the business, creating meaningful plans to drive results and building connections with their community. They are a leader of leaders who coach and develop future talent, share company vision and goals and consistently inspire their teams to create meaningful connections for customers and each other.
')

INSERT INTO tblSTORE_TYPE (storeTypeName, storeTypeDescr)
VALUES 
('Standard', 'Standard Starbucks store offering full range of coffee and snacks'),
('Drive-Thru', 'Starbucks store with drive-thru service for convenience'),
('Reserve Bar', 'Premium Starbucks experience offering rare and exotic coffee'),
('Kiosk', 'Small Starbucks outlet typically found in malls or airports'),
('Licensed Store', 'Stores operated by other retailers under Starbucks brand');
GO

INSERT INTO tblORDER_TYPE (orderTypeName, orderTypeDescr)
VALUES 
('Online', 'Orders placed through the website'),
('In-Store', 'Orders placed physically in the store'),
('Phone', 'Orders placed via telephone'),
('Delivery', 'Orders delivered to the customer'),
('Pickup', 'Orders picked up by the customer');
GO

INSERT INTO tblCUSTOMER_TYPE (custTypeName, custTypeDescr)
VALUES
    ('Member', 'Customer with a Starbucks account'),
    ('Non-member', 'Customer without a Starbucks account');

INSERT INTO tblRATING (ratingNumber, ratingDescr) VALUES
(1, 'Poor'),
(2, 'Average'),
(3, 'Good'),
(4, 'Very Good'),
(5, 'Excellent');

-- Second-level tables

INSERT INTO tblSTAFF (staffTypeID, staffFname, staffLname, staffDOB, startDate, endDate)
VALUES 
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Barista'), 'John', 'Apfield', '1999-07-20', '2020-04-19', '2020-09-19'), 
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Barista'), 'Sharen', 'Apfield', '1999-09-21', '2020-04-19', '2020-08-26'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Store Manager'), 'Baumgarten', 'Fitzgerald', '1970-10-06', '2017-01-01', '2022-10-06'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Shift Manager'), 'Lauren', 'Schraut', '1989-06-23', '2021-07-29', '2023-12-01'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'District Manager'), 'Gordo', 'Lee', '2002-09-10', '2023-01-04', '2023-12-01'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Assistant Store Manager'), 'Bibir', 'Juan', '1980-06-11', '2021-11-06', '2023-12-01'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Barista'), 'Jane', 'Doe', '1995-03-15', '2022-01-20', '2022-08-15'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Shift Manager'), 'Michael', 'Smith', '1992-12-05', '2020-10-10', '2023-06-30'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Store Manager'), 'Emily', 'Johnson', '1985-08-28', '2019-05-12', '2022-11-30'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Barista'), 'Alex', 'Brown', '1990-05-18', '2021-03-10', '2022-09-30'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Assistant Store Manager'), 'Chris', 'Miller', '1983-09-02', '2020-08-15', '2023-05-20'),
((SELECT staffTypeID FROM tblSTAFF_TYPE WHERE staffTypeName = 'Shift Manager'), 'Megan', 'Taylor', '1998-11-14', '2022-02-28', '2023-10-31');

INSERT INTO tblSTORE (storeTypeID, storeName, storeAddress)
VALUES 
((SELECT storeTypeID FROM tblSTORE_TYPE WHERE storeTypeName = 'Standard'), 'Downtown Starbucks', '123 Main St'),
((SELECT storeTypeID FROM tblSTORE_TYPE WHERE storeTypeName = 'Drive-Thru'), 'Uptown Starbucks Drive-Thru', '456 Elm St'),
((SELECT storeTypeID FROM tblSTORE_TYPE WHERE storeTypeName = 'Reserve Bar'), 'Suburban Starbucks Reserve', '789 Oak St'),
((SELECT storeTypeID FROM tblSTORE_TYPE WHERE storeTypeName = 'Kiosk'), 'City Center Starbucks Kiosk', '101 Maple Ave'),
((SELECT storeTypeID FROM tblSTORE_TYPE WHERE storeTypeName = 'Licensed Store'), 'Mall Licensed Starbucks Store', '202 Pine Rd');
GO

INSERT INTO tblCUSTOMER (custFname, custLname, custDOB, custPhoneNumber, custEmail, totalRewardStars, custTypeID)
VALUES
    ('Sophia', 'Johnson', '1993-02-05', 5556667777, 'sophia.j@gmail.com', 120, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Ethan', 'Martin', '1987-09-18', 8889990000, 'ethan.martin@gmail.com', 80, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Ava', 'Hall', '1996-04-30', 7778889999, 'ava.hall@hotmail.com', 60, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member')),
    ('Mason', 'Ward', '2001-11-15', 3334445555, 'mason.w@gmail.com', 30, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member')),
    ('Scarlett', 'Young', '1984-08-22', 1112223333, 'scarlett.y@hotmail.com', 90, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Carter', 'Mitchell', '1999-06-08', 6667778888, 'carter.mitchell@gmail.com', 150, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Zoe', 'Bennett', '2005-03-25', 4445556666, 'zoe.b@ymail.com', 45, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member')),
    ('Gabriel', 'Reed', '1996-10-10', 2223334444, 'gabriel.r@gmail.com', 75, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member')),
    ('Lily', 'Lopez', '1998-12-05', 9990001111, 'lily.lopez@gmail.com', 110, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Jackson', 'Cruz', '1994-07-18', 6665554444, 'jackson.cruz@hotmail.com', 20, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member')),
    ('Chloe', 'Fisher', '2000-09-03', 3332221111, 'chloe.f@gmail.com', 130, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Member')),
    ('Oliver', 'Perry', '1989-05-12', 7778889999, 'oliver.p@ymail.com', 95, (SELECT custTypeID FROM tblCUSTOMER_TYPE WHERE custTypeName = 'Non-member'));

INSERT INTO tblPRODUCT (prodName, prodTypeID, price, prodDescr)
VALUES 
('Caffè Americano', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 2.99, 'Espresso shots with hot water for a rich and robust flavor.'),
('Caramel Macchiato', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 4.59, 'Espresso with vanilla syrup, milk, and caramel drizzle over ice.'),
('Flat White', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 3.79, 'Bold ristretto shots of espresso with steamed whole milk.'),
('Nitro Cold Brew', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 4.99, 'Cold brew coffee infused with nitrogen for a smooth and creamy texture.'),
('Iced Green Tea Lemonade', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 3.99, 'Iced green tea with a splash of lemonade for a refreshing beverage.'),
('Peppermint Mocha', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 5.29, 'Espresso and steamed milk with peppermint and chocolate flavors, topped with whipped cream and chocolate shavings.'),
('Hot Chocolate', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Drinks'), 4.29, 'Steamed milk with vanilla and mocha syrup, topped with whipped cream.'),
('Bacon, Gouda & Egg Sandwich', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Food'), 6.78, 'Sliced bacon, aged Gouda cheese, and a cage-free fried egg on an artisan roll.'),
('Classic Oatmeal', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Food'), 3.45, 'Steel-cut oats with your choice of nuts, dried fruits, and brown sugar.'),
('Spinach & Feta Wrap', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Food'), 5.49, 'Cage-free scrambled eggs, spinach, feta cheese, and tomatoes in a whole wheat wrap.'),
('Turkey Pesto Panini', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Food'), 7.99, 'Sliced turkey, provolone cheese, and basil pesto on a ciabatta roll.'),
('Reusable Cold Cup', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Merchandise'), 9.99, 'Eco-friendly reusable cold cup with a colorful straw for your favorite iced drinks.'),
('Starbucks Coffee Mug', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Merchandise'), 12.99, 'Classic Starbucks logo ceramic mug for your hot beverages.'),
('Stainless Steel Travel Tumbler', (SELECT prodTypeID FROM tblPRODUCT_TYPE WHERE prodTypeName = 'Merchandise'), 19.99, 'Durable stainless steel tumbler with a flip-top lid for on-the-go sipping.')

-- Populate more complicated tables with our synthetic transactions from lab7
EXEC wrapper_uspOrder
    @Run = 50
EXEC wrapper_uspINSERT_ORDER_PRODUCT
    @Run = 50
EXEC wrapper_uspINSERT_tblCART
    @Run = 50
EXEC wrapper_usp_INSERTReview
    @Run = 50

SELECT * FROM tblORDER
GO
SELECT * FROM tblORDER_PRODUCT
GO
SELECT * FROM tblCART
GO
SELECT * FROM tblREVIEW
GO
