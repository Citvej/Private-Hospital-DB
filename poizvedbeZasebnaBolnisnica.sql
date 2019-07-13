DROP TABLE IF EXISTS izbrisanaZavarovalnica;
CREATE TABLE izbrisanaZavarovalnica(
	idIzbrisanaZavarovalnica INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idZavarovalnica INT NOT NULL,
    imeZavarovalnica VARCHAR(45),
    naslov INT NOT NULL
);

DROP TRIGGER IF EXISTS shraniZavarovalnica;
CREATE TRIGGER shraniZavarovalnica
BEFORE DELETE ON zavarovalnica
FOR EACH ROW
	INSERT INTO izbrisanaZavarovalnica VALUES (NULL, zavarovalnica.idZavarovalnica, zavarovalnica.imeZavarovalnica, zavarovalnica.naslov_idNaslov);











SELECT EMSO, COUNT(idPregled) as najvecPregledov FROM oseba
INNER JOIN pregled ON oseba_EMSO = oseba.EMSO
GROUP BY EMSO
HAVING prestej = 
	(
	SELECT MAX(prestej) FROM 
		(
			SELECT EMSO, COUNT(idPregled) as prestej FROM oseba
			INNER JOIN pregled ON oseba_EMSO = oseba.EMSO
			GROUP BY EMSO
        ) as gda
    )