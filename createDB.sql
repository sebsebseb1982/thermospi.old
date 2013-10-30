USE temperatures;
SET FOREIGN_KEY_CHECKS=0;

-- ===============================================
-- Capteurs
-- ===============================================
DROP TABLE IF EXISTS sensors;
CREATE TABLE sensors (
   id INT NOT NULL AUTO_INCREMENT,
   label VARCHAR(64) NOT NULL,
   path VARCHAR(128) NOT NULL,
   PRIMARY KEY (id),
   INDEX(id)
);

INSERT INTO sensors (label, path) VALUES ('Extérieur',       '/sys/bus/w1/devices/28-000004540849/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Etage',           '/sys/bus/w1/devices/28-00000454650f/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Rez-de-chaussée', '/sys/bus/w1/devices/28-000004549124/w1_slave');

-- ===============================================
-- Enregistrements de temperatures
-- ===============================================
DROP TABLE IF EXISTS records;
CREATE TABLE records (
   id INT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   value DECIMAL(6,3) NOT NULL,
   sensorId INT,
   PRIMARY KEY (id),
   FOREIGN KEY (`sensorId`) REFERENCES `sensors` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ===============================================
-- Consignes de chauffage
-- ===============================================
DROP TABLE IF EXISTS setpoints;
CREATE TABLE setpoints (
   id INT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   value DECIMAL(6,3),
   PRIMARY KEY (id)
);

-- ===============================================
-- Etat du thermostat
-- ===============================================
DROP TABLE IF EXISTS status;
CREATE TABLE status (
   id INT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   status BOOLEAN,
   priority TINYINT,
   PRIMARY KEY (id)
);

INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:40:00', '%d/%m/%Y %H:%i:%s'), TRUE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:41:00', '%d/%m/%Y %H:%i:%s'), FALSE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:42:00', '%d/%m/%Y %H:%i:%s'), TRUE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:43:00', '%d/%m/%Y %H:%i:%s'), FALSE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:44:00', '%d/%m/%Y %H:%i:%s'), TRUE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:45:00', '%d/%m/%Y %H:%i:%s'), FALSE, 2);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:46:00', '%d/%m/%Y %H:%i:%s'), TRUE, 1);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:46:30', '%d/%m/%Y %H:%i:%s'), TRUE, 2);
INSERT INTO temperatures.`status` (date, status, priority) VALUES (STR_TO_DATE( '17/07/2013 12:47:00', '%d/%m/%Y %H:%i:%s'), FALSE, 1);

SET FOREIGN_KEY_CHECKS=1;
