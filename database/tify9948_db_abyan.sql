-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 03, 2026 at 11:15 PM
-- Server version: 10.11.14-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tify9948_db_abyan`
--

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `level` varchar(10) NOT NULL DEFAULT 'N5',
  `image_asset` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `title`, `level`, `image_asset`, `created_at`) VALUES
(1, 'Hiragana Dasar', 'N5', 'assets/images/hiragana.png', '2026-02-03 21:57:16'),
(2, 'Katakana Dasar', 'N5', 'assets/images/katakana.png', '2026-02-03 21:57:16'),
(3, 'Kata Kerja Sehari-hari', 'N5', 'assets/images/verbs.jpg', '2026-02-03 21:57:16'),
(4, 'Salam & Ungkapan', 'N5', 'assets/images/greetings.png', '2026-02-03 22:35:48'),
(5, 'Angka', 'N5', 'assets/images/numbers.png', '2026-02-03 22:35:48');

-- --------------------------------------------------------

--
-- Table structure for table `progress`
--

CREATE TABLE `progress` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `last_seen` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `progress`
--

INSERT INTO `progress` (`id`, `user_id`, `lesson_id`, `points`, `last_seen`) VALUES
(1, 3, 1, 30, '2026-02-03 22:28:01'),
(3, 1, 1, 20, '2026-02-03 23:08:05'),
(8, 1, 5, 20, '2026-02-03 23:08:37'),
(9, 1, 3, 40, '2026-02-03 23:09:08');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'Abyan', 'abyan@gmail.com', '$2y$10$ibxTaHhO/1Pl7nrYxLqFXOQB8bpftQTe.e.FwbBoZnKk6vDp86rNC', '2026-02-03 22:20:12'),
(3, 'nandana', 'nandana@gmail.com', '$2y$10$JSfuPZxgqRt8jITUObSjeew0n8n76HwLguJIbIvHj1cOb5FyZRLkG', '2026-02-03 22:27:32');

-- --------------------------------------------------------

--
-- Table structure for table `vocab`
--

CREATE TABLE `vocab` (
  `id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `jp` varchar(100) NOT NULL,
  `romaji` varchar(100) NOT NULL,
  `idn` varchar(150) NOT NULL,
  `example` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vocab`
--

INSERT INTO `vocab` (`id`, `lesson_id`, `jp`, `romaji`, `idn`, `example`) VALUES
(1, 1, 'あ', 'a', 'a', 'あ adalah hiragana.'),
(2, 1, 'い', 'i', 'i', 'い adalah hiragana.'),
(3, 2, 'ア', 'a', 'a', 'ア adalah katakana.'),
(4, 2, 'イ', 'i', 'i', 'イ adalah katakana.'),
(5, 3, 'たべる', 'taberu', 'makan', 'ごはんをたべる。'),
(6, 3, 'のむ', 'nomu', 'minum', 'みずをのむ。'),
(7, 3, 'いく', 'iku', 'pergi', 'がっこうにいく。'),
(8, 3, 'くる', 'kuru', 'datang', 'ともだちがくる。'),
(9, 3, 'みる', 'miru', 'melihat', 'えいがをみる。'),
(10, 3, 'きく', 'kiku', 'mendengar/bertanya', 'おんがくをきく。'),
(11, 3, 'はなす', 'hanasu', 'berbicara', 'にほんごをはなす。'),
(12, 3, 'よむ', 'yomu', 'membaca', 'ほんをよむ。'),
(13, 3, 'かく', 'kaku', 'menulis', 'なまえをかく。'),
(14, 3, 'かう', 'kau', 'membeli', 'パンをかう。'),
(15, 3, 'うる', 'uru', 'menjual', 'みせでうる。'),
(16, 3, 'ねる', 'neru', 'tidur', 'はやくねる。'),
(17, 3, 'おきる', 'okiru', 'bangun', '6じにおきる。'),
(18, 3, 'べんきょうする', 'benkyou suru', 'belajar', 'にほんごをべんきょうする。'),
(19, 3, 'しごとする', 'shigoto suru', 'bekerja', 'まいにちしごとする。'),
(20, 3, 'あそぶ', 'asobu', 'bermain', 'こうえんであそぶ。'),
(21, 3, 'つかう', 'tsukau', 'menggunakan', 'スマホをつかう。'),
(22, 3, 'つくる', 'tsukuru', 'membuat', 'りょうりをつくる。'),
(23, 3, 'あう', 'au', 'bertemu', 'ともだちにあう。'),
(24, 3, 'まつ', 'matsu', 'menunggu', 'えきでまつ。'),
(25, 3, 'あるく', 'aruku', 'berjalan', 'みちをあるく。'),
(26, 3, 'はしる', 'hashiru', 'berlari', 'こうえんをはしる。'),
(27, 4, 'おはよう', 'ohayou', 'selamat pagi', 'おはよう！'),
(28, 4, 'おはようございます', 'ohayou gozaimasu', 'selamat pagi (formal)', 'おはようございます。'),
(29, 4, 'こんにちは', 'konnichiwa', 'halo/selamat siang', 'こんにちは。'),
(30, 4, 'こんばんは', 'konbanwa', 'selamat malam', 'こんばんは。'),
(31, 4, 'おやすみ', 'oyasumi', 'selamat tidur', 'おやすみ。'),
(32, 4, 'おやすみなさい', 'oyasuminasai', 'selamat tidur (formal)', 'おやすみなさい。'),
(33, 4, 'ありがとう', 'arigatou', 'terima kasih', 'ありがとう！'),
(34, 4, 'ありがとうございます', 'arigatou gozaimasu', 'terima kasih (formal)', 'ありがとうございます。'),
(35, 4, 'すみません', 'sumimasen', 'permisi/maaf', 'すみません。'),
(36, 4, 'ごめんなさい', 'gomennasai', 'maaf', 'ごめんなさい。'),
(37, 4, 'はい', 'hai', 'ya', 'はい。'),
(38, 4, 'いいえ', 'iie', 'tidak', 'いいえ。'),
(39, 4, 'お願いします', 'onegaishimasu', 'tolong', 'お願いします。'),
(40, 4, 'だいじょうぶ', 'daijoubu', 'tidak apa-apa', 'だいじょうぶです。'),
(41, 4, 'わかりません', 'wakarimasen', 'tidak mengerti', 'すみません、わかりません。'),
(42, 5, 'いち', 'ichi', 'satu', 'いち'),
(43, 5, 'に', 'ni', 'dua', 'に'),
(44, 5, 'さん', 'san', 'tiga', 'さん'),
(45, 5, 'よん', 'yon', 'empat', 'よん'),
(46, 5, 'ご', 'go', 'lima', 'ご'),
(47, 5, 'ろく', 'roku', 'enam', 'ろく'),
(48, 5, 'なな', 'nana', 'tujuh', 'なな'),
(49, 5, 'はち', 'hachi', 'delapan', 'はち'),
(50, 5, 'きゅう', 'kyuu', 'sembilan', 'きゅう'),
(51, 5, 'じゅう', 'juu', 'sepuluh', 'じゅう');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `progress`
--
ALTER TABLE `progress`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_lesson` (`user_id`,`lesson_id`),
  ADD KEY `lesson_id` (`lesson_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vocab`
--
ALTER TABLE `vocab`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lesson_id` (`lesson_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `progress`
--
ALTER TABLE `progress`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vocab`
--
ALTER TABLE `vocab`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `progress`
--
ALTER TABLE `progress`
  ADD CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `progress_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vocab`
--
ALTER TABLE `vocab`
  ADD CONSTRAINT `vocab_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
