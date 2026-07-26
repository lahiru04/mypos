-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 26, 2026 at 08:51 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `freepos`
--

-- --------------------------------------------------------

--
-- Table structure for table `cashclosing`
--

CREATE TABLE `cashclosing` (
  `id` int(11) NOT NULL,
  `closingbalance` float DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `expence` float DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `sale` float DEFAULT NULL,
  `fk_user_in_cashclosing` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `data_change_log`
--

CREATE TABLE `data_change_log` (
  `id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `table_name` varchar(20) NOT NULL,
  `table_index` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `action` varchar(100) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `financeaccount`
--

CREATE TABLE `financeaccount` (
  `id` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `fk_parent_in_financeaccount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `financeaccount`
--

INSERT INTO `financeaccount` (`id`, `name`, `type`, `fk_parent_in_financeaccount`) VALUES
(101, 'bank', 'asset', NULL),
(102, 'cash', 'asset', NULL),
(103, 'petty cash', 'asset', NULL),
(104, 'undeposited fund', 'asset', NULL),
(105, 'account receivable', 'asset', NULL),
(106, 'fixed', 'asset', NULL),
(107, 'current', 'asset', NULL),
(108, 'other', 'asset', NULL),
(109, 'inventory', 'asset', NULL),
(201, 'notes payable', 'liabitity', NULL),
(202, 'account payable', 'liabitity', NULL),
(203, 'tax payable', 'liabitity', NULL),
(204, 'salary payable', 'liabitity', NULL),
(301, 'owner equity', 'equity', NULL),
(302, 'share capital', 'equity', NULL),
(401, 'pos sale', 'income', NULL),
(402, 'sale', 'income', NULL),
(403, 'service sale', 'income', NULL),
(404, 'other', 'income', NULL),
(405, 'inventory gain', 'income', NULL),
(501, 'operating', 'expence', NULL),
(502, 'salary', 'expence', NULL),
(503, 'paid tax', 'expence', NULL),
(504, 'cgs', 'expence', NULL),
(509, 'discount', 'expence', NULL),
(510, 'other', 'expence', NULL),
(511, 'inventory loss', 'expence', NULL),
(1011, 'meezan bank', 'asset', 101),
(1012, 'faisal bank', 'asset', 101);

-- --------------------------------------------------------

--
-- Table structure for table `financetransaction`
--

CREATE TABLE `financetransaction` (
  `id` int(11) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `details` varchar(200) DEFAULT NULL,
  `fk_user_createdby_in_financetransaction` int(11) DEFAULT NULL,
  `fk_user_targetto_in_financetransaction` int(11) DEFAULT NULL,
  `fk_financeaccount_in_financetransaction` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `financetransaction`
--

INSERT INTO `financetransaction` (`id`, `name`, `amount`, `status`, `date`, `details`, `fk_user_createdby_in_financetransaction`, `fk_user_targetto_in_financetransaction`, `fk_financeaccount_in_financetransaction`) VALUES
(1, NULL, -8988, 'posted', '2026-07-25 16:08:43', NULL, 1, 3, 402),
(2, NULL, 8988, 'posted', '2026-07-25 16:08:43', NULL, 1, 3, 102),
(3, NULL, 7320, 'posted', '2026-07-25 16:08:43', NULL, 1, NULL, 504),
(4, '--inventory--on--sale--', -7320, 'posted', '2026-07-25 16:08:43', NULL, 1, NULL, 109),
(5, NULL, -1317, 'posted', '2026-07-25 17:19:21', NULL, 1, 3, 402),
(6, NULL, 1317, 'posted', '2026-07-25 17:19:21', NULL, 1, 3, 102),
(7, NULL, 1204, 'posted', '2026-07-25 17:19:21', NULL, 1, NULL, 504),
(8, '--inventory--on--sale--', -1204, 'posted', '2026-07-25 17:19:21', NULL, 1, NULL, 109),
(9, NULL, -784, 'posted', '2026-07-26 23:51:55', NULL, 1, 3, 402),
(10, NULL, 784, 'posted', '2026-07-26 23:51:55', NULL, 1, 3, 102),
(11, NULL, 742, 'posted', '2026-07-26 23:51:55', NULL, 1, NULL, 504),
(12, '--inventory--on--sale--', -742, 'posted', '2026-07-26 23:51:55', NULL, 1, NULL, 109);

-- --------------------------------------------------------

--
-- Table structure for table `inventorylog`
--

CREATE TABLE `inventorylog` (
  `id` int(11) NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `note` varchar(200) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `fk_product_in_inventorylog` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventorylog`
--

INSERT INTO `inventorylog` (`id`, `date`, `note`, `quantity`, `fk_product_in_inventorylog`) VALUES
(1, '2026-07-25 16:08:43', 'Detucted inventory on sale id 1', -6, 1),
(2, '2026-07-25 17:19:21', 'Detucted inventory on sale id 5', -3, 5),
(3, '2026-07-25 17:19:21', 'Detucted inventory on sale id 5', -1, 8),
(4, '2026-07-25 17:19:21', 'Detucted inventory on sale id 5', -1, 39),
(5, '2026-07-26 23:51:55', 'Detucted inventory on sale id 9', -5, 1),
(6, '2026-07-26 23:51:55', 'Detucted inventory on sale id 9', -1, 16);

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `id` int(20) NOT NULL,
  `invoice_no` varchar(20) NOT NULL,
  `customer` int(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_item`
--

CREATE TABLE `invoice_item` (
  `id` int(20) NOT NULL,
  `invoice_id` int(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_payment`
--

CREATE TABLE `invoice_payment` (
  `id` int(20) NOT NULL,
  `invoice_id` int(20) NOT NULL,
  `payment_type` int(11) NOT NULL,
  `payment_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modyfied_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monthly_target`
--

CREATE TABLE `monthly_target` (
  `id` int(11) NOT NULL,
  `month` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `target` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `barcode` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `carrycost` float DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `purchaseprice` float DEFAULT NULL,
  `purchaseactive` bit(1) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `saleprice` float DEFAULT NULL,
  `saleactive` bit(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '1 - active , 0 - inactive'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `barcode`, `category`, `carrycost`, `discount`, `name`, `purchaseprice`, `purchaseactive`, `quantity`, `saleprice`, `saleactive`, `created_at`, `modified_at`, `deleted_at`, `status`) VALUES
(1, '12322', '1', 20, 2, 'Soap', 120, b'1', 489, 150, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(2, '100002', '1', 10, 2, 'Fresh Milk 1L', 90, b'1', 120, 110, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(3, '100003', '1', 15, 5, 'Brown Bread', 70, b'1', 80, 95, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(4, '100004', '1', 12, 3, 'White Rice 5kg', 450, b'1', 40, 520, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(5, '100005', '1', 8, 2, 'Sugar 1kg', 130, b'1', 97, 150, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(6, '100006', '1', 9, 1, 'Salt 1kg', 45, b'1', 150, 55, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(7, '100007', '1', 18, 4, 'Cooking Oil 1L', 320, b'1', 70, 380, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(8, '100008', '1', 20, 5, 'Sunflower Oil 2L', 650, b'1', 49, 740, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(9, '100009', '1', 14, 2, 'Black Tea 200g', 180, b'1', 90, 225, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(10, '100010', '1', 15, 3, 'Coffee Classic 100g', 250, b'1', 75, 310, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(11, '100011', '1', 12, 2, 'Corn Flakes 500g', 280, b'1', 60, 340, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(12, '100012', '1', 8, 1, 'Oats 500g', 190, b'1', 65, 235, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(13, '100013', '1', 16, 4, 'Tomato Ketchup 500ml', 210, b'1', 55, 260, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(14, '100014', '1', 10, 2, 'Mayonnaise 250ml', 170, b'1', 45, 210, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(15, '100015', '1', 12, 2, 'Peanut Butter 340g', 310, b'1', 40, 375, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(16, '100016', '1', 7, 1, 'Instant Noodles Chicken', 35, b'1', 299, 45, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(17, '100017', '1', 7, 1, 'Instant Noodles Beef', 35, b'1', 280, 45, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(18, '100018', '1', 6, 1, 'Spaghetti Pasta 500g', 140, b'1', 100, 175, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(19, '100019', '1', 9, 2, 'Macaroni Pasta 500g', 145, b'1', 85, 180, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(20, '100020', '1', 15, 3, 'Cheddar Cheese 200g', 340, b'1', 35, 410, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(21, '100021', '1', 18, 4, 'Butter Salted 250g', 280, b'1', 45, 335, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(22, '100022', '1', 8, 2, 'Plain Yogurt 500ml', 120, b'1', 60, 150, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(23, '100023', '1', 10, 2, 'Orange Juice 1L', 180, b'1', 70, 220, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(24, '100024', '1', 10, 2, 'Apple Juice 1L', 185, b'1', 70, 225, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(25, '100025', '1', 9, 2, 'Mineral Water 1.5L', 45, b'1', 200, 60, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(26, '100026', '1', 8, 2, 'Sparkling Water', 55, b'1', 100, 70, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(27, '100027', '1', 14, 3, 'Chocolate Cookies', 120, b'1', 110, 155, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(28, '100028', '1', 12, 2, 'Vanilla Biscuits', 90, b'1', 130, 120, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(29, '100029', '1', 15, 4, 'Potato Chips Salted', 80, b'1', 180, 110, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(30, '100030', '1', 15, 4, 'Potato Chips BBQ', 85, b'1', 170, 115, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(31, '100031', '1', 18, 5, 'Mixed Nuts 250g', 360, b'1', 45, 430, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(32, '100032', '1', 10, 2, 'Raisins 200g', 150, b'1', 70, 185, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(33, '100033', '1', 11, 2, 'Honey 500g', 420, b'1', 30, 500, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(34, '100034', '1', 9, 2, 'Strawberry Jam 300g', 180, b'1', 60, 220, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(35, '100035', '1', 10, 2, 'Grape Jam 300g', 185, b'1', 55, 225, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(36, '100036', '1', 12, 3, 'Chicken Stock Cubes', 75, b'1', 140, 95, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(37, '100037', '1', 10, 2, 'Black Pepper 100g', 160, b'1', 80, 195, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(38, '100038', '1', 10, 2, 'Turmeric Powder 100g', 95, b'1', 90, 120, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(39, '100039', '1', 10, 2, 'Chili Powder 100g', 110, b'1', 84, 140, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(40, '100040', '1', 11, 2, 'Curry Powder 100g', 105, b'1', 90, 135, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(41, '100041', '1', 9, 2, 'Green Peas Frozen', 220, b'1', 50, 270, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(42, '100042', '1', 10, 2, 'Sweet Corn Frozen', 210, b'1', 45, 255, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(43, '100043', '1', 14, 3, 'Ice Cream Vanilla', 290, b'1', 35, 350, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(44, '100044', '1', 14, 3, 'Ice Cream Chocolate', 295, b'1', 35, 355, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(45, '100045', '1', 10, 2, 'Dishwashing Liquid', 140, b'1', 75, 175, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(46, '100046', '1', 12, 3, 'Laundry Detergent 1kg', 330, b'1', 60, 395, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(47, '100047', '1', 8, 2, 'Toilet Paper Pack', 180, b'1', 90, 220, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(48, '100048', '1', 9, 2, 'Paper Towels', 160, b'1', 70, 195, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(49, '100049', '1', 10, 2, 'Toothpaste Fresh Mint', 140, b'1', 100, 170, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(50, '100050', '1', 11, 2, 'Shampoo Herbal 400ml', 290, b'1', 65, 345, b'1', '2026-07-26 11:18:43', NULL, NULL, 1),
(51, '100051', '1', 12, 3, 'Bath Soap Lavender', 70, b'1', 200, 95, b'1', '2026-07-26 11:18:43', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `productsalepurchase`
--

CREATE TABLE `productsalepurchase` (
  `id` int(11) NOT NULL,
  `price` float DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `total` float DEFAULT NULL,
  `fk_product_in_productsalepurchase` int(11) DEFAULT NULL,
  `fk_financetransaction_in_productsalepurchase` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `productsalepurchase`
--

INSERT INTO `productsalepurchase` (`id`, `price`, `quantity`, `total`, `fk_product_in_productsalepurchase`, `fk_financetransaction_in_productsalepurchase`) VALUES
(1, 1498, 6, 8988, 1, 1),
(2, 148, 3, 444, 5, 5),
(3, 735, 1, 735, 8, 5),
(4, 138, 1, 138, 39, 5),
(5, 148, 5, 740, 1, 9),
(6, 44, 1, 44, 16, 9);

-- --------------------------------------------------------

--
-- Table structure for table `productsub`
--

CREATE TABLE `productsub` (
  `id` int(11) NOT NULL,
  `fk_product_main_in_productsub` int(11) DEFAULT NULL,
  `fk_product_sub_in_productsub` int(11) DEFAULT NULL,
  `quantity` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `softwaresetting`
--

CREATE TABLE `softwaresetting` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `valuetype` varchar(50) DEFAULT NULL,
  `stringvalue` varchar(100) DEFAULT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `boolvalue` bit(1) DEFAULT NULL,
  `floatvalue` float DEFAULT NULL,
  `datevalue` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `address` varchar(200) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `phone2` varchar(30) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `address`, `name`, `password`, `username`, `phone`, `phone2`, `role`) VALUES
(1, NULL, 'admin', 'admin', 'admin', '00000000000', NULL, 'admin'),
(2, '', 'saman', 'saman', 'saman', '', '', 'user'),
(3, '', 'sample ', '', '', '', '', 'customer'),
(4, '', 'sample', '', '', '', '', 'vendor');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cashclosing`
--
ALTER TABLE `cashclosing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_in_cashclosing` (`fk_user_in_cashclosing`);

--
-- Indexes for table `data_change_log`
--
ALTER TABLE `data_change_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `financeaccount`
--
ALTER TABLE `financeaccount`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_parent_in_financeaccount` (`fk_parent_in_financeaccount`);

--
-- Indexes for table `financetransaction`
--
ALTER TABLE `financetransaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_createdby_in_financetransaction` (`fk_user_createdby_in_financetransaction`),
  ADD KEY `fk_user_targetto_in_financetransaction` (`fk_user_targetto_in_financetransaction`),
  ADD KEY `fk_financeaccount_in_financetransaction` (`fk_financeaccount_in_financetransaction`);

--
-- Indexes for table `inventorylog`
--
ALTER TABLE `inventorylog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_in_inventorylog` (`fk_product_in_inventorylog`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoice_item`
--
ALTER TABLE `invoice_item`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoice_payment`
--
ALTER TABLE `invoice_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `monthly_target`
--
ALTER TABLE `monthly_target`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `productsalepurchase`
--
ALTER TABLE `productsalepurchase`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_in_productsalepurchase` (`fk_product_in_productsalepurchase`),
  ADD KEY `fk_financetransaction_in_productsalepurchase` (`fk_financetransaction_in_productsalepurchase`);

--
-- Indexes for table `productsub`
--
ALTER TABLE `productsub`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_main_in_productsub` (`fk_product_main_in_productsub`),
  ADD KEY `fk_product_sub_in_productsub` (`fk_product_sub_in_productsub`);

--
-- Indexes for table `softwaresetting`
--
ALTER TABLE `softwaresetting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cashclosing`
--
ALTER TABLE `cashclosing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `data_change_log`
--
ALTER TABLE `data_change_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `financeaccount`
--
ALTER TABLE `financeaccount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1013;

--
-- AUTO_INCREMENT for table `financetransaction`
--
ALTER TABLE `financetransaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `inventorylog`
--
ALTER TABLE `inventorylog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_item`
--
ALTER TABLE `invoice_item`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_payment`
--
ALTER TABLE `invoice_payment`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monthly_target`
--
ALTER TABLE `monthly_target`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `productsalepurchase`
--
ALTER TABLE `productsalepurchase`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `productsub`
--
ALTER TABLE `productsub`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `softwaresetting`
--
ALTER TABLE `softwaresetting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cashclosing`
--
ALTER TABLE `cashclosing`
  ADD CONSTRAINT `fk_user_in_cashclosing` FOREIGN KEY (`fk_user_in_cashclosing`) REFERENCES `user` (`id`);

--
-- Constraints for table `financeaccount`
--
ALTER TABLE `financeaccount`
  ADD CONSTRAINT `fk_parent_in_financeaccount` FOREIGN KEY (`fk_parent_in_financeaccount`) REFERENCES `financeaccount` (`id`);

--
-- Constraints for table `financetransaction`
--
ALTER TABLE `financetransaction`
  ADD CONSTRAINT `fk_financeaccount_in_financetransaction` FOREIGN KEY (`fk_financeaccount_in_financetransaction`) REFERENCES `financeaccount` (`id`),
  ADD CONSTRAINT `fk_user_createdby_in_financetransaction` FOREIGN KEY (`fk_user_createdby_in_financetransaction`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_user_targetto_in_financetransaction` FOREIGN KEY (`fk_user_targetto_in_financetransaction`) REFERENCES `user` (`id`);

--
-- Constraints for table `inventorylog`
--
ALTER TABLE `inventorylog`
  ADD CONSTRAINT `fk_product_in_inventorylog` FOREIGN KEY (`fk_product_in_inventorylog`) REFERENCES `product` (`id`);

--
-- Constraints for table `productsalepurchase`
--
ALTER TABLE `productsalepurchase`
  ADD CONSTRAINT `fk_financetransaction_in_productsalepurchase` FOREIGN KEY (`fk_financetransaction_in_productsalepurchase`) REFERENCES `financetransaction` (`id`),
  ADD CONSTRAINT `fk_product_in_productsalepurchase` FOREIGN KEY (`fk_product_in_productsalepurchase`) REFERENCES `product` (`id`);

--
-- Constraints for table `productsub`
--
ALTER TABLE `productsub`
  ADD CONSTRAINT `fk_product_main_in_productsub` FOREIGN KEY (`fk_product_main_in_productsub`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `fk_product_sub_in_productsub` FOREIGN KEY (`fk_product_sub_in_productsub`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
