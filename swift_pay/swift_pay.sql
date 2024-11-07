-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2024 at 07:04 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `swift_pay`
--

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` enum('credit','debit') DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `recipient_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `type`, `amount`, `description`, `status`, `created_at`, `recipient_id`) VALUES
(1, 19, 'debit', 5000.00, 'yeessir', 'completed', '2024-10-28 08:41:58', 5),
(2, 5, 'credit', 5000.00, 'yeessir', 'completed', '2024-10-28 08:41:58', 19),
(3, 19, 'debit', 4500.00, 'yes', 'completed', '2024-10-28 08:43:55', 4),
(4, 4, 'credit', 4500.00, 'yes', 'completed', '2024-10-28 08:43:55', 19),
(5, 20, 'debit', 200.00, 'salary', 'completed', '2024-10-28 08:49:12', 5),
(6, 5, 'credit', 200.00, 'salary', 'completed', '2024-10-28 08:49:12', 20);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `balance` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `balance`) VALUES
(1, 'Tarindeka', 'kmjofe@gmail.com', '$2y$10$7eTUSh9eiwbt1fDZz594ce0Ww48zU9vNCcE.ptJ4fOhCZlr7DDJMy', 0.00),
(2, 'John Doe', 'johndoe@example.com', NULL, 100.00),
(3, 'Jane Smith', 'janesmith@example.com', NULL, 150.50),
(4, 'Alice Johnson', 'alice.johnson@example.com', NULL, 4700.75),
(5, 'Bob Brown', 'bob.brown@example.com', NULL, 5500.00),
(6, 'Charlie White', 'charlie.white@example.com', NULL, 250.25),
(7, 'Diana Prince', 'diana.prince@example.com', NULL, 400.50),
(8, 'Ethan Hunt', 'ethan.hunt@example.com', NULL, 50.00),
(9, 'Fiona Gallagher', 'fiona.gallagher@example.com', NULL, 75.25),
(10, 'George Clooney', 'george.clooney@example.com', NULL, 60.10),
(11, 'Hannah Montana', 'hannah.montana@example.com', NULL, 90.90),
(12, 'deus', 'deusb@gmail.com', '$2y$10$eW/c4bmtQJVMJqnvaSQkWukYSGtZ1jqZKaZCVRg/6kDzhej6UPDB.', 0.00),
(19, 'deus', 'deus@gmail.com', '$2y$10$g0ZNUpxZyo7GxqBjNrf0tuHjq7twf6K/ZDbp64rKmNwNyK1rwBn7q', 49990500.00),
(20, 'Deus', 'deu@gmail.com', '$2y$10$sp5gQlPL0O87yvMdyMdVxes9tfncjpaG4UM163qvxespr7XnUXmky', 49999800.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
