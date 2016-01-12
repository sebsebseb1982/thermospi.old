USE temperatures;
SET FOREIGN_KEY_CHECKS=0;

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
INSERT INTO realsetpoints (date, value) VALUES (NOW(), 19);
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
INSERT INTO temperatures.`realstatus` (date, status) VALUES (NOW(), TRUE);


SET FOREIGN_KEY_CHECKS=1;
