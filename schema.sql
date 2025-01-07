CREATE TABLE IF NOT EXISTS `roles` (
    `name` VARCHAR(255) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS `role_permissions` (
    `name` VARCHAR(255) NOT NULL,
    `permission` VARCHAR(255) NOT NULL,
    UNIQUE KEY `unique_role_permission` (`name`, `permission`)
);

CREATE TABLE IF NOT EXISTS `player_permissions` (
    `license` VARCHAR(255) NOT NULL,
    `permission` VARCHAR(255) NOT NULL,
    UNIQUE KEY `unique_player_permission` (`license`, `permission`)
);

INSERT IGNORE INTO `roles` (`name`) 
VALUES ('console');

INSERT IGNORE INTO `role_permissions` (`name`, `permission`) 
VALUES ('console', '*');

INSERT IGNORE INTO `player_permissions` (`license`, `permission`) 
VALUES ('0', 'role.console');

INSERT IGNORE INTO `roles` (`name`) 
VALUES ('default');

-- DROP TABLE IF EXISTS `player_permissions`;
-- DROP TABLE IF EXISTS `role_permissions`;
-- DROP TABLE IF EXISTS `roles`;
