-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'users'
--
-- ---

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `uid` INTEGER NOT NULL DEFAULT NULL,
  `provider` VARCHAR NOT NULL DEFAULT 'NULL',
  `points` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'questions'
--
-- ---

DROP TABLE IF EXISTS `questions`;

CREATE TABLE `questions` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `user_id` INTEGER NOT NULL DEFAULT NULL,
  `content` VARCHAR NOT NULL DEFAULT 'NULL',
  `votes` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'comments'
--
-- ---

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `comment_on` INTEGER NOT NULL DEFAULT answer or question,
  `subject_id` INTEGER NOT NULL DEFAULT NULL,
  `user_id` INTEGER NOT NULL DEFAULT NULL,
  `content` VARCHAR NOT NULL DEFAULT 'NULL',
  `votes` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'tags'
--
-- ---

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `name` VARCHAR NOT NULL DEFAULT 'NULL',
  `subscribed_users` VARCHAR NOT NULL DEFAULT 'NULL' COMMENT 'This will be like a list of the ids of users that have this ',
  `subscribed_questions` VARCHAR NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'answers'
--
-- ---

DROP TABLE IF EXISTS `answers`;

CREATE TABLE `answers` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `question_id` INTEGER NOT NULL DEFAULT NULL,
  `content` VARCHAR NOT NULL DEFAULT 'NULL',
  `votes` INTEGER NULL DEFAULT NULL,
  `user_id` INTEGER NOT NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Foreign Keys
-- ---

ALTER TABLE `questions` ADD FOREIGN KEY (user_id) REFERENCES `users` (`id`);
ALTER TABLE `comments` ADD FOREIGN KEY (user_id) REFERENCES `users` (`id`);
ALTER TABLE `answers` ADD FOREIGN KEY (question_id) REFERENCES `questions` (`id`);
ALTER TABLE `answers` ADD FOREIGN KEY (user_id) REFERENCES `users` (`id`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `users` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `questions` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `comments` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `tags` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `answers` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `users` (`id`,`uid`,`provider`,`points`) VALUES
-- ('','','','');
-- INSERT INTO `questions` (`id`,`user_id`,`content`,`votes`) VALUES
-- ('','','','');
-- INSERT INTO `comments` (`id`,`comment_on`,`subject_id`,`user_id`,`content`,`votes`) VALUES
-- ('','','','','','');
-- INSERT INTO `tags` (`id`,`name`,`subscribed_users`,`subscribed_questions`) VALUES
-- ('','','','');
-- INSERT INTO `answers` (`id`,`question_id`,`content`,`votes`,`user_id`) VALUES
-- ('','','','','');