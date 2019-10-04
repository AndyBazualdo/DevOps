-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 04, 2019 at 10:38 PM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

--
-- Database: `webservicedb`
--
CREATE DATABASE IF NOT EXISTS `webservicedb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `webservicedb`;

-- --------------------------------------------------------

--
-- Table structure for table `filestorage`
--

CREATE TABLE `filestorage` (
  `id` int(11) NOT NULL,
  `CHECKSUM` varchar(32) NOT NULL,
  `path` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `filestorage`
--
ALTER TABLE `filestorage`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `filestorage`
--
ALTER TABLE `filestorage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

--
-- Dumping data for table `filestorage`
--

INSERT INTO `filestorage` (`id`, `CHECKSUM`, `path`) VALUES
(10, '0a1b92ac25b7ea15f0bf5a72ee866ac4', 'C:\\Progra\\AWT04-WebService/temp/example.jpg'),
(11, '801e50085fee77f2203463a6378dc711', 'C:\\Progra\\AWT04-WebService/temp/Create spring project.pdf'),
(12, '526ed2fae30520c247c803c9d3d2387b', 'C:\\Progra\\AWT04-WebService/temp/music.mp3'),
(13, 'ed6e1cfd71e73f2cf79997616669fdfd', 'C:\\Progra\\AWT04-WebService/temp/example.avi'),
(14, 'f4b0a93fdbad0d5e3b826e55a28a382b', 'C:\\Progra\\AWT04-WebService/temp/music2.wav');
