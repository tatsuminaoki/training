-- 今回インデックスについては考えません
--
-- 作業用データベースの作成 
CREATE DATABASE IF NOT EXISTS `fril_toyonaga`
;
-- ユーザー
-- [メモ] 
-- email ascii 使いたいところ
-- password_digest Railsのログイン機構を利用予定
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `digest_password` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_on_email` (`email`)
) ENGINE=InnoDB
;

-- タスク
-- [メモ] 
-- content Webアプリ側で文字数制限を入れる。また、下書き保存は認めない
-- priority ※ 任意項目
-- expire_date ※ 任意項目 日付を入力する (時間は入力しない)
-- status enum にしたいがステータス種類が変更の可能性ありのため int 
-- label ※ 1つだけ入力予定
CREATE TABLE `tasks` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`user_id` int(10) unsigned NOT NULL,
	`name` varchar(50) NOT NULL,
	`content` text NOT NULL,
	`priority` smallint unsigned DEFAULT NULL,
	`expire_date` DATE DEFAULT NULL,
	`status` tinyint unsigned NOT NULL DEFAULT 0,
	`label` varchar(20) NOT NULL,
	`created_at` datetime NOT NULL,
	`updated_at` datetime NOT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `fk_taks_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB
