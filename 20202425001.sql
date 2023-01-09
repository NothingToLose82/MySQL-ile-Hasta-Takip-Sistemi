-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 20 Ara 2022, 01:22:31
-- Sunucu sürümü: 10.4.25-MariaDB
-- PHP Sürümü: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `dis_hekimi_veri_tabani`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `birden_fazla_islemde_kullanilan_malzemeler` ()   SELECT stok.malzeme_id,stok.malzeme_ismi,count(stok_islem.islem_id) as 'Kaç İşlemde Kullanıldığı'
FROM stok,stok_islem
where stok.malzeme_id = stok_islem.malzeme_id
GROUP BY stok_islem.malzeme_id
HAVING COUNT(stok_islem.malzeme_id) > 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bir_tarihte_yapilan_islemler` (IN `tarih` VARCHAR(255))   SELECT
	randevu.randevu_id,
	hastalar.hasta_adi,hastalar.hasta_soyadi,
    doktorlar.doktor_adi,doktorlar.doktor_soyadi,
    islemler.islem_adi,
	randevu.islem_tarihi
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler

WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id

AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id

AND randevu.randevu_id = islem_randevu.randevu_id
AND islem_randevu.islem_id = islemler.islem_id
AND tarih= randevu.islem_tarihi
ORDER BY hastalar.hasta_adi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bir_yil_icerisinde_yapilan_islemler` (IN `yil` VARCHAR(255))   SELECT
	randevu.randevu_id as 'Randevu ID',
	hastalar.hasta_adi as 'Hasta Adı',
    hastalar.hasta_soyadi as 'Hasta Soyadı',
    doktorlar.doktor_adi as 'Doktor Adı',
    doktorlar.doktor_soyadi as 'Doktor Soyadı',
    islemler.islem_adi as 'İşlem Adı',
	randevu.islem_tarihi as 'İşlem Tarihi'
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
AND randevu.islem_tarihi LIKE concat('%',yil,'%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doktorlarin_hasta_sayilari` ()   SELECT
	doktorlar.doktor_adi,
    doktorlar.doktor_soyadi,
    count(doktor_randevu.randevu_id) as 'Hasta Sayıları'
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
group by doktorlar.doktor_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hastalarin_islem_tarihleri` (IN `hastanin_idsi` INT)   SELECT
	randevu.randevu_id as 'Randevu ID',
	hastalar.hasta_adi as 'Hasta Adı',
    hastalar.hasta_soyadi as 'Hasta Soyadı',
    doktorlar.doktor_adi as 'Doktor Adı',
    doktorlar.doktor_soyadi as 'Doktor Soyadı',
    islemler.islem_adi as 'İşlem Adı',
	randevu.islem_tarihi as 'İşlem Tarihi'
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
AND hastanin_idsi = hasta_randevu.hasta_id
ORDER BY randevu.islem_tarihi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hastalari_islemlere_gore_gruplama` ()   SELECT
    islemler.islem_adi as 'İşlem Adı',
	count(randevu.randevu_id) as 'İşlem Adedi'
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
GROUP BY islem_randevu.islem_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `iki_yil_arasinda_yapilan_islemleri_gorme` (IN `baslangic_yili` YEAR(255), IN `bitis_yili` YEAR(255))   SELECT
	randevu.randevu_id as 'Randevu ID',
	hastalar.hasta_adi as 'Hasta Adı',
    hastalar.hasta_soyadi as 'Hasta Soyadı',
    doktorlar.doktor_adi as 'Doktor Adı',
    doktorlar.doktor_soyadi as 'Doktor Soyadı',
    islemler.islem_adi as 'İşlem Adı',
	STR_TO_DATE(randevu.islem_tarihi, '%d-%m-%Y') as 'İşlem Tarihi'
FROM randevu,
hasta_randevu,hastalar,
doktor_randevu,doktorlar,
islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
AND STR_TO_DATE(randevu.islem_tarihi, '%d-%m-%Y')
BETWEEN baslangic_yili AND bitis_yili$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isim_kontrolu` (IN `Hasta_İsmi` VARCHAR(255))   SELECT hastalar.hasta_id as ID,
		hastalar.hasta_adi as Adı,
        hastalar.hasta_soyadi as Soyadı,
        hastalar.hasta_telefon_no as Telefonu,
        hasta_randevu.randevu_id as "Randevu IDsi",
        randevu.islem_tarihi as "İşlem Tarihi",
        doktorlar.doktor_adi as "İşlemi Yapan Doktor"
FROM hastalar,hasta_randevu,randevu,doktorlar,doktor_randevu
WHERE hastalar.hasta_adi IN (Hasta_İsmi)
AND hastalar.hasta_id = hasta_randevu.hasta_id
AND hasta_randevu.randevu_id = randevu.randevu_id
AND doktorlar.doktor_id = doktor_randevu.doktor_id
AND doktor_randevu.randevu_id = randevu.randevu_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `malzemelerin_hangi_islemlerde_kullanildigi` ()   SELECT stok.malzeme_ismi,islemler.islem_adi
FROM stok_islem,stok,islemler
WHERE stok_islem.malzeme_id = stok.malzeme_id
AND stok_islem.islem_id = islemler.islem_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `yillara_gore_hasta_sayisi` ()   SELECT count(randevu.randevu_id) as 'Klinikteki Hasta Sayısı',
   (SELECT SUBSTRING_INDEX(
    SUBSTRING_INDEX(islem_tarihi,'-',3),'-',-1)) 
    AS Yıllar
FROM randevu,hasta_randevu,hastalar,
doktor_randevu,doktorlar,islem_randevu,islemler
WHERE randevu.randevu_id = hasta_randevu.randevu_id
AND randevu.randevu_id = doktor_randevu.randevu_id
AND randevu.randevu_id = islem_randevu.randevu_id
AND hasta_randevu.hasta_id = hastalar.hasta_id
AND doktor_randevu.doktor_id = doktorlar.doktor_id
AND islem_randevu.islem_id = islemler.islem_id
group by Yıllar
order by Yıllar$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doktorlar`
--

CREATE TABLE `doktorlar` (
  `doktor_id` int(11) NOT NULL,
  `doktor_adi` varchar(50) DEFAULT NULL,
  `doktor_soyadi` varchar(50) DEFAULT NULL,
  `doktor_telefon_no` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `doktorlar`
--

INSERT INTO `doktorlar` (`doktor_id`, `doktor_adi`, `doktor_soyadi`, `doktor_telefon_no`) VALUES
(1, 'Berkant', 'Gündoğdu', '532-123-11-22'),
(2, 'Okan', 'Işık', '532-123-11-12'),
(3, 'Recep', 'Bayılgan', '532-123-11-13'),
(4, 'Mehmet', 'Kararlı', '532-123-11-14'),
(5, 'Koray', 'Arkın', '532-123-11-15'),
(6, 'Aylin', 'Doğar', '532-123-11-16'),
(7, 'Ecem', 'Alın', '532-123-11-17'),
(8, 'Pervin', 'Gümüş', '532-123-11-18'),
(9, 'Hakkı', 'Demirli', '532-123-11-19'),
(10, 'Ebru', 'Acır', '532-123-11-20'),
(13, 'İlkay', 'Özenli', '536-812-70-29');

--
-- Tetikleyiciler `doktorlar`
--
DELIMITER $$
CREATE TRIGGER `doktor_loglari_delete` BEFORE DELETE ON `doktorlar` FOR EACH ROW INSERT INTO doktor_loglari 
VALUES (old.doktor_id,
        old.doktor_adi,
        old.doktor_soyadi,
        old.doktor_telefon_no,
        now(),
        "DELETE"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `doktor_loglari_insert` AFTER INSERT ON `doktorlar` FOR EACH ROW INSERT INTO doktor_loglari 
VALUES (new.doktor_id,
        new.doktor_adi,
        new.doktor_soyadi,
        new.doktor_telefon_no,
        now(),
        "INSERT"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `doktor_loglari_update` AFTER UPDATE ON `doktorlar` FOR EACH ROW INSERT INTO doktor_loglari 
VALUES (new.doktor_id,
        new.doktor_adi,
        new.doktor_soyadi,
        new.doktor_telefon_no,
        now(),
        "UPDATE"
        )
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doktor_loglari`
--

CREATE TABLE `doktor_loglari` (
  `doktor_id` int(11) DEFAULT NULL,
  `doktor_adi` varchar(255) DEFAULT NULL,
  `doktor_soyadi` varchar(255) DEFAULT NULL,
  `telefon_no` varchar(255) DEFAULT NULL,
  `islem_tarihi` datetime DEFAULT NULL,
  `yapilan_islem` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `doktor_loglari`
--

INSERT INTO `doktor_loglari` (`doktor_id`, `doktor_adi`, `doktor_soyadi`, `telefon_no`, `islem_tarihi`, `yapilan_islem`) VALUES
(13, 'İlkay', 'Özen', '536-812-70-22', '2022-12-15 11:06:37', 'INSERT'),
(13, 'İlkay', 'Özen', '536-812-70-22', '2022-12-15 11:11:18', 'UPDATE'),
(13, 'İlkay', 'Özenli', '536-812-70-22', '2022-12-15 11:11:34', 'UPDATE'),
(13, 'İlkay', 'Özenli', '536-812-70-29', '2022-12-15 11:22:02', 'UPDATE'),
(15, 'Ebru', 'Çakar', '532-517-92-99', '2022-12-15 11:23:58', 'INSERT'),
(15, 'Ebru', 'Çakar', '532-517-92-99', '2022-12-20 01:09:58', 'DELETE');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doktor_randevu`
--

CREATE TABLE `doktor_randevu` (
  `doktor_randevu_id` int(11) NOT NULL,
  `randevu_id` int(11) DEFAULT NULL,
  `doktor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `doktor_randevu`
--

INSERT INTO `doktor_randevu` (`doktor_randevu_id`, `randevu_id`, `doktor_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 9),
(13, 12, 8),
(14, 13, 7);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hastalar`
--

CREATE TABLE `hastalar` (
  `hasta_id` int(11) NOT NULL,
  `hasta_adi` varchar(50) DEFAULT NULL,
  `hasta_soyadi` varchar(50) DEFAULT NULL,
  `hasta_telefon_no` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `hastalar`
--

INSERT INTO `hastalar` (`hasta_id`, `hasta_adi`, `hasta_soyadi`, `hasta_telefon_no`) VALUES
(0, 'Burak', 'Evrentuğ', '532-532-32-32'),
(1, 'Ahmet', 'Mehmet', '532-416-48-92'),
(2, 'Atakan', 'Acaroğlu', '544-522-35-35'),
(3, 'Firuze', 'Kara', '545-111-11-11'),
(4, 'Mehmet', 'Erenli', '532-652-92-95'),
(5, 'Koray', 'Ata', '552-432-69-44'),
(6, 'Yiğit', 'Uçar', '544-535-12-14'),
(7, 'Mehmet', 'Karahaner', '535-321-21-48'),
(8, 'Sinan', 'Yenigün', '545-419-51-82'),
(9, 'Atakan', 'Karaca', '534-418-87-12'),
(10, 'Cüneyt', 'Kafes', '532-416-92-85'),
(13, 'Nejat', 'Kutup', '532-219-88-72');

--
-- Tetikleyiciler `hastalar`
--
DELIMITER $$
CREATE TRIGGER `hasta_loglari_delete` BEFORE DELETE ON `hastalar` FOR EACH ROW INSERT INTO hasta_loglari 
VALUES (old.hasta_id,
        old.hasta_adi,
        old.hasta_soyadi,
        old.hasta_telefon_no,
        now(),
        "DELETE"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hasta_loglari_insert` AFTER INSERT ON `hastalar` FOR EACH ROW INSERT INTO hasta_loglari 
VALUES (new.hasta_id,
        new.hasta_adi,
        new.hasta_soyadi,
        new.hasta_telefon_no,
        now(),
        "INSERT"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hasta_loglari_update` BEFORE UPDATE ON `hastalar` FOR EACH ROW INSERT INTO hasta_loglari 
VALUES (old.hasta_id,
        old.hasta_adi,
        old.hasta_soyadi,
        old.hasta_telefon_no,
        now(),
        "UPDATE"
        )
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hasta_loglari`
--

CREATE TABLE `hasta_loglari` (
  `hasta_id` int(11) DEFAULT NULL,
  `hasta_adi` varchar(255) DEFAULT NULL,
  `hasta_soyadi` varchar(255) DEFAULT NULL,
  `hasta_telefon_no` varchar(255) DEFAULT NULL,
  `islem_tarihi` datetime DEFAULT NULL,
  `yapilan_islem` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `hasta_loglari`
--

INSERT INTO `hasta_loglari` (`hasta_id`, `hasta_adi`, `hasta_soyadi`, `hasta_telefon_no`, `islem_tarihi`, `yapilan_islem`) VALUES
(14, 'Hüseyin', 'Tokat', '547-128-94-71', '2022-12-15 10:44:52', 'INSERT'),
(14, 'Hüseyin', 'Tokat', '547-128-94-71', '2022-12-19 10:01:25', 'UPDATE'),
(14, 'Hüseyin', 'Tokat', '547-128-94-71', '2022-12-19 10:01:57', 'UPDATE'),
(14, 'Hüseyin', 'Tokatlı', '547-128-94-71', '2022-12-20 01:09:38', 'DELETE');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hasta_randevu`
--

CREATE TABLE `hasta_randevu` (
  `hasta_randevu_id` int(11) NOT NULL,
  `randevu_id` int(11) DEFAULT NULL,
  `hasta_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `hasta_randevu`
--

INSERT INTO `hasta_randevu` (`hasta_randevu_id`, `randevu_id`, `hasta_id`) VALUES
(1, 1, 0),
(2, 2, 1),
(3, 3, 2),
(4, 4, 3),
(5, 5, 4),
(6, 6, 5),
(7, 7, 6),
(8, 8, 7),
(9, 9, 7),
(10, 10, 9),
(11, 11, 5),
(13, 12, 1),
(39, 11, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `islemler`
--

CREATE TABLE `islemler` (
  `islem_id` int(11) NOT NULL,
  `islem_adi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `islemler`
--

INSERT INTO `islemler` (`islem_id`, `islem_adi`) VALUES
(1, 'Kanal Tedavisi'),
(2, 'Dolgu'),
(3, 'İmplant'),
(4, '20 lik diş çekimi'),
(5, 'Ortodonti'),
(6, 'Diş Taşı Temizliği'),
(7, 'Diş Beyazlatma'),
(8, 'Diş Eti Küretajı'),
(9, 'Zirkonyum Kaplama'),
(10, 'Teleskop Protez');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `islem_randevu`
--

CREATE TABLE `islem_randevu` (
  `islem_randevu_id` int(11) NOT NULL,
  `randevu_id` int(11) DEFAULT NULL,
  `islem_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `islem_randevu`
--

INSERT INTO `islem_randevu` (`islem_randevu_id`, `randevu_id`, `islem_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 7),
(12, 12, 4),
(13, 13, 1),
(14, 14, 3);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `randevu`
--

CREATE TABLE `randevu` (
  `randevu_id` int(11) NOT NULL,
  `islem_tarihi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `randevu`
--

INSERT INTO `randevu` (`randevu_id`, `islem_tarihi`) VALUES
(1, '20-01-2022'),
(2, '07-03-2017'),
(3, '01-09-2019'),
(4, '18-12-2019'),
(5, '29-01-2016'),
(6, '04-05-2021'),
(7, '11-03-2019'),
(8, '13-10-2008'),
(9, '09-01-2022'),
(10, '08-11-2016'),
(11, '01-07-2022'),
(12, '09-07-2022'),
(13, '21-10-2018'),
(14, '27-08-2014'),
(15, '25-08-2018');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `stok`
--

CREATE TABLE `stok` (
  `malzeme_id` int(11) NOT NULL,
  `malzeme_ismi` varchar(50) DEFAULT NULL,
  `malzeme_adedi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `stok`
--

INSERT INTO `stok` (`malzeme_id`, `malzeme_ismi`, `malzeme_adedi`) VALUES
(0, 'Enjektör', 51),
(1, 'Implant', 93),
(2, 'Dolgu', 97),
(3, 'Frez', 96),
(4, 'Diş Teli', 6),
(5, 'Aparey', 6),
(6, 'Dolgu Tozu', 123),
(7, 'Protez Diş', 88),
(8, 'Zirkonyum Kaplama', 3),
(9, 'Porselen Kaplama', 37),
(10, 'Amalgam Dolgu', 104);

--
-- Tetikleyiciler `stok`
--
DELIMITER $$
CREATE TRIGGER `stok_loglari_delete` BEFORE DELETE ON `stok` FOR EACH ROW INSERT INTO stok_loglari 
VALUES (old.malzeme_id,
        old.malzeme_ismi,
        old.malzeme_adedi,
        now(),
        "DELETE"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_loglari_insert` AFTER INSERT ON `stok` FOR EACH ROW INSERT INTO stok_loglari 
VALUES (new.malzeme_id,
        new.malzeme_ismi,
        new.malzeme_adedi,
        now(),
        "INSERT"
        )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_loglari_update` AFTER UPDATE ON `stok` FOR EACH ROW INSERT INTO stok_loglari 
VALUES (new.malzeme_id,
        new.malzeme_ismi,
        new.malzeme_adedi,
        now(),
        "UPDATE"
        )
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `stok_islem`
--

CREATE TABLE `stok_islem` (
  `malzeme_id` int(11) DEFAULT NULL,
  `islem_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `stok_islem`
--

INSERT INTO `stok_islem` (`malzeme_id`, `islem_id`) VALUES
(1, 3),
(10, 2),
(1, 9),
(3, 10),
(4, 6),
(2, 5),
(9, 7),
(5, 8),
(6, 1),
(7, 3),
(8, 4);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `stok_loglari`
--

CREATE TABLE `stok_loglari` (
  `malzeme_id` int(11) DEFAULT NULL,
  `malzeme_ismi` varchar(255) DEFAULT NULL,
  `malzeme_adedi` int(11) DEFAULT NULL,
  `islem_tarihi` datetime DEFAULT NULL,
  `yapilan_islem` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `stok_loglari`
--

INSERT INTO `stok_loglari` (`malzeme_id`, `malzeme_ismi`, `malzeme_adedi`, `islem_tarihi`, `yapilan_islem`) VALUES
(10, 'Amalgam Dolgu', 117, '2022-12-20 01:45:40', 'UPDATE'),
(10, 'Amalgam Dolgu', 104, '2022-12-20 01:45:56', 'UPDATE'),
(7, 'Protez Diş', 72, '2022-12-20 01:54:25', 'UPDATE'),
(7, 'Protez Diş', 88, '2022-12-20 01:54:28', 'UPDATE'),
(6, 'Dolgu Tozu', 127, '2022-12-20 01:54:34', 'UPDATE'),
(6, 'Dolgu Tozu', 123, '2022-12-20 01:54:41', 'UPDATE'),
(1, 'Implant', 95, '2022-12-20 01:55:02', 'UPDATE'),
(1, 'Implant', 93, '2022-12-20 01:55:05', 'UPDATE');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `doktorlar`
--
ALTER TABLE `doktorlar`
  ADD PRIMARY KEY (`doktor_id`);

--
-- Tablo için indeksler `doktor_randevu`
--
ALTER TABLE `doktor_randevu`
  ADD PRIMARY KEY (`doktor_randevu_id`),
  ADD KEY `randevu_id` (`randevu_id`),
  ADD KEY `doktor_id` (`doktor_id`);

--
-- Tablo için indeksler `hastalar`
--
ALTER TABLE `hastalar`
  ADD PRIMARY KEY (`hasta_id`);

--
-- Tablo için indeksler `hasta_randevu`
--
ALTER TABLE `hasta_randevu`
  ADD PRIMARY KEY (`hasta_randevu_id`),
  ADD KEY `randevu_id` (`randevu_id`),
  ADD KEY `hasta_id` (`hasta_id`);

--
-- Tablo için indeksler `islemler`
--
ALTER TABLE `islemler`
  ADD PRIMARY KEY (`islem_id`);

--
-- Tablo için indeksler `islem_randevu`
--
ALTER TABLE `islem_randevu`
  ADD PRIMARY KEY (`islem_randevu_id`),
  ADD KEY `randevu_id` (`randevu_id`),
  ADD KEY `islem_id` (`islem_id`);

--
-- Tablo için indeksler `randevu`
--
ALTER TABLE `randevu`
  ADD PRIMARY KEY (`randevu_id`);

--
-- Tablo için indeksler `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`malzeme_id`);

--
-- Tablo için indeksler `stok_islem`
--
ALTER TABLE `stok_islem`
  ADD KEY `malzeme_id` (`malzeme_id`),
  ADD KEY `islem_id` (`islem_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `doktorlar`
--
ALTER TABLE `doktorlar`
  MODIFY `doktor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Tablo için AUTO_INCREMENT değeri `doktor_randevu`
--
ALTER TABLE `doktor_randevu`
  MODIFY `doktor_randevu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Tablo için AUTO_INCREMENT değeri `hastalar`
--
ALTER TABLE `hastalar`
  MODIFY `hasta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `hasta_randevu`
--
ALTER TABLE `hasta_randevu`
  MODIFY `hasta_randevu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- Tablo için AUTO_INCREMENT değeri `islemler`
--
ALTER TABLE `islemler`
  MODIFY `islem_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `islem_randevu`
--
ALTER TABLE `islem_randevu`
  MODIFY `islem_randevu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Tablo için AUTO_INCREMENT değeri `randevu`
--
ALTER TABLE `randevu`
  MODIFY `randevu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `doktor_randevu`
--
ALTER TABLE `doktor_randevu`
  ADD CONSTRAINT `doktor_randevu_ibfk_1` FOREIGN KEY (`randevu_id`) REFERENCES `randevu` (`randevu_id`),
  ADD CONSTRAINT `doktor_randevu_ibfk_2` FOREIGN KEY (`doktor_id`) REFERENCES `doktorlar` (`doktor_id`);

--
-- Tablo kısıtlamaları `hasta_randevu`
--
ALTER TABLE `hasta_randevu`
  ADD CONSTRAINT `hasta_randevu_ibfk_1` FOREIGN KEY (`randevu_id`) REFERENCES `randevu` (`randevu_id`),
  ADD CONSTRAINT `hasta_randevu_ibfk_2` FOREIGN KEY (`hasta_id`) REFERENCES `hastalar` (`hasta_id`);

--
-- Tablo kısıtlamaları `islem_randevu`
--
ALTER TABLE `islem_randevu`
  ADD CONSTRAINT `islem_randevu_ibfk_1` FOREIGN KEY (`randevu_id`) REFERENCES `randevu` (`randevu_id`),
  ADD CONSTRAINT `islem_randevu_ibfk_2` FOREIGN KEY (`islem_id`) REFERENCES `islemler` (`islem_id`);

--
-- Tablo kısıtlamaları `stok_islem`
--
ALTER TABLE `stok_islem`
  ADD CONSTRAINT `stok_islem_ibfk_1` FOREIGN KEY (`malzeme_id`) REFERENCES `stok` (`malzeme_id`),
  ADD CONSTRAINT `stok_islem_ibfk_2` FOREIGN KEY (`islem_id`) REFERENCES `islemler` (`islem_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
