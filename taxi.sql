CREATE TABLE `Taxi` (
  `id` UUID PRIMARY KEY,
  `regNum` char(8)
);

CREATE TABLE `Driver` (
  `id` UUID PRIMARY KEY,
  `name` varcha(256)
);

CREATE TABLE `Shift` (
  `taxiID` UUID,
  `driverID` UUID,
  PRIMARY KEY (`taxiID`, `driverID`)
);

CREATE TABLE `Rating` (
  `timeRate` float,
  `distRate` float
);

CREATE TABLE `Course` (
  `id` UUID PRIMARY KEY,
  `taxiID` UUID,
  `regNum` char(8),
  `driverID` UUID,
  `source` varchar(256),
  `destination` varchar(256),
  `startTime` datetime,
  `endTime` datetime,
  `timeRate` float,
  `distRate` float,
  `dist` float
);

ALTER TABLE `Shift` ADD FOREIGN KEY (`taxiID`) REFERENCES `Taxi` (`id`);

ALTER TABLE `Shift` ADD FOREIGN KEY (`driverID`) REFERENCES `Driver` (`id`);

ALTER TABLE `Course` ADD FOREIGN KEY (`taxiID`) REFERENCES `Taxi` (`id`);

ALTER TABLE `Course` ADD FOREIGN KEY (`driverID`) REFERENCES `Driver` (`id`);
