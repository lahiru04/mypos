-- freepos-sqlserver.sql
-- Converted (basic) SQL Server schema + sample data derived from MySQL dump freepos.sql
-- This script creates tables, foreign keys and inserts sample rows.
-- Review types and constraints before running in production.

SET NOCOUNT ON;

-- Table: cashclosing
IF OBJECT_ID('dbo.cashclosing','U') IS NOT NULL DROP TABLE dbo.cashclosing;
CREATE TABLE dbo.cashclosing(
	id INT IDENTITY(1,1) PRIMARY KEY,
	closingbalance FLOAT NULL,
	[date] DATETIME NULL,
	expence FLOAT NULL,
	[note] NVARCHAR(200) NULL,
	[sale] FLOAT NULL,
	fk_user_in_cashclosing INT NULL
);

-- Table: data_change_log
IF OBJECT_ID('dbo.data_change_log','U') IS NOT NULL DROP TABLE dbo.data_change_log;
CREATE TABLE dbo.data_change_log(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[timestamp] DATETIME2 NOT NULL DEFAULT(GETDATE()),
	table_name NVARCHAR(20) NOT NULL,
	table_index INT NOT NULL,
	[user] INT NOT NULL,
	[action] NVARCHAR(100) NOT NULL DEFAULT(N'')
);

-- Table: financeaccount
IF OBJECT_ID('dbo.financeaccount','U') IS NOT NULL DROP TABLE dbo.financeaccount;
CREATE TABLE dbo.financeaccount(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[name] NVARCHAR(30) NULL,
	[type] NVARCHAR(50) NULL,
	fk_parent_in_financeaccount INT NULL
);

-- Table: financetransaction
IF OBJECT_ID('dbo.financetransaction','U') IS NOT NULL DROP TABLE dbo.financetransaction;
CREATE TABLE dbo.financetransaction(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[name] NVARCHAR(60) NULL,
	amount FLOAT NULL,
	[status] NVARCHAR(15) NULL,
	[date] DATETIME NOT NULL DEFAULT(GETDATE()),
	details NVARCHAR(200) NULL,
	fk_user_createdby_in_financetransaction INT NULL,
	fk_user_targetto_in_financetransaction INT NULL,
	fk_financeaccount_in_financetransaction INT NULL
);

-- Table: inventorylog
IF OBJECT_ID('dbo.inventorylog','U') IS NOT NULL DROP TABLE dbo.inventorylog;
CREATE TABLE dbo.inventorylog(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[date] DATETIME NOT NULL DEFAULT(GETDATE()),
	[note] NVARCHAR(200) NULL,
	quantity FLOAT NULL,
	fk_product_in_inventorylog INT NULL
);

-- Table: invoice
IF OBJECT_ID('dbo.invoice','U') IS NOT NULL DROP TABLE dbo.invoice;
CREATE TABLE dbo.invoice(
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	invoice_no NVARCHAR(20) NOT NULL,
	customer BIGINT NULL,
	created_at DATETIME NOT NULL DEFAULT(GETDATE()),
	amount DECIMAL(10,2) NOT NULL DEFAULT(0.00),
	added_by INT NOT NULL
);

-- Table: invoice_item
IF OBJECT_ID('dbo.invoice_item','U') IS NOT NULL DROP TABLE dbo.invoice_item;
CREATE TABLE dbo.invoice_item(
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	invoice_id BIGINT NOT NULL,
	product_id INT NOT NULL,
	qty INT NOT NULL
);

-- Table: invoice_payment
IF OBJECT_ID('dbo.invoice_payment','U') IS NOT NULL DROP TABLE dbo.invoice_payment;
CREATE TABLE dbo.invoice_payment(
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	invoice_id BIGINT NOT NULL,
	payment_type INT NOT NULL,
	payment_amount DECIMAL(10,2) NOT NULL DEFAULT(0.00),
	created_at DATETIME NOT NULL DEFAULT(GETDATE()),
	modyfied_at DATETIME NULL,
	deleted_at DATETIME NULL
);

-- Table: monthly_target
IF OBJECT_ID('dbo.monthly_target','U') IS NOT NULL DROP TABLE dbo.monthly_target;
CREATE TABLE dbo.monthly_target(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[month] DATETIME NOT NULL DEFAULT(GETDATE()),
	target DECIMAL(10,2) NOT NULL DEFAULT(0.00),
	created_at DATETIME NOT NULL DEFAULT(GETDATE()),
	created_by INT NOT NULL
);

-- Table: product
IF OBJECT_ID('dbo.product','U') IS NOT NULL DROP TABLE dbo.product;
CREATE TABLE dbo.product(
	id INT IDENTITY(1,1) PRIMARY KEY,
	barcode NVARCHAR(100) NULL,
	category NVARCHAR(50) NULL,
	carrycost FLOAT NULL,
	[discount] FLOAT NULL,
	[name] NVARCHAR(100) NULL,
	purchaseprice FLOAT NULL,
	purchaseactive BIT NULL,
	[quantity] FLOAT NULL,
	saleprice FLOAT NULL,
	saleactive BIT NULL,
	created_at DATETIME NOT NULL DEFAULT(GETDATE()),
	modified_at DATETIME NULL,
	deleted_at DATETIME NULL,
	[status] INT NOT NULL DEFAULT(1)
);

-- Table: productsalepurchase
IF OBJECT_ID('dbo.productsalepurchase','U') IS NOT NULL DROP TABLE dbo.productsalepurchase;
CREATE TABLE dbo.productsalepurchase(
	id INT IDENTITY(1,1) PRIMARY KEY,
	price FLOAT NULL,
	quantity FLOAT NULL,
	total FLOAT NULL,
	fk_product_in_productsalepurchase INT NULL,
	fk_financetransaction_in_productsalepurchase INT NULL
);

-- Table: productsub
IF OBJECT_ID('dbo.productsub','U') IS NOT NULL DROP TABLE dbo.productsub;
CREATE TABLE dbo.productsub(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fk_product_main_in_productsub INT NULL,
	fk_product_sub_in_productsub INT NULL,
	quantity FLOAT NULL
);

-- Table: softwaresetting
IF OBJECT_ID('dbo.softwaresetting','U') IS NOT NULL DROP TABLE dbo.softwaresetting;
CREATE TABLE dbo.softwaresetting(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[name] NVARCHAR(50) NULL,
	valuetype NVARCHAR(50) NULL,
	stringvalue NVARCHAR(100) NULL,
	intvalue INT NULL,
	boolvalue BIT NULL,
	floatvalue FLOAT NULL,
	datevalue DATETIME NULL
);

-- Table: [user]
IF OBJECT_ID('dbo.[user]','U') IS NOT NULL DROP TABLE dbo.[user];
CREATE TABLE dbo.[user](
	id INT IDENTITY(1,1) PRIMARY KEY,
	[address] NVARCHAR(200) NULL,
	[name] NVARCHAR(20) NULL,
	[password] NVARCHAR(20) NULL,
	username NVARCHAR(20) NULL,
	phone NVARCHAR(30) NULL,
	phone2 NVARCHAR(30) NULL,
	[role] NVARCHAR(20) NOT NULL DEFAULT(N'user')
);

-- Foreign keys
ALTER TABLE dbo.cashclosing ADD CONSTRAINT FK_cashclosing_user FOREIGN KEY(fk_user_in_cashclosing) REFERENCES dbo.[user](id);
ALTER TABLE dbo.financeaccount ADD CONSTRAINT FK_financeaccount_parent FOREIGN KEY(fk_parent_in_financeaccount) REFERENCES dbo.financeaccount(id);
ALTER TABLE dbo.financetransaction ADD CONSTRAINT FK_financetransaction_financeaccount FOREIGN KEY(fk_financeaccount_in_financetransaction) REFERENCES dbo.financeaccount(id);
ALTER TABLE dbo.financetransaction ADD CONSTRAINT FK_financetransaction_user_createdby FOREIGN KEY(fk_user_createdby_in_financetransaction) REFERENCES dbo.[user](id);
ALTER TABLE dbo.financetransaction ADD CONSTRAINT FK_financetransaction_user_targetto FOREIGN KEY(fk_user_targetto_in_financetransaction) REFERENCES dbo.[user](id);
ALTER TABLE dbo.inventorylog ADD CONSTRAINT FK_inventorylog_product FOREIGN KEY(fk_product_in_inventorylog) REFERENCES dbo.product(id);
ALTER TABLE dbo.productsalepurchase ADD CONSTRAINT FK_productsalepurchase_financetransaction FOREIGN KEY(fk_financetransaction_in_productsalepurchase) REFERENCES dbo.financetransaction(id);
ALTER TABLE dbo.productsalepurchase ADD CONSTRAINT FK_productsalepurchase_product FOREIGN KEY(fk_product_in_productsalepurchase) REFERENCES dbo.product(id);
ALTER TABLE dbo.productsub ADD CONSTRAINT FK_productsub_main FOREIGN KEY(fk_product_main_in_productsub) REFERENCES dbo.product(id);
ALTER TABLE dbo.productsub ADD CONSTRAINT FK_productsub_sub FOREIGN KEY(fk_product_sub_in_productsub) REFERENCES dbo.product(id);

-- Sample data inserts (preserve original ids using IDENTITY_INSERT)

-- financeaccount sample data
SET IDENTITY_INSERT dbo.financeaccount ON;
INSERT INTO dbo.financeaccount (id, [name], [type], fk_parent_in_financeaccount) VALUES
(101,N'bank',N'asset',NULL),
(102,N'cash',N'asset',NULL),
(103,N'petty cash',N'asset',NULL),
(104,N'undeposited fund',N'asset',NULL),
(105,N'account receivable',N'asset',NULL),
(106,N'fixed',N'asset',NULL),
(107,N'current',N'asset',NULL),
(108,N'other',N'asset',NULL),
(109,N'inventory',N'asset',NULL),
(201,N'notes payable',N'liabitity',NULL),
(202,N'account payable',N'liabitity',NULL),
(203,N'tax payable',N'liabitity',NULL),
(204,N'salary payable',N'liabitity',NULL),
(301,N'owner equity',N'equity',NULL),
(302,N'share capital',N'equity',NULL),
(401,N'pos sale',N'income',NULL),
(402,N'sale',N'income',NULL),
(403,N'service sale',N'income',NULL),
(404,N'other',N'income',NULL),
(405,N'inventory gain',N'income',NULL),
(501,N'operating',N'expence',NULL),
(502,N'salary',N'expence',NULL),
(503,N'paid tax',N'expence',NULL),
(504,N'cgs',N'expence',NULL),
(509,N'discount',N'expence',NULL),
(510,N'other',N'expence',NULL),
(511,N'inventory loss',N'expence',NULL),
(1011,N'meezan bank',N'asset',101),
(1012,N'faisal bank',N'asset',1012);
SET IDENTITY_INSERT dbo.financeaccount OFF;

-- financetransaction sample data
SET IDENTITY_INSERT dbo.financetransaction ON;
INSERT INTO dbo.financetransaction (id, [name], amount, [status], [date], details, fk_user_createdby_in_financetransaction, fk_user_targetto_in_financetransaction, fk_financeaccount_in_financetransaction) VALUES
(1,NULL,-8988,N'posted','2026-07-25 16:08:43',NULL,1,3,402),
(2,NULL,8988,N'posted','2026-07-25 16:08:43',NULL,1,3,102),
(3,NULL,7320,N'posted','2026-07-25 16:08:43',NULL,1,NULL,504),
(4,N'--inventory--on--sale--',-7320,N'posted','2026-07-25 16:08:43',NULL,1,NULL,109),
(5,NULL,-1317,N'posted','2026-07-25 17:19:21',NULL,1,3,402),
(6,NULL,1317,N'posted','2026-07-25 17:19:21',NULL,1,3,102),
(7,NULL,1204,N'posted','2026-07-25 17:19:21',NULL,1,NULL,504),
(8,N'--inventory--on--sale--',-1204,N'posted','2026-07-25 17:19:21',NULL,1,NULL,109),
(9,NULL,-784,N'posted','2026-07-26 23:51:55',NULL,1,3,402),
(10,NULL,784,N'posted','2026-07-26 23:51:55',NULL,1,3,102),
(11,NULL,742,N'posted','2026-07-26 23:51:55',NULL,1,NULL,504),
(12,N'--inventory--on--sale--',-742,N'posted','2026-07-26 23:51:55',NULL,1,NULL,109);
SET IDENTITY_INSERT dbo.financetransaction OFF;

-- inventorylog sample data
SET IDENTITY_INSERT dbo.inventorylog ON;
INSERT INTO dbo.inventorylog (id, [date], [note], quantity, fk_product_in_inventorylog) VALUES
(1,'2026-07-25 16:08:43',N'Detucted inventory on sale id 1',-6,1),
(2,'2026-07-25 17:19:21',N'Detucted inventory on sale id 5',-3,5),
(3,'2026-07-25 17:19:21',N'Detucted inventory on sale id 5',-1,8),
(4,'2026-07-25 17:19:21',N'Detucted inventory on sale id 5',-1,39),
(5,'2026-07-26 23:51:55',N'Detucted inventory on sale id 9',-5,1),
(6,'2026-07-26 23:51:55',N'Detucted inventory on sale id 9',-1,16);
SET IDENTITY_INSERT dbo.inventorylog OFF;

-- product sample data
SET IDENTITY_INSERT dbo.product ON;
INSERT INTO dbo.product (id, barcode, category, carrycost, [discount], [name], purchaseprice, purchaseactive, [quantity], saleprice, saleactive, created_at, modified_at, deleted_at, [status]) VALUES
(1,N'12322',N'1',20,2,N'Soap',120,1,489,150,1,'2026-07-26 11:18:43',NULL,NULL,1),
(2,N'100002',N'1',10,2,N'Fresh Milk 1L',90,1,120,110,1,'2026-07-26 11:18:43',NULL,NULL,1),
(3,N'100003',N'1',15,5,N'Brown Bread',70,1,80,95,1,'2026-07-26 11:18:43',NULL,NULL,1),
(4,N'100004',N'1',12,3,N'White Rice 5kg',450,1,40,520,1,'2026-07-26 11:18:43',NULL,NULL,1),
(5,N'100005',N'1',8,2,N'Sugar 1kg',130,1,97,150,1,'2026-07-26 11:18:43',NULL,NULL,1),
(6,N'100006',N'1',9,1,N'Salt 1kg',45,1,150,55,1,'2026-07-26 11:18:43',NULL,NULL,1),
(7,N'100007',N'1',18,4,N'Cooking Oil 1L',320,1,70,380,1,'2026-07-26 11:18:43',NULL,NULL,1),
(8,N'100008',N'1',20,5,N'Sunflower Oil 2L',650,1,49,740,1,'2026-07-26 11:18:43',NULL,NULL,1),
(9,N'100009',N'1',14,2,N'Black Tea 200g',180,1,90,225,1,'2026-07-26 11:18:43',NULL,NULL,1),
(10,N'100010',N'1',15,3,N'Coffee Classic 100g',250,1,75,310,1,'2026-07-26 11:18:43',NULL,NULL,1),
(11,N'100011',N'1',12,2,N'Corn Flakes 500g',280,1,60,340,1,'2026-07-26 11:18:43',NULL,NULL,1),
(12,N'100012',N'1',8,1,N'Oats 500g',190,1,65,235,1,'2026-07-26 11:18:43',NULL,NULL,1),
(13,N'100013',N'1',16,4,N'Tomato Ketchup 500ml',210,1,55,260,1,'2026-07-26 11:18:43',NULL,NULL,1),
(14,N'100014',N'1',10,2,N'Mayonnaise 250ml',170,1,45,210,1,'2026-07-26 11:18:43',NULL,NULL,1),
(15,N'100015',N'1',12,2,N'Peanut Butter 340g',310,1,40,375,1,'2026-07-26 11:18:43',NULL,NULL,1),
(16,N'100016',N'1',7,1,N'Instant Noodles Chicken',35,1,299,45,1,'2026-07-26 11:18:43',NULL,NULL,1),
(17,N'100017',N'1',7,1,N'Instant Noodles Beef',35,1,280,45,1,'2026-07-26 11:18:43',NULL,NULL,1),
(18,N'100018',N'1',6,1,N'Spaghetti Pasta 500g',140,1,100,175,1,'2026-07-26 11:18:43',NULL,NULL,1),
(19,N'100019',N'1',9,2,N'Macaroni Pasta 500g',145,1,85,180,1,'2026-07-26 11:18:43',NULL,NULL,1),
(20,N'100020',N'1',15,3,N'Cheddar Cheese 200g',340,1,35,410,1,'2026-07-26 11:18:43',NULL,NULL,1),
(21,N'100021',N'1',18,4,N'Butter Salted 250g',280,1,45,335,1,'2026-07-26 11:18:43',NULL,NULL,1),
(22,N'100022',N'1',8,2,N'Plain Yogurt 500ml',120,1,60,150,1,'2026-07-26 11:18:43',NULL,NULL,1),
(23,N'100023',N'1',10,2,N'Orange Juice 1L',180,1,70,220,1,'2026-07-26 11:18:43',NULL,NULL,1),
(24,N'100024',N'1',10,2,N'Apple Juice 1L',185,1,70,225,1,'2026-07-26 11:18:43',NULL,NULL,1),
(25,N'100025',N'1',9,2,N'Mineral Water 1.5L',45,1,200,60,1,'2026-07-26 11:18:43',NULL,NULL,1),
(26,N'100026',N'1',8,2,N'Sparkling Water',55,1,100,70,1,'2026-07-26 11:18:43',NULL,NULL,1),
(27,N'100027',N'1',14,3,N'Chocolate Cookies',120,1,110,155,1,'2026-07-26 11:18:43',NULL,NULL,1),
(28,N'100028',N'1',12,2,N'Vanilla Biscuits',90,1,130,120,1,'2026-07-26 11:18:43',NULL,NULL,1),
(29,N'100029',N'1',15,4,N'Potato Chips Salted',80,1,180,110,1,'2026-07-26 11:18:43',NULL,NULL,1),
(30,N'100030',N'1',15,4,N'Potato Chips BBQ',85,1,170,115,1,'2026-07-26 11:18:43',NULL,NULL,1),
(31,N'100031',N'1',18,5,N'Mixed Nuts 250g',360,1,45,430,1,'2026-07-26 11:18:43',NULL,NULL,1),
(32,N'100032',N'1',10,2,N'Raisins 200g',150,1,70,185,1,'2026-07-26 11:18:43',NULL,NULL,1),
(33,N'100033',N'1',11,2,N'Honey 500g',420,1,30,500,1,'2026-07-26 11:18:43',NULL,NULL,1),
(34,N'100034',N'1',9,2,N'Strawberry Jam 300g',180,1,60,220,1,'2026-07-26 11:18:43',NULL,NULL,1),
(35,N'100035',N'1',10,2,N'Grape Jam 300g',185,1,55,225,1,'2026-07-26 11:18:43',NULL,NULL,1),
(36,N'100036',N'1',12,3,N'Chicken Stock Cubes',75,1,140,95,1,'2026-07-26 11:18:43',NULL,NULL,1),
(37,N'100037',N'1',10,2,N'Black Pepper 100g',160,1,80,195,1,'2026-07-26 11:18:43',NULL,NULL,1),
(38,N'100038',N'1',10,2,N'Turmeric Powder 100g',95,1,90,120,1,'2026-07-26 11:18:43',NULL,NULL,1),
(39,N'100039',N'1',10,2,N'Chili Powder 100g',110,1,84,140,1,'2026-07-26 11:18:43',NULL,NULL,1),
(40,N'100040',N'1',11,2,N'Curry Powder 100g',105,1,90,135,1,'2026-07-26 11:18:43',NULL,NULL,1),
(41,N'100041',N'1',9,2,N'Green Peas Frozen',220,1,50,270,1,'2026-07-26 11:18:43',NULL,NULL,1),
(42,N'100042',N'1',10,2,N'Sweet Corn Frozen',210,1,45,255,1,'2026-07-26 11:18:43',NULL,NULL,1),
(43,N'100043',N'1',14,3,N'Ice Cream Vanilla',290,1,35,350,1,'2026-07-26 11:18:43',NULL,NULL,1),
(44,N'100044',N'1',14,3,N'Ice Cream Chocolate',295,1,35,355,1,'2026-07-26 11:18:43',NULL,NULL,1),
(45,N'100045',N'1',10,2,N'Dishwashing Liquid',140,1,75,175,1,'2026-07-26 11:18:43',NULL,NULL,1),
(46,N'100046',N'1',12,3,N'Laundry Detergent 1kg',330,1,60,395,1,'2026-07-26 11:18:43',NULL,NULL,1),
(47,N'100047',N'1',8,2,N'Toilet Paper Pack',180,1,90,220,1,'2026-07-26 11:18:43',NULL,NULL,1),
(48,N'100048',N'1',9,2,N'Paper Towels',160,1,70,195,1,'2026-07-26 11:18:43',NULL,NULL,1),
(49,N'100049',N'1',10,2,N'Toothpaste Fresh Mint',140,1,100,170,1,'2026-07-26 11:18:43',NULL,NULL,1),
(50,N'100050',N'1',11,2,N'Shampoo Herbal 400ml',290,1,65,345,1,'2026-07-26 11:18:43',NULL,NULL,1),
(51,N'100051',N'1',12,3,N'Bath Soap Lavender',70,1,200,95,1,'2026-07-26 11:18:43',NULL,NULL,1);
SET IDENTITY_INSERT dbo.product OFF;

-- productsalepurchase sample data
SET IDENTITY_INSERT dbo.productsalepurchase ON;
INSERT INTO dbo.productsalepurchase (id, price, quantity, total, fk_product_in_productsalepurchase, fk_financetransaction_in_productsalepurchase) VALUES
(1,1498,6,8988,1,1),
(2,148,3,444,5,5),
(3,735,1,735,8,5),
(4,138,1,138,39,5),
(5,148,5,740,1,9),
(6,44,1,44,16,9);
SET IDENTITY_INSERT dbo.productsalepurchase OFF;

-- user sample data
SET IDENTITY_INSERT dbo.[user] ON;
INSERT INTO dbo.[user] (id, [address], [name], [password], username, phone, phone2, [role]) VALUES
(1,NULL,N'admin',N'admin',N'admin',N'00000000000',NULL,N'admin'),
(2,N'',N'saman',N'saman',N'saman',N'',N'',N'user'),
(3,N'',N'sample ',N'',N'',N'',N'',N'customer'),
(4,N'',N'sample',N'',N'',N'',N'',N'vendor');
SET IDENTITY_INSERT dbo.[user] OFF;

-- Commit end
PRINT 'freepos-sqlserver.sql: creation completed.';
