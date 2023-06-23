/*
SQLyog Ultimate
MySQL - 8.0.33-0ubuntu0.22.04.2 : Database - profiler
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`profiler` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

/*Table structure for table `access_user` */

DROP TABLE IF EXISTS `access_user`;

CREATE TABLE `access_user` (
  `usercd` varchar(100) DEFAULT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `outlet` varchar(100) DEFAULT NULL,
  `access` varchar(100) DEFAULT NULL,
  `level` int DEFAULT NULL,
  `needaproval` varchar(100) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `access_user` */

/*Table structure for table `accessmain` */

DROP TABLE IF EXISTS `accessmain`;

CREATE TABLE `accessmain` (
  `accessname` varchar(200) DEFAULT '',
  `note` varchar(500) DEFAULT '',
  `type` varchar(100) DEFAULT '',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `accessmain` */

insert  into `accessmain`(`accessname`,`note`,`type`,`id`) values 
('deleteitem','access untuk delete item yg sudah di input','transaction',1),
('deletepayment','access untuk delete payment yg sudah di input','transaction',2),
('setting','access untuk setting','settings',3),
('printbill','access untuk print bill','transaction',4),
('sendkitchen','access send to kitchen','transaction',5),
('printpayment','access print payment','transaction',6),
('sendwa','kirim bill via whatsapp','transaction',7),
('sendmail','kirim bill via email','transaction',8),
('selectoutlet','pilih outlet ','transaction',9),
('createoutlet','buat outlet baru','setting',10),
('reopenbill','access reopen bill','transaction',11),
('pegawai','access untuk Buat Pegawai / tambah role pegawai','setting',12),
('settingprinter','access untuk open setting printer','setting',13),
('integrasi','Untuk Setting Integrasi pihak ke 3','setting',14),
('kelolapromo','access untuk kelola promo','setting',15),
('riwayattrans','melihat history transaksi','transaction',16),
('laporan','access melihat laporan ','transaction',17),
('tokoonline','use toko online ','transaction',18),
('table','use table on outlet','setting',19),
('canceltrans','untuk cancel transaksi','transaction',20),
('createcondiment','buat condiment','setting',21),
('createtable','buat table untuk transaksi','setting',22),
('createtype','buat tipe transaksi multiharga','setting',23),
('createcostumer','buat pelanggan ','setting',24),
('openclosecashier','buka tutup cashier','transaction',25),
('paymentmaster','Setting Pembayaran','setting',26),
('canrefund','refund tanpa password','setting',28),
('candeleteitem','bisa delete item yg sudah di pesan ','setting',29),
('generalsetting','setting general','setting',30),
('itempackage','Setting itempackage','setting',31),
('pegawai','Setting untuk membuat user','setting',32);

/*Table structure for table `acess_subcription` */

DROP TABLE IF EXISTS `acess_subcription`;

CREATE TABLE `acess_subcription` (
  `subscriptioncd` varchar(100) DEFAULT NULL,
  `subscriptiondesc` varchar(100) DEFAULT NULL,
  `accesscd` varchar(100) DEFAULT NULL,
  `accessdesc` varchar(100) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `acess_subcription` */

insert  into `acess_subcription`(`subscriptioncd`,`subscriptiondesc`,`accesscd`,`accessdesc`,`id`) values 
('basic','basic','deleteitem','access untuk delete item yg sudah di input',95),
('basic','basic','deletepayment','access untuk delete payment yg sudah di input',96),
('basic','basic','setting','access untuk setting',97),
('basic','basic','printbill','access untuk print bill',98),
('basic','basic','printpayment','access print payment',100),
('basic','basic','sendwa','kirim bill via whatsapp',101),
('basic','basic','reopenbill','access reopen bill',105),
('basic','basic','settingprinter','access untuk open setting printer',107),
('basic','basic','riwayattrans','melihat history transaksi',110),
('basic','basic','laporan','access melihat laporan ',111),
('basic','basic','canceltrans','untuk cancel transaksi',114),
('pro','pro','deleteitem','access untuk delete item yg sudah di input',126),
('pro','pro','deletepayment','access untuk delete payment yg sudah di input',127),
('pro','pro','setting','access untuk setting',128),
('pro','pro','printbill','access untuk print bill',129),
('pro','pro','sendkitchen','access send to kitchen',130),
('pro','pro','printpayment','access print payment',131),
('pro','pro','sendwa','kirim bill via whatsapp',132),
('pro','pro','sendmail','kirim bill via email',133),
('pro','pro','selectoutlet','pilih outlet ',134),
('pro','pro','createoutlet','buat outlet baru',135),
('pro','pro','reopenbill','access reopen bill',136),
('pro','pro','pegawai','access untuk Buat Pegawai / tambah role pegawai',137),
('pro','pro','settingprinter','access untuk open setting printer',138),
('pro','pro','integrasi','Untuk Setting Integrasi pihak ke 3',139),
('pro','pro','kelolapromo','access untuk kelola promo',140),
('pro','pro','riwayattrans','melihat history transaksi',141),
('pro','pro','laporan','access melihat laporan ',142),
('pro','pro','tokoonline','use toko online ',143),
('pro','pro','table','use table on outlet',144),
('pro','pro','canceltrans','untuk cancel transaksi',145),
('pro','pro','createcondiment','buat condiment',146),
('pro','pro','createtable','buat table untuk transaksi',147),
('pro','pro','createtype','buat tipe transaksi multiharga',148),
('pro','pro','createcostumer','buat pelanggan ',149),
('pro','pro','openclosecashier','buka tutup cashier',150),
('full','full','deleteitem','access untuk delete item yg sudah di input',157),
('full','full','deletepayment','access untuk delete payment yg sudah di input',158),
('full','full','setting','access untuk setting',159),
('full','full','printbill','access untuk print bill',160),
('full','full','sendkitchen','access send to kitchen',161),
('full','full','printpayment','access print payment',162),
('full','full','sendwa','kirim bill via whatsapp',163),
('full','full','sendmail','kirim bill via email',164),
('full','full','selectoutlet','pilih outlet ',165),
('full','full','createoutlet','buat outlet baru',166),
('full','full','reopenbill','access reopen bill',167),
('full','full','pegawai','access untuk Buat Pegawai / tambah role pegawai',168),
('full','full','settingprinter','access untuk open setting printer',169),
('full','full','integrasi','Untuk Setting Integrasi pihak ke 3',170),
('full','full','kelolapromo','access untuk kelola promo',171),
('full','full','riwayattrans','melihat history transaksi',172),
('full','full','laporan','access melihat laporan ',173),
('full','full','tokoonline','use toko online ',174),
('full','full','table','use table on outlet',175),
('full','full','canceltrans','untuk cancel transaksi',176),
('full','full','createcondiment','buat condiment',177),
('full','full','createtable','buat table untuk transaksi',178),
('full','full','createtype','buat tipe transaksi multiharga',179),
('full','full','createcostumer','buat pelanggan ',180),
('full','full','openclosecashier','buka tutup cashier',181),
('pro','pro','paymentmaster','Setting paymentmaster',188),
('full','full','paymentmaster','Setting paymentmaster',189),
('basic','basic','canrefund','canrefund',190),
('full','full','canrefund','canrefund',191),
('pro','pro','canrefund','canrefund',192),
('full','full','candeleteitem','candeleteitem',193),
('pro','pro','candeleteitem','candeleteitem',194),
('basic','basic','candeleteitem','candeleteitem',195),
('basic','basic','kelolapromo','kelolapromo',196),
('basic','basic','riwayattrans','riwayattrans',197),
('basic','basic','generalsetting','generalsetting',198),
('pro','pro','generalsetting','generalsetting',199),
('full','full','generalsetting','generalsetting',200),
('basic','basic','itempackage','itempackage',201),
('pro','pro','itempackage','itempackage',202),
('full','full','itempackage','itempackage',203),
('pro','pro','pegawai','pegawai',204),
('full','full','pegawai','pegawai',205),
('pro','pro','createtable','createtable',206),
('full','full','createtable','createtable',207);

/*Table structure for table `outlet` */

DROP TABLE IF EXISTS `outlet`;

CREATE TABLE `outlet` (
  `outletcd` varchar(200) NOT NULL DEFAULT '',
  `outletdesc` varchar(200) DEFAULT '',
  `telp` varchar(200) DEFAULT '',
  `alamat` varchar(200) DEFAULT '',
  `kodepos` varchar(200) DEFAULT '',
  `slstp` int DEFAULT NULL,
  `dbname` varchar(200) NOT NULL DEFAULT '',
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`outletcd`,`dbname`,`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `outlet` */

insert  into `outlet`(`outletcd`,`outletdesc`,`telp`,`alamat`,`kodepos`,`slstp`,`dbname`,`id`) values 
('hayol7355','hayolo','85173358897','wonodri','50237',0,'hayol7355',30),
('Kopi5806','Kopi Terkenang','82221769478','Jalan Nirkabel No 321','567123',0,'Kopi5806',25),
('Kopi8952','Kopi Terkenang II','82221769478','Jalan Jalan No 321','57123',0,'Kopi8952',28);

/*Table structure for table `outlet_access` */

DROP TABLE IF EXISTS `outlet_access`;

CREATE TABLE `outlet_access` (
  `outletcode` varchar(200) NOT NULL DEFAULT '',
  `usercode` varchar(200) NOT NULL DEFAULT '',
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`outletcode`,`usercode`,`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `outlet_access` */

insert  into `outlet_access`(`outletcode`,`usercode`,`id`) values 
('Kopi5806','Niko Cahya',30),
('kyuky302','kyubi',33),
('kyuky5674','kyubi',34),
('Kopi8952','Niko Cahya',35),
('kyubi6304','',36),
('hayol7355','',37),
('kyubi4565','',38),
('kyubi119','',39),
('kyubi5919','',40);

/*Table structure for table `staffrole` */

DROP TABLE IF EXISTS `staffrole`;

CREATE TABLE `staffrole` (
  `jobcode` varchar(200) DEFAULT NULL,
  `joblevel` varchar(200) DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `staffrole` */

insert  into `staffrole`(`jobcode`,`joblevel`,`note`,`id`) values 
('01-01','Owner','Bisnis Owner',1),
('01-02','General Manager','General Manager',2),
('01-03','Manager','Manager senior and junior',3),
('01-04','Supervisior','SPV',4),
('01-05','Staff','Staff',5),
('01-06','Daily Worker','DW',6);

/*Table structure for table `userright` */

DROP TABLE IF EXISTS `userright`;

CREATE TABLE `userright` (
  `subscriptioncd` varchar(200) DEFAULT NULL,
  `subscriptiondesc` varchar(200) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `userright` */

insert  into `userright`(`subscriptioncd`,`subscriptiondesc`,`id`) values 
('basic','basic',1),
('pro','pro',2),
('full','full',3),
('superadmin','superadmin',4);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `usercd` varchar(200) NOT NULL DEFAULT '',
  `password` varchar(200) NOT NULL DEFAULT '',
  `fullname` varchar(200) DEFAULT '',
  `email` varchar(200) DEFAULT '',
  `telp` varchar(200) DEFAULT '',
  `company` varchar(200) DEFAULT '',
  `address` varchar(200) DEFAULT '',
  `level` varchar(100) DEFAULT '',
  `expireddate` date DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uuid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `urlpict` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `name` varchar(100) DEFAULT '',
  `lastsignin` varchar(100) DEFAULT '',
  `token` varchar(100) DEFAULT '',
  `subscription` varchar(100) DEFAULT '',
  `pytransaction` varchar(100) DEFAULT '',
  `paymentcheck` varchar(100) DEFAULT '',
  PRIMARY KEY (`usercd`,`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `users` */

insert  into `users`(`usercd`,`password`,`fullname`,`email`,`telp`,`company`,`address`,`level`,`expireddate`,`id`,`uuid`,`urlpict`,`name`,`lastsignin`,`token`,`subscription`,`pytransaction`,`paymentcheck`) values 
('andreas ','Andre280888','freya JKT48','andreassukmanugroho@gmail.com','','','','Owner',NULL,44,'v8X30xGHhrfdFYYxa9QbYBqHvJw1','https://lh3.googleusercontent.com/a/AAcHTtcwQ0ciczAhkM0ADj_ySeBo7j1MuT3NFjZwOvW_=s96-c','','','','Pro','andreassukmanugroho@gmail.com80','settlement'),
('kyubi','kyubipleburan','freya JKT48','burjokyubi@gmail.com','','','','Owner',NULL,43,'v8X30xGHhrfdFYYxa9QbYBqHvJw1','https://lh3.googleusercontent.com/a/AAcHTtcwQ0ciczAhkM0ADj_ySeBo7j1MuT3NFjZwOvW_=s96-c','','','','Pro','burjokyubi@gmail.com33','settlement'),
('Niko Cahya','Mitro100689','freya JKT48','mithmass2@gmail.com','','','','Owner',NULL,55,'v8X30xGHhrfdFYYxa9QbYBqHvJw1','https://lh3.googleusercontent.com/a/AAcHTtcwQ0ciczAhkM0ADj_ySeBo7j1MuT3NFjZwOvW_=s96-c','','','','Pro','mithmass2@gmail.com48','settlement'),
('yandez','Mitro100689','','mithmass8989@gmail.com','','','','Owner',NULL,66,'','','','','','Pro','mithmass8989@gmail.com94','confirm');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
