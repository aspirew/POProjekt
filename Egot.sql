-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jan 02, 2021 at 04:57 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `egot`
--

-- --------------------------------------------------------

--
-- Table structure for table `Odbywanie`
--

CREATE TABLE `Odbywanie` (
  `ID` int(10) NOT NULL,
  `Przejscie` int(10) NOT NULL,
  `Przodownik` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `Odcinek`
--

CREATE TABLE `Odcinek` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL,
  `PunktPoczatkowy` int(10) NOT NULL,
  `PunktKoncowy` int(10) NOT NULL,
  `Teren` int(10) NOT NULL,
  `Dlugosc` int(10) UNSIGNED NOT NULL,
  `Punktacja` int(10) UNSIGNED NOT NULL,
  `PunktacjaOdKonca` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Odcinek`
--

INSERT INTO `Odcinek` (`ID`, `Nazwa`, `PunktPoczatkowy`, `PunktKoncowy`, `Teren`, `Dlugosc`, `Punktacja`, `PunktacjaOdKonca`) VALUES
(1, 'AB', 1, 2, 1, 30, 14, 20),
(4, 'BC', 2, 3, 1, 29, 16, 10),
(5, 'AC', 1, 3, 1, 28, 2, 1),
(6, 'CD', 3, 4, 1, 27, 18, 20),
(7, 'DE', 4, 5, 1, 26, 20, 30),
(8, 'EF', 5, 6, 1, 25, 16, 14),
(9, 'CF', 3, 6, 1, 24, 10, 8),
(10, 'FJ', 6, 10, 1, 23, 11, 14),
(11, 'JI', 10, 9, 1, 22, 10, 20),
(12, 'JH', 10, 8, 1, 21, 11, 11),
(13, 'IH', 9, 8, 1, 20, 30, 30),
(14, 'JG', 10, 7, 1, 21, 16, 12),
(15, 'GH', 7, 8, 1, 22, 14, 20),
(16, 'GK', 7, 11, 1, 23, 10, 10),
(17, 'KL', 11, 12, 1, 24, 1, 11),
(18, 'LM', 12, 13, 1, 25, 12, 12),
(19, 'MK', 13, 11, 1, 26, 13, 14),
(20, 'LN', 12, 14, 1, 27, 13, 14),
(21, 'NA', 14, 1, 1, 28, 10, 12),
(23, 'JP2GMD', 1, 14, 1, 2137, 21, 37);

--
-- Triggers `Odcinek`
--
DELIMITER $$
CREATE TRIGGER `update_max_sum_of_points_for_przejscia` AFTER UPDATE ON `Odcinek` FOR EACH ROW BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE zmienione_przejscie INT;
	DECLARE zmienione_przejscia CURSOR FOR 	SELECT P.ID
																					FROM Przejscie P
																						JOIN Przejscie_Odcinka PO ON P.ID=PO.Przejscie
																						JOIN Odcinek O ON O.ID=PO.Odcinek
																					WHERE O.ID=OLD.ID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    IF OLD.Punktacja <>NEW.Punktacja OR OLD.PunktacjaOdKonca<>NEW.PunktacjaOdKonca THEN
        OPEN zmienione_przejscia;
        read_loop: LOOP
            FETCH zmienione_przejscia INTO zmienione_przejscie;
            IF done THEN
                LEAVE read_loop;
            END IF;
            UPDATE Przejscie SET Suma_punktow=(SELECT SUM(YEET.punkty_przyznane) suma_punktow
            FROM
            (
                SELECT IF(Przejscie_Odcinka.Od_konca, Odcinek.PunktacjaOdKonca, Odcinek.Punktacja) punkty_przyznane
                FROM Przejscie_Odcinka JOIN Odcinek ON Przejscie_Odcinka.Odcinek=Odcinek.ID
                WHERE Przejscie_Odcinka.Przejscie=zmienione_przejscie
            ) YEET)
            WHERE Przejscie.ID=zmienione_przejscie;
            END LOOP;
        CLOSE zmienione_przejscia;
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Odznaka`
--

CREATE TABLE `Odznaka` (
  `ID` int(10) NOT NULL,
  `Stopien` int(10) NOT NULL,
  `Pracownik_Referatu_Weryfikacyjnego` int(10) DEFAULT NULL,
  `Data_przyznania` date DEFAULT NULL,
  `Turysta` int(10) NOT NULL,
  `Zdobyta` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Odznaka`
--

INSERT INTO `Odznaka` (`ID`, `Stopien`, `Pracownik_Referatu_Weryfikacyjnego`, `Data_przyznania`, `Turysta`, `Zdobyta`) VALUES
(1, 4, 1, '2021-01-07', 1, 1),
(2, 1, 1, '2021-01-18', 1, 1),
(3, 2, NULL, NULL, 1, 0),
(4, 4, NULL, NULL, 3, 0),
(5, 4, NULL, NULL, 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `Pasmo_gorskie`
--

CREATE TABLE `Pasmo_gorskie` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Pasmo_gorskie`
--

INSERT INTO `Pasmo_gorskie` (`ID`, `Nazwa`) VALUES
(6, 'Beskidy Wschodnie'),
(5, 'Beskidy Zachodnie'),
(3, 'Góry Świętokrzyskie'),
(1, 'Sudety'),
(2, 'Tatry i Podtatrze'),
(4, 'Tatry Słowackie');

-- --------------------------------------------------------

--
-- Table structure for table `Pracownik_PTTK`
--

CREATE TABLE `Pracownik_PTTK` (
  `ID` int(10) NOT NULL,
  `Login` varchar(255) NOT NULL,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Haslo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Pracownik_PTTK`
--

INSERT INTO `Pracownik_PTTK` (`ID`, `Login`, `Imie`, `Nazwisko`, `Haslo`) VALUES
(1, 'pracus3310', 'Wojciech', 'Mann', 'pass');

-- --------------------------------------------------------

--
-- Table structure for table `Pracownik_Referatu_Weryfikacyjnego`
--

CREATE TABLE `Pracownik_Referatu_Weryfikacyjnego` (
  `ID` int(10) NOT NULL,
  `Login` varchar(255) NOT NULL,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Haslo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Pracownik_Referatu_Weryfikacyjnego`
--

INSERT INTO `Pracownik_Referatu_Weryfikacyjnego` (`ID`, `Login`, `Imie`, `Nazwisko`, `Haslo`) VALUES
(1, 'Pralkopodobny', 'Marceli', 'Zakalski', 'xxx_XD_xxx'),
(2, 'Rav215', 'Rafał', 'Bern', 'Okon3310');

-- --------------------------------------------------------

--
-- Table structure for table `Przejscie`
--

CREATE TABLE `Przejscie` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL,
  `PunktPoczatkowy` int(10) NOT NULL,
  `Odznaka` int(10) DEFAULT NULL,
  `TurystaPlanujacy` int(10) NOT NULL,
  `CzyPrzemierzyl` tinyint(1) NOT NULL,
  `Data_rozpoczecia` date DEFAULT NULL,
  `Data_zakonczenia` date DEFAULT NULL,
  `Suma_punktow` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Przejscie`
--

INSERT INTO `Przejscie` (`ID`, `Nazwa`, `PunktPoczatkowy`, `Odznaka`, `TurystaPlanujacy`, `CzyPrzemierzyl`, `Data_rozpoczecia`, `Data_zakonczenia`, `Suma_punktow`) VALUES
(1, 'testowePrzejscie', 1, 1, 1, 1, '2021-01-01', '2021-01-07', 133),
(2, 'droogiePrzejscie', 1, 2, 1, 1, '2021-01-08', '2021-01-16', 132),
(3, 'Trzecie', 1, 3, 1, 1, NULL, NULL, 35);

-- --------------------------------------------------------

--
-- Table structure for table `Przejscie_Odcinka`
--

CREATE TABLE `Przejscie_Odcinka` (
  `ID` int(10) NOT NULL,
  `Odcinek` int(10) NOT NULL,
  `PrzodownikZatwierdzajacy` int(10) DEFAULT NULL,
  `Przejscie` int(10) NOT NULL,
  `Zatwierdzone` tinyint(1) NOT NULL,
  `Od_konca` tinyint(1) NOT NULL,
  `Data_przejscia` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Przejscie_Odcinka`
--

INSERT INTO `Przejscie_Odcinka` (`ID`, `Odcinek`, `PrzodownikZatwierdzajacy`, `Przejscie`, `Zatwierdzone`, `Od_konca`, `Data_przejscia`) VALUES
(1, 1, 1, 1, 1, 0, '2021-01-01'),
(2, 4, 1, 1, 1, 0, '2021-01-01'),
(3, 6, 1, 1, 1, 0, '2021-01-03'),
(4, 7, 1, 1, 1, 0, '2021-01-04'),
(5, 8, 1, 1, 1, 0, '2021-01-05'),
(6, 10, 1, 1, 1, 0, '2021-01-06'),
(7, 14, 1, 1, 1, 0, '2021-01-07'),
(8, 14, 1, 2, 1, 1, '2021-01-08'),
(9, 10, 1, 2, 1, 1, '2021-01-09'),
(10, 8, 1, 2, 1, 1, '2021-01-10'),
(11, 7, 1, 2, 1, 1, '2021-01-11'),
(12, 6, 1, 2, 1, 1, '2021-01-12'),
(13, 4, 1, 2, 1, 1, '2021-01-13'),
(14, 1, 1, 2, 1, 1, '2021-01-14'),
(15, 21, 1, 2, 1, 1, '2021-01-16'),
(16, 10, 1, 1, 1, 0, '2021-01-07'),
(17, 10, 1, 1, 1, 0, '2021-01-07'),
(19, 1, 1, 3, 1, 0, '2021-01-30'),
(20, 23, NULL, 3, 0, 0, '2021-01-21');

--
-- Triggers `Przejscie_Odcinka`
--
DELIMITER $$
CREATE TRIGGER `update_suma_punktow_delete` AFTER DELETE ON `Przejscie_Odcinka` FOR EACH ROW UPDATE Przejscie SET Suma_punktow=(SELECT IFNULL(SUM(YEET.punkty_przyznane),0) suma_punktow
    FROM
    (
        SELECT IF(Przejscie_Odcinka.Od_konca, Odcinek.PunktacjaOdKonca, Odcinek.Punktacja) punkty_przyznane
        FROM Przejscie_Odcinka JOIN Odcinek ON Przejscie_Odcinka.Odcinek=Odcinek.ID
        WHERE Przejscie_Odcinka.Przejscie=OLD.Przejscie
    ) YEET)
    WHERE Przejscie.ID=OLD.Przejscie
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_suma_punktow_insert` AFTER INSERT ON `Przejscie_Odcinka` FOR EACH ROW UPDATE Przejscie SET Suma_punktow=(SELECT SUM(YEET.punkty_przyznane) suma_punktow
    FROM
    (
        SELECT IF(Przejscie_Odcinka.Od_konca, Odcinek.PunktacjaOdKonca, Odcinek.Punktacja) punkty_przyznane
        FROM Przejscie_Odcinka JOIN Odcinek ON Przejscie_Odcinka.Odcinek=Odcinek.ID
        WHERE Przejscie_Odcinka.Przejscie=NEW.Przejscie
    ) YEET)
    WHERE Przejscie.ID=NEW.Przejscie
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_suma_punktow_update` AFTER UPDATE ON `Przejscie_Odcinka` FOR EACH ROW UPDATE Przejscie SET Suma_punktow=(SELECT SUM(YEET.punkty_przyznane) suma_punktow
    FROM
    (
        SELECT IF(Przejscie_Odcinka.Od_konca, Odcinek.PunktacjaOdKonca, Odcinek.Punktacja) punkty_przyznane
        FROM Przejscie_Odcinka JOIN Odcinek ON Przejscie_Odcinka.Odcinek=Odcinek.ID
        WHERE Przejscie_Odcinka.Przejscie=NEW.Przejscie
    ) YEET)
    WHERE Przejscie.ID=NEW.Przejscie
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Przodownik`
--

CREATE TABLE `Przodownik` (
  `ID` int(10) NOT NULL,
  `Numer_ksiazeczki` varchar(255) NOT NULL,
  `Aktwyny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Przodownik`
--

INSERT INTO `Przodownik` (`ID`, `Numer_ksiazeczki`, `Aktwyny`) VALUES
(1, 'PGB 1/19', 1),
(2, 'PGB 2/19', 1);

-- --------------------------------------------------------

--
-- Table structure for table `Punkt`
--

CREATE TABLE `Punkt` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL,
  `Pracownik_PTTK` int(10) NOT NULL,
  `Wysokosc_npm` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Punkt`
--

INSERT INTO `Punkt` (`ID`, `Nazwa`, `Pracownik_PTTK`, `Wysokosc_npm`) VALUES
(1, 'A', 1, 2000),
(2, 'B', 1, 3000),
(3, 'C', 1, 2312),
(4, 'D', 1, 1234),
(5, 'E', 1, 3221),
(6, 'F', 1, 1234),
(7, 'G', 1, 2345),
(8, 'H', 1, 2000),
(9, 'I', 1, 3000),
(10, 'J', 1, 2312),
(11, 'K', 1, 1234),
(12, 'L', 1, 3221),
(13, 'M', 1, 1234),
(14, 'N', 1, 2345);

-- --------------------------------------------------------

--
-- Table structure for table `Stopien`
--

CREATE TABLE `Stopien` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL,
  `Punkty_wymagane` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Stopien`
--

INSERT INTO `Stopien` (`ID`, `Nazwa`, `Punkty_wymagane`) VALUES
(1, 'brązowa', 120),
(2, 'srebrna', 360),
(3, 'złota', 720),
(4, 'popularna', 60);

-- --------------------------------------------------------

--
-- Table structure for table `Teren`
--

CREATE TABLE `Teren` (
  `ID` int(10) NOT NULL,
  `Nazwa` varchar(255) NOT NULL,
  `Pasmo_gorskie` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Teren`
--

INSERT INTO `Teren` (`ID`, `Nazwa`, `Pasmo_gorskie`) VALUES
(1, 'Góry Sowie', 1),
(2, 'Góry Bardzkie', 1);

-- --------------------------------------------------------

--
-- Table structure for table `Turysta`
--

CREATE TABLE `Turysta` (
  `ID` int(10) NOT NULL,
  `Login` varchar(255) NOT NULL,
  `KontoPrzodownicze` int(10) DEFAULT NULL,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Data_dolaczenia` int(10) NOT NULL,
  `Haslo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Turysta`
--

INSERT INTO `Turysta` (`ID`, `Login`, `KontoPrzodownicze`, `Imie`, `Nazwisko`, `Data_dolaczenia`, `Haslo`) VALUES
(1, 'TestUser', NULL, 'Marian', 'Lichtman', 1979, 'pass'),
(3, 'ziemniak22', 1, 'Andrzej', 'Wajda', 1978, 'pass'),
(4, 'pitbull', NULL, 'Patryk', 'Vega', 1978, 'pass');

-- --------------------------------------------------------

--
-- Table structure for table `Uprawnienie`
--

CREATE TABLE `Uprawnienie` (
  `ID` int(10) NOT NULL,
  `Pasmo_gorskie` int(10) NOT NULL,
  `Przodownik` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Uprawnienie`
--

INSERT INTO `Uprawnienie` (`ID`, `Pasmo_gorskie`, `Przodownik`) VALUES
(1, 1, 1),
(2, 2, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Odbywanie`
--
ALTER TABLE `Odbywanie`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `identifier` (`Przejscie`,`Przodownik`),
  ADD KEY `odbywa` (`Przodownik`),
  ADD KEY `FKOdbywanie642128` (`Przejscie`);

--
-- Indexes for table `Odcinek`
--
ALTER TABLE `Odcinek`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`),
  ADD KEY `nalezy do` (`Teren`),
  ADD KEY `tworzy_odcinek` (`PunktPoczatkowy`),
  ADD KEY `FKOdcinek220912` (`PunktKoncowy`);

--
-- Indexes for table `Odznaka`
--
ALTER TABLE `Odznaka`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `identifier` (`Stopien`,`Turysta`),
  ADD KEY `przyznaje` (`Pracownik_Referatu_Weryfikacyjnego`),
  ADD KEY `ma_stopien` (`Stopien`),
  ADD KEY `dotyczy` (`Turysta`) USING BTREE;

--
-- Indexes for table `Pasmo_gorskie`
--
ALTER TABLE `Pasmo_gorskie`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`);

--
-- Indexes for table `Pracownik_PTTK`
--
ALTER TABLE `Pracownik_PTTK`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Login` (`Login`);

--
-- Indexes for table `Pracownik_Referatu_Weryfikacyjnego`
--
ALTER TABLE `Pracownik_Referatu_Weryfikacyjnego`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Login` (`Login`);

--
-- Indexes for table `Przejscie`
--
ALTER TABLE `Przejscie`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `identifier` (`TurystaPlanujacy`,`Nazwa`),
  ADD KEY `planuje` (`TurystaPlanujacy`),
  ADD KEY `punktowana_do` (`Odznaka`),
  ADD KEY `rozpoczyna` (`PunktPoczatkowy`);

--
-- Indexes for table `Przejscie_Odcinka`
--
ALTER TABLE `Przejscie_Odcinka`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Zawiera` (`Przejscie`),
  ADD KEY `opiniuje` (`PrzodownikZatwierdzajacy`),
  ADD KEY `dotyczy` (`Odcinek`);

--
-- Indexes for table `Przodownik`
--
ALTER TABLE `Przodownik`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Numer_ksiazeczki` (`Numer_ksiazeczki`);

--
-- Indexes for table `Punkt`
--
ALTER TABLE `Punkt`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`),
  ADD KEY `ustala` (`Pracownik_PTTK`);

--
-- Indexes for table `Stopien`
--
ALTER TABLE `Stopien`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`);

--
-- Indexes for table `Teren`
--
ALTER TABLE `Teren`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`),
  ADD KEY `jest_w` (`Pasmo_gorskie`);

--
-- Indexes for table `Turysta`
--
ALTER TABLE `Turysta`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Login` (`Login`),
  ADD KEY `rozszerzenie_konta` (`KontoPrzodownicze`);

--
-- Indexes for table `Uprawnienie`
--
ALTER TABLE `Uprawnienie`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `identifier` (`Pasmo_gorskie`,`Przodownik`),
  ADD KEY `FKUprawnieni192656` (`Przodownik`),
  ADD KEY `FKUprawnieni911672` (`Pasmo_gorskie`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Odbywanie`
--
ALTER TABLE `Odbywanie`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Odcinek`
--
ALTER TABLE `Odcinek`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `Odznaka`
--
ALTER TABLE `Odznaka`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Pasmo_gorskie`
--
ALTER TABLE `Pasmo_gorskie`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Pracownik_PTTK`
--
ALTER TABLE `Pracownik_PTTK`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Pracownik_Referatu_Weryfikacyjnego`
--
ALTER TABLE `Pracownik_Referatu_Weryfikacyjnego`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Przejscie`
--
ALTER TABLE `Przejscie`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Przejscie_Odcinka`
--
ALTER TABLE `Przejscie_Odcinka`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `Przodownik`
--
ALTER TABLE `Przodownik`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Punkt`
--
ALTER TABLE `Punkt`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `Stopien`
--
ALTER TABLE `Stopien`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Teren`
--
ALTER TABLE `Teren`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Turysta`
--
ALTER TABLE `Turysta`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Uprawnienie`
--
ALTER TABLE `Uprawnienie`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Odbywanie`
--
ALTER TABLE `Odbywanie`
  ADD CONSTRAINT `FKOdbywanie642128` FOREIGN KEY (`Przejscie`) REFERENCES `Przejscie` (`ID`),
  ADD CONSTRAINT `odbywa` FOREIGN KEY (`Przodownik`) REFERENCES `Przodownik` (`ID`);

--
-- Constraints for table `Odcinek`
--
ALTER TABLE `Odcinek`
  ADD CONSTRAINT `FKOdcinek220912` FOREIGN KEY (`PunktKoncowy`) REFERENCES `Punkt` (`ID`),
  ADD CONSTRAINT `nalezy do` FOREIGN KEY (`Teren`) REFERENCES `Teren` (`ID`),
  ADD CONSTRAINT `tworzy_odcinek` FOREIGN KEY (`PunktPoczatkowy`) REFERENCES `Punkt` (`ID`);

--
-- Constraints for table `Odznaka`
--
ALTER TABLE `Odznaka`
  ADD CONSTRAINT `Odznaka_ibfk_1` FOREIGN KEY (`Turysta`) REFERENCES `Turysta` (`ID`),
  ADD CONSTRAINT `ma_stopien` FOREIGN KEY (`Stopien`) REFERENCES `Stopien` (`ID`),
  ADD CONSTRAINT `przyznaje` FOREIGN KEY (`Pracownik_Referatu_Weryfikacyjnego`) REFERENCES `Pracownik_Referatu_Weryfikacyjnego` (`ID`);

--
-- Constraints for table `Przejscie`
--
ALTER TABLE `Przejscie`
  ADD CONSTRAINT `planuje` FOREIGN KEY (`TurystaPlanujacy`) REFERENCES `Turysta` (`ID`),
  ADD CONSTRAINT `punktowana_do` FOREIGN KEY (`Odznaka`) REFERENCES `Odznaka` (`ID`),
  ADD CONSTRAINT `rozpoczyna` FOREIGN KEY (`PunktPoczatkowy`) REFERENCES `Punkt` (`ID`);

--
-- Constraints for table `Przejscie_Odcinka`
--
ALTER TABLE `Przejscie_Odcinka`
  ADD CONSTRAINT `Zawiera` FOREIGN KEY (`Przejscie`) REFERENCES `Przejscie` (`ID`),
  ADD CONSTRAINT `dotyczy` FOREIGN KEY (`Odcinek`) REFERENCES `Odcinek` (`ID`),
  ADD CONSTRAINT `opiniuje` FOREIGN KEY (`PrzodownikZatwierdzajacy`) REFERENCES `Przodownik` (`ID`);

--
-- Constraints for table `Punkt`
--
ALTER TABLE `Punkt`
  ADD CONSTRAINT `ustala` FOREIGN KEY (`Pracownik_PTTK`) REFERENCES `Pracownik_PTTK` (`ID`);

--
-- Constraints for table `Teren`
--
ALTER TABLE `Teren`
  ADD CONSTRAINT `jest_w` FOREIGN KEY (`Pasmo_gorskie`) REFERENCES `Pasmo_gorskie` (`ID`);

--
-- Constraints for table `Turysta`
--
ALTER TABLE `Turysta`
  ADD CONSTRAINT `rozszerzenie_konta` FOREIGN KEY (`KontoPrzodownicze`) REFERENCES `Przodownik` (`ID`);

--
-- Constraints for table `Uprawnienie`
--
ALTER TABLE `Uprawnienie`
  ADD CONSTRAINT `FKUprawnieni192656` FOREIGN KEY (`Przodownik`) REFERENCES `Przodownik` (`ID`),
  ADD CONSTRAINT `FKUprawnieni911672` FOREIGN KEY (`Pasmo_gorskie`) REFERENCES `Pasmo_gorskie` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
