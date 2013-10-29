USE temperatures;
SET FOREIGN_KEY_CHECKS=0;

-- Capteurs
DROP TABLE IF EXISTS sensors;
CREATE TABLE sensors (
   id MEDIUMINT NOT NULL AUTO_INCREMENT,
   label VARCHAR(64) NOT NULL,
   path VARCHAR(128) NOT NULL,
   PRIMARY KEY (id)
);
INSERT INTO sensors (label, path) VALUES ('Extérieur',       '/sys/bus/w1/devices/28-000004540849/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Etage',           '/sys/bus/w1/devices/28-00000454650f/w1_slave');
INSERT INTO sensors (label, path) VALUES ('Rez-de-chaussée', '/sys/bus/w1/devices/28-000004549124/w1_slave');

-- Enregistrements de temperatures
DROP TABLE IF EXISTS records;
CREATE TABLE records (
   id MEDIUMINT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   value DECIMAL(6,3) NOT NULL,
   sensorId MEDIUMINT,
   PRIMARY KEY (id),
   FOREIGN KEY (`sensorId`) REFERENCES `sensors` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Consignes de chauffage
DROP TABLE IF EXISTS setpoints;
CREATE TABLE setpoints (
   id MEDIUMINT NOT NULL AUTO_INCREMENT,
   date DATETIME NOT NULL,
   state BOOLEAN NOT NULL,
   value DECIMAL(6,3),
   PRIMARY KEY (id)
);


SET FOREIGN_KEY_CHECKS=1;
