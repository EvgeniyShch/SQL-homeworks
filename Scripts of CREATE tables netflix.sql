drop database if exists Netflix;
create database Netflix character set utf8mb4;
use Netflix;


DROP TABLE IF EXISTS `details_of_subcsription`;
CREATE TABLE `details_of_subcsription` (
  `subcsription_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `subscription_type` varchar(30) NOT NULL DEFAULT 'Premium Ultra HD',
  `subscription_description` text,
  `price` decimal(5,2) NOT NULL,
  `quality_of_video` varchar(30) NOT NULL DEFAULT '1080p',
  `quality_of_audio` varchar(30) NOT NULL DEFAULT 'Flac',
  PRIMARY KEY (`subcsription_id`),  
  UNIQUE KEY `subcsription_id` (`subcsription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Детали подписки';


DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_type` varchar(100) NOT NULL,
  `category_description` text,
  `restriction_by_age` smallint DEFAULT NULL,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Категория';


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `account_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_email` varchar(100) NOT NULL,
  `account_password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `firstname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(100) NOT NULL,
  `subscription_id` smallint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `account_id` (`account_id`),
  UNIQUE KEY `account_email` (`account_email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `details_of_subcsription_ind` (`subscription_id`),
  CONSTRAINT `details_of_subcsription_ind` FOREIGN KEY (`subscription_id`) REFERENCES `details_of_subcsription` (`subcsription_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Пользователь';


DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `payment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `payment_method` varchar(10) NOT NULL DEFAULT 'Card',
  `amount` decimal(5,2) NOT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `payment_id` (`payment_id`),
  KEY `account_ind` (`account_id`),
  CONSTRAINT `account_ind` FOREIGN KEY (`account_id`) REFERENCES `users` (`account_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Платежные данные';


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
  `profile_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account` bigint unsigned NOT NULL,
  `profile_nickname` varchar(30) NOT NULL DEFAULT 'User', 
  `profile_language` varchar(30) NOT NULL DEFAULT 'English',
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `profile_id` (`profile_id`),
  KEY `account_profile_ind` (`account`),
  CONSTRAINT `account_profile_ind` FOREIGN KEY (`account`) REFERENCES `users` (`account_id`) ON DELETE RESTRICT ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Настройки профиля';


DROP TABLE IF EXISTS `films`;
CREATE TABLE `films` (
  `film_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `film_name` varchar(100) NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `description` text,
  `release_year` date DEFAULT NULL,
  `rating` decimal(4,2) NOT NULL DEFAULT '5.00',
  `length_of_film` smallint DEFAULT NULL,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_id`),
  UNIQUE KEY `film_id` (`film_id`),
  UNIQUE KEY `film_name` (`film_name`),
  KEY `category_ind` (`category_id`),
  CONSTRAINT `category_ind` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Данные по фильмам';


DROP TABLE IF EXISTS `language_audio_of_film`;
CREATE TABLE `language_audio_of_film` (
  `language_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `film_id` bigint unsigned NOT NULL,
  `language_name` varchar(20) NOT NULL,
  `url_audio` varchar(1000) NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `language_id` (`language_id`),
  KEY `language_audio_of_film_ind` (`film_id`),
  CONSTRAINT `language_audio_of_film_ind` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Озвучка';


DROP TABLE IF EXISTS `language_subtitle_of_film`;
CREATE TABLE `language_subtitle_of_film` (
  `subtitle_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `film_id` bigint unsigned NOT NULL,
  `subtitle_name` varchar(20) NOT NULL,
  `url_subtitle` varchar(1000) NOT NULL,
  PRIMARY KEY (`subtitle_id`),
  UNIQUE KEY `subtitle_id` (`subtitle_id`),
  KEY `language_subtitle_of_film_ind` (`film_id`),
  CONSTRAINT `language_subtitle_of_film_ind` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Субтитры';


DROP TABLE IF EXISTS `saved_list_to_watch`;
CREATE TABLE `saved_list_to_watch` (
  `session_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` bigint unsigned NOT NULL,
  `film_id` bigint unsigned NOT NULL,
  `language_id` bigint unsigned NOT NULL,  
  `subtitle_id` bigint unsigned NOT NULL,  
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `saved_list_to_watch_ind1` (`profile_id`),
  KEY `saved_list_to_watch_ind2` (`film_id`),
  KEY `saved_list_to_watch_ind3` (`language_id`),
  KEY `saved_list_to_watch_ind4` (`subtitle_id`),
  CONSTRAINT `saved_list_to_watch_ind1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`profile_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `saved_list_to_watch_ind2` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `saved_list_to_watch_ind3` FOREIGN KEY (`language_id`) REFERENCES `language_audio_of_film` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE,  
  CONSTRAINT `saved_list_to_watch_ind4` FOREIGN KEY (`subtitle_id`) REFERENCES `language_subtitle_of_film` (`subtitle_id`) ON DELETE RESTRICT ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Сохраненный список';


DROP TABLE IF EXISTS `cast_actors`;
CREATE TABLE `cast_actors` (
  `actor_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `actor_name` varchar(100) NOT NULL,
  `birthday` date DEFAULT NULL,
  `film_id` bigint unsigned NOT NULL,
  `role_description` text,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`),
  UNIQUE KEY `actor_id` (`actor_id`),
  UNIQUE KEY `actor_name` (`actor_name`),
  KEY `cast_ind1` (`film_id`),
  CONSTRAINT `cast_ind1` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Актерский состав';


DROP TABLE IF EXISTS `viewing_history`;
CREATE TABLE `viewing_history` (
  `session_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` bigint unsigned NOT NULL,
  `film_id` bigint unsigned NOT NULL,
  `ip_adress` varchar(50) DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `viewing_history_ind1` (`profile_id`),
  KEY `viewing_history_ind2` (`film_id`),
  CONSTRAINT `viewing_history_ind1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`profile_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `viewing_history_ind2` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='История просмотров';


DROP TABLE IF EXISTS `ratings`;
CREATE TABLE `ratings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rated_by_profile_id` bigint unsigned NOT NULL,
  `film_id` bigint unsigned NOT NULL,
  `user_rating` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `rated_user` (`rated_by_profile_id`),
  KEY `rated_film` (`film_id`),
  CONSTRAINT `rated_film` FOREIGN KEY (`film_id`) REFERENCES `films` (`film_id`),
  CONSTRAINT `rated_user` FOREIGN KEY (`rated_by_profile_id`) REFERENCES `profiles` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Рейтинги';