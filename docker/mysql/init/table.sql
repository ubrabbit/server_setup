/*
script for sql table define
*/

CREATE DATABASE IF NOT EXISTS `db_phoenix`;
USE `db_phoenix`;

CREATE TABLE IF NOT EXISTS `tbl_admin` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(200) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(200) DEFAULT NULL,

  PRIMARY KEY (`pid`),
  UNIQUE KEY `account` (`account`),
  KEY `name` (`name`)

) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `tbl_account` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(200) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(200) NOT NULL,
  `last_login` datetime DEFAULT NULL COMMENT '上次登录时间',
  `last_ip` varchar(20) DEFAULT NULL COMMENT '上次登录IP',

  PRIMARY KEY (`pid`),
  UNIQUE KEY `account` (`account`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;
