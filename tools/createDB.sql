CREATE DATABASE IF NOT EXISTS temperatures;

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

INSERT INTO sensors (label, path) VALUES ('Exterieur',       '/sys/bus/w1/devices/28-000004549bbe/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Etage',           '/sys/bus/w1/devices/28-00000454650f/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Rez-de-chaussee', '/sys/bus/w1/devices/28-000004540849/w1_slave');

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
-- Consignes reelle de chauffage
-- ===============================================
DROP TABLE IF EXISTS realsetpoints;
CREATE TABLE realsetpoints (
   id INT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   value DECIMAL(6,3),
   PRIMARY KEY (id)
);

-- Par defaut on met une consigne a 19C
INSERT INTO setpoints (date, value) VALUES (NOW(), 19);
INSERT INTO realsetpoints (date, value) VALUES (NOW(), 19);

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


-- ===============================================
-- Etat reel du thermostat
-- ===============================================
DROP TABLE IF EXISTS realstatus;
CREATE TABLE realstatus (
   id INT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   status BOOLEAN,
   PRIMARY KEY (id)
);

-- Par defaut le thermostat est en mode AUTO (status=null)
INSERT INTO temperatures.`status` (date, status, priority) VALUES (NOW(), null, 3);
-- Par defaut on considere que quelqu'un est present dans la maison
INSERT INTO temperatures.`status` (date, status, priority) VALUES (NOW(), TRUE, 2);
-- Par defaut le chauffage est eteint
INSERT INTO temperatures.`status` (date, status, priority) VALUES (NOW(), FALSE, 1);

INSERT INTO temperatures.`realstatus` (date, status, priority) VALUES (NOW(), TRUE);

SET FOREIGN_KEY_CHECKS=1;
