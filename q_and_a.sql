CREATE TABLE `User` (
  `id` UUID PRIMARY KEY,
  `name` varchar(128),
  `email` varchar(256),
  `hashedPass` char(256)
);

CREATE TABLE `Question` (
  `id` UUID PRIMARY KEY,
  `creator` UUID,
  `title` varchar(256),
  `content` varchar(4096),
  `votes` unsignedint
);

CREATE TABLE `Answer` (
  `id` UUID PRIMARY KEY,
  `user` UUID,
  `question` UUID,
  `content` varchar(4096),
  `votes` unsignedint
);

CREATE TABLE `Comment` (
  `id` UUID PRIMARY KEY,
  `user` UUID,
  `answer` UUID,
  `content` varchar(4096),
  `votes` unsignedint
);

CREATE TABLE `ReplyTo` (
  `id` UUID PRIMARY KEY,
  `comment` UUID,
  `replyTo` UUID
);

ALTER TABLE `Question` ADD FOREIGN KEY (`creator`) REFERENCES `User` (`id`);

ALTER TABLE `Answer` ADD FOREIGN KEY (`user`) REFERENCES `User` (`id`);

ALTER TABLE `Answer` ADD FOREIGN KEY (`question`) REFERENCES `Question` (`id`);

ALTER TABLE `Comment` ADD FOREIGN KEY (`user`) REFERENCES `User` (`id`);

ALTER TABLE `Comment` ADD FOREIGN KEY (`answer`) REFERENCES `Answer` (`id`);

ALTER TABLE `ReplyTo` ADD FOREIGN KEY (`comment`) REFERENCES `Comment` (`id`);

ALTER TABLE `ReplyTo` ADD FOREIGN KEY (`replyTo`) REFERENCES `Comment` (`id`);
