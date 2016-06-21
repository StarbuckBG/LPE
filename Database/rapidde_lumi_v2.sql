-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Jun 21, 2016 at 10:16 AM
-- Server version: 5.5.49-37.9-log
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `rapidde_lumi_v2`
--

-- --------------------------------------------------------

--
-- Table structure for table `appliances`
--

CREATE TABLE IF NOT EXISTS `appliances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playground_id` int(11) NOT NULL,
  `qrcode` varchar(255) COLLATE cp1251_bulgarian_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `playground_id` (`playground_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `appliances`
--

INSERT INTO `appliances` (`id`, `playground_id`, `qrcode`) VALUES
(1, 1, 'Appliance1_Playground_Energy');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE IF NOT EXISTS `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE cp1251_bulgarian_ci NOT NULL,
  `rate` double NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `rate`, `active`) VALUES
(1, 'Imperia Online', 1.92, 1);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `appliance_id` int(11) NOT NULL,
  `points` double NOT NULL,
  `intensity` double NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appliance_id` (`appliance_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=13 ;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `user_id`, `appliance_id`, `points`, `intensity`, `start_time`, `end_time`) VALUES
(1, 2, 1, 1200, 5, '2016-06-18 11:36:30', '2016-06-18 12:00:00'),
(2, 2, 1, 800, 4, '2016-06-19 00:00:00', '2016-06-19 01:00:00'),
(3, 2, 1, 800, 3, '2016-06-18 00:00:00', '2016-06-18 02:00:00'),
(4, 2, 1, 900, 2, '2016-06-06 00:00:00', '2016-06-07 00:00:00'),
(5, 2, 1, 1900, 3.4, '2016-06-14 00:00:00', '2016-06-15 00:00:00'),
(6, 2, 1, 600, 3.4, '2016-06-18 00:00:12', '2016-06-18 00:00:16'),
(7, 2, 1, 200, 4, '2016-06-19 02:00:00', '2016-06-19 02:00:00'),
(8, 1, 1, 1200, 2, '2016-06-19 21:53:28', '2016-06-19 21:53:28'),
(9, 1, 1, 1200, 2, '2016-06-19 21:54:12', '2016-06-19 21:54:12'),
(10, 1, 1, 1200, 2, '2016-06-19 21:55:59', '2016-06-19 21:55:59'),
(12, 1, 1, 1200, 2, '2016-06-19 21:57:00', '2016-06-19 21:57:00');

--
-- Triggers `logs`
--
DROP TRIGGER IF EXISTS `update_user_points`;
DELIMITER //
CREATE TRIGGER `update_user_points` AFTER INSERT ON `logs`
 FOR EACH ROW UPDATE users
 SET users.points_balance = users.points_balance + new.points
WHERE users.id like new.user_id
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `playgrounds`
--

CREATE TABLE IF NOT EXISTS `playgrounds` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE cp1251_bulgarian_ci NOT NULL,
  `longitude` varchar(255) COLLATE cp1251_bulgarian_ci NOT NULL,
  `latitude` varchar(255) COLLATE cp1251_bulgarian_ci NOT NULL,
  `description` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `playgrounds`
--

INSERT INTO `playgrounds` (`id`, `name`, `longitude`, `latitude`, `description`, `active`) VALUES
(1, 'Sofia Tech Park', '23.37318', '42.669823', 'Tsarigrasko 61', 1);

-- --------------------------------------------------------

--
-- Table structure for table `transfer`
--

CREATE TABLE IF NOT EXISTS `transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `user_id` bigint(11) NOT NULL,
  `points` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `transfer`
--

INSERT INTO `transfer` (`id`, `company_id`, `user_id`, `points`) VALUES
(1, 1, 1, 500),
(2, 1, 1, 200);

--
-- Triggers `transfer`
--
DROP TRIGGER IF EXISTS `update_user_points_after_transfer`;
DELIMITER //
CREATE TRIGGER `update_user_points_after_transfer` AFTER INSERT ON `transfer`
 FOR EACH ROW UPDATE users
 SET users.points_balance = users.points_balance - new.points
WHERE users.id like new.user_id
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `facebookId` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `email` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `password` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `city` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `country` varchar(255) COLLATE cp1251_bulgarian_ci DEFAULT NULL,
  `points_balance` float DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `facebookId` (`facebookId`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bulgarian_ci AUTO_INCREMENT=5 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `facebookId`, `email`, `password`, `city`, `country`, `points_balance`) VALUES
(1, 'starbuck', NULL, 'martinkuvandzhiev@gmail.com', '$2y$10$gqqUumDpozp0aI1IIizy6.E1UnqYVTYs.Vys9lH7QMkdGQhU92QXy', NULL, NULL, 1000),
(2, 'starbuck123', '123123123', NULL, '$2y$10$JYR8K0xv3B7Ei1h76v3EDe39Zzh.b5hcHZcqyGZm/bpDU8IkvagDW', NULL, NULL, 0),
(3, 'lumiUser1', NULL, 'lumiUser1@playgroundenergy.com', '$2y$10$QhNQaKG028eA2FP1ry7mduarN2AMO1oVWUDMQGLydb/bZPrJAZs4y', NULL, NULL, 0),
(4, 'starbuckk', '123123126', NULL, '$2y$10$0b.9qQ20EeuuS/gBndSBJOzKuWHcLnyrSGGOnUoGMizlbTkB7zbrS', NULL, NULL, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appliances`
--
ALTER TABLE `appliances`
  ADD CONSTRAINT `appliances_ibfk_1` FOREIGN KEY (`playground_id`) REFERENCES `playgrounds` (`id`);

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`appliance_id`) REFERENCES `appliances` (`id`),
  ADD CONSTRAINT `logs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `transfer`
--
ALTER TABLE `transfer`
  ADD CONSTRAINT `transfer_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `transfer_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
