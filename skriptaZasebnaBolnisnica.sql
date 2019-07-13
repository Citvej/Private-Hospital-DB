SET foreign_key_checks=0;
DROP TABLE IF EXISTS drzava;
DROP TABLE IF EXISTS kraj;
DROP TABLE IF EXISTS obcina;
DROP TABLE IF EXISTS posta;
DROP TABLE IF EXISTS naslov;
DROP TABLE IF EXISTS bivanje;
DROP TABLE IF EXISTS tipBivanje;
DROP TABLE IF EXISTS oseba;
DROP TABLE IF EXISTS zavarovanje;
DROP TABLE IF EXISTS zavarovalnica;
DROP TABLE IF EXISTS tipZavarovanje;
DROP TABLE IF EXISTS pregled;
DROP TABLE IF EXISTS osebje;
DROP TABLE IF EXISTS tipOsebje;
DROP TABLE IF EXISTS specializacija;
DROP TABLE IF EXISTS oddelek;
DROP TABLE IF EXISTS zdravljenje;
DROP TABLE IF EXISTS bolezen;
DROP TABLE IF EXISTS tipBolezen;
DROP TABLE IF EXISTS postelja;
DROP TABLE IF EXISTS zdravljenje_postelja;
DROP TABLE IF EXISTS klinicniPrimer;
DROP TABLE IF EXISTS racun;
DROP TABLE IF EXISTS opravljenaStoritev;
DROP TABLE IF EXISTS storitev;
DROP TABLE IF EXISTS cena;
DROP TABLE IF EXISTS oddelek;
SET foreign_key_checks=1;

CREATE TABLE drzava(
	idDrzava INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imeDrzava VARCHAR(45) NOT NULL
);

CREATE TABLE posta(
	postnaStevilka INT NOT NULL PRIMARY KEY,
    imePosta VARCHAR(45) NOT NULL
);

CREATE TABLE obcina(
	idObcina INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imeObcina VARCHAR(45) NOT NULL
);

CREATE TABLE kraj(
	idKraj INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imeKraj VARCHAR(45) NOT NULL,
    drzava_idDrzava INT NOT NULL,
    posta_postnaStevilka INT NOT NULL,
    obcina_idObcina INT NOT NULL
);

ALTER TABLE kraj ADD CONSTRAINT fk_kraj_drzava FOREIGN KEY (drzava_idDrzava) 
REFERENCES drzava (idDrzava) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE kraj ADD CONSTRAINT fk_kraj_posta FOREIGN KEY (posta_postnaStevilka)
REFERENCES posta (postnaStevilka) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE kraj ADD CONSTRAINT fk_kraj_obcina FOREIGN KEY (obcina_idObcina)
REFERENCES obcina (idObcina) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE naslov(
	idNaslov INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ulica VARCHAR(45) NOT NULL,
    hisnaStevilka VARCHAR(6) NOT NULL,
    kraj_idKraj INT NOT NULL
);

ALTER TABLE naslov ADD CONSTRAINT fk_naslov_kraj FOREIGN KEY (kraj_idKraj)
REFERENCES kraj (idKraj) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE zavarovalnica(
	idZavarovalnica INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imeZavarovalnica VARCHAR(45),
    naslov_idNaslov INT NOT NULL
);

ALTER TABLE zavarovalnica ADD CONSTRAINT fk_zavarovalnica_naslov FOREIGN KEY (naslov_idNaslov)
REFERENCES naslov (idNaslov) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE tipZavarovanje(
	idTipZavarovanje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(45) NOT NULL
);

CREATE TABLE zavarovanje(
	stZavarovanje VARCHAR(9) NOT NULL PRIMARY KEY,
    zacetek DATE NOT NULL,
    konec DATE NOT NULL,
    imePodjetjeZavarovanje VARCHAR(45) NOT NULL,
    zavarovalnica_idZavarovalnica INT NOT NULL,
    tipZavarovanje_idTipZavarovanje INT NOT NULL
);

ALTER TABLE zavarovanje ADD CONSTRAINT fk_zavarovanje_zavarovalnica FOREIGN KEY(zavarovalnica_idZavarovalnica)
REFERENCES zavarovalnica (idZavarovalnica) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE zavarovanje ADD CONSTRAINT fk_zavarovanje_tipZavarovanje FOREIGN KEY (tipZavarovanje_idTipZavarovanje)
REFERENCES tipZavarovanje (idTipZavarovanje) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE oseba(
	EMSO CHAR(13) NOT NULL PRIMARY KEY,
    ime VARCHAR(45) NOT NULL,
    priimek VARCHAR(45),
    datRojstvo DATE NOT NULL,
    telefonskaStevilka VARCHAR(20),
    spol INT NOT NULL,
    jePacient TINYINT(1) NOT NULL,
    ePosta VARCHAR(45),
    zavarovanje_stZavarovanje VARCHAR(9) NULL
);

ALTER TABLE oseba ADD CONSTRAINT fk_oseba_zavarovanje FOREIGN KEY (zavarovanje_stZavarovanje)
REFERENCES zavarovanje(stZavarovanje) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE zdravljenje(
	idZdravljenje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    oseba_EMSO CHAR(13) NOT NULL
);

ALTER TABLE zdravljenje ADD CONSTRAINT fk_zdravljenje_oseba FOREIGN KEY (oseba_EMSO)
REFERENCES oseba (EMSO) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE tipBolezen(
	idTipBolezen INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(45) NOT NULL,
    nazivLatinski VARCHAR(45) NOT NULL
);

CREATE TABLE bolezen(
	idBolezen INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    zacetek DATETIME NOT NULL,
    konec DATETIME NULL,
    opomba VARCHAR(255),
    zdravljenje_idZdravljenje INT NOT NULL,
    tipBolezen_idTipBolezen INT NOT NULL
);

ALTER TABLE bolezen ADD CONSTRAINT fk_bolezen_zdravljenje FOREIGN KEY (zdravljenje_idZdravljenje)
REFERENCES zdravljenje (idZdravljenje) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE bolezen ADD CONSTRAINT fk_bolezen_tipBolezen FOREIGN KEY (tipBolezen_idTipBolezen)
REFERENCES tipBolezen (idTipBolezen) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE oddelek(
	idOddelek INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imeOddelek VARCHAR(127) NOT NULL,
    nadstropje VARCHAR(45) NOT NULL,
    soba INT NOT NULL,
    naslov_idNaslov INT NOT NULL
);

ALTER TABLE oddelek ADD CONSTRAINT fk_oddelek_naslov FOREIGN KEY (naslov_idNaslov)
REFERENCES naslov (idNaslov) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE postelja(
	idPostelja INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    oddelek_idOddelek INT NOT NULL
);

ALTER TABLE postelja ADD CONSTRAINT fk_postelja_oddelek FOREIGN KEY (oddelek_idOddelek)
REFERENCES oddelek (idOddelek) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE zdravljenje_postelja(
	idZdravljenje_postelja INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datumCasZacetek DATETIME NOT NULL,
    datumCasKonec DATETIME NULL,
    zdravljenje_idZdravljenje INT NOT NULL,
    postelja_idPostelja INT NOT NULL
);

ALTER TABLE zdravljenje_postelja ADD CONSTRAINT fk_zdravljenje_postelja_zdravljenje FOREIGN KEY (zdravljenje_idZdravljenje)
REFERENCES zdravljenje (idZdravljenje) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE zdravljenje_postelja ADD CONSTRAINT fk_zdravljenje_postelja_postelja FOREIGN KEY (postelja_idPostelja)
REFERENCES postelja (idPostelja) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE tipOsebje(
	idTipOsebje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tipOsebje VARCHAR(45) 
);

CREATE TABLE specializacija(
	idSpecializacija INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(45)
);

CREATE TABLE osebje(
	idOsebje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    oddelek_idOddelek INT NOT NULL,
    tipOsebje_idTipOsebje INT NOT NULL,
    oseba_EMSO CHAR(13) NOT NULL,
    specializacija_idSpecializacija INT NULL
);

CREATE TABLE pregled(
	idPregled INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    casDatumPregled DATETIME NOT NULL,
    osebje_idOsebje INT NOT NULL,
    oseba_EMSO CHAR(13) NOT NULL
);

ALTER TABLE pregled ADD CONSTRAINT fk_pregled_osebje FOREIGN KEY (osebje_idOsebje)
REFERENCES osebje (idOsebje) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE pregled ADD CONSTRAINT fk_pregled_oseba FOREIGN KEY (oseba_EMSO)
REFERENCES oseba (EMSO) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE osebje ADD CONSTRAINT fk_osebje_oddelek FOREIGN KEY (oddelek_idOddelek)
REFERENCES oddelek (idOddelek) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE osebje ADD CONSTRAINT fk_osebje_tipOsebje FOREIGN KEY (tipOsebje_idTipOsebje)
REFERENCES tipOsebje (idTipOsebje) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE osebje ADD CONSTRAINT fk_osebje_oseba FOREIGN KEY (oseba_EMSO)
REFERENCES oseba (EMSO) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE osebje ADD CONSTRAINT fk_osebje_specializacija FOREIGN KEY (specializacija_idSpecializacija)
REFERENCES specializacija (idSpecializacija) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE klinicniPrimer(
	idKlinicniPrimer INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    zdravljenje_idZdravljenje INT NOT NULL,
    osebje_idOsebje INT
);

ALTER TABLE klinicniPrimer ADD CONSTRAINT fk_klinicniPrimer_zdravljenje FOREIGN KEY (zdravljenje_idZdravljenje)
REFERENCES zdravljenje (idZdravljenje) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE racun(
	idRacun CHAR(9) NOT NULL PRIMARY KEY,
    klinicniPrimer_idKlinicniPrimer INT NOT NULL
);

ALTER TABLE racun ADD CONSTRAINT fk_racun_klinicniPrimer FOREIGN KEY (klinicniPrimer_idKlinicniPrimer)
REFERENCES klinicniPrimer (idKlinicniPrimer) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE storitev(
	idStoritev INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(45) NOT NULL
);

CREATE TABLE opravljenaStoritev(
	idOpravljenaStoritev INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    storitev_idStoritev INT NOT NULL,
    osebje_idOsebje INT NOT NULL,
    racun_idRacun CHAR(9) NOT NULL
);

ALTER TABLE opravljenaStoritev ADD CONSTRAINT fk_opravljenaStoritev_racun FOREIGN KEY (racun_idRacun)
REFERENCES racun (idRacun) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE opravljenaStoritev ADD CONSTRAINT fk_opravljenaStoritev_storitev FOREIGN KEY (storitev_idStoritev)
REFERENCES storitev (idStoritev) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE opravljenaStoritev ADD CONSTRAINT fk_opravljenaStoritev_osebje FOREIGN KEY (osebje_idOsebje)
REFERENCES osebje (idOsebje) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE tipBivanje(
	idTipBivanje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tip VARCHAR(45) NOT NULL
);

CREATE TABLE bivanje(
	idBivanje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datumOd DATE NOT NULL,
    datumDo DATE NULL,
    naslov_idNaslov INT NOT NULL,
    tipBivanje_idTipBivanje INT NOT NULL,
    oseba_EMSO CHAR(13) NOT NULL
);

ALTER TABLE bivanje ADD CONSTRAINT fk_bivanje_naslov FOREIGN KEY (naslov_idNaslov)
REFERENCES naslov (idNaslov) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE bivanje ADD CONSTRAINT fk_bivanje_tipBivanje FOREIGN KEY (tipBivanje_idTipBivanje)
REFERENCES tipBivanje (idTipBivanje) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE bivanje ADD CONSTRAINT fk_bivanje_oseba FOREIGN KEY (oseba_EMSO)
REFERENCES oseba (EMSO) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE cena(
	idCena INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    cena DECIMAL(9,2),
    storitev_idStoritev INT NOT NULL
);

ALTER TABLE cena ADD CONSTRAINT fk_cena_storitev FOREIGN KEY (storitev_idStoritev)
REFERENCES storitev (idStoritev) ON DELETE NO ACTION ON UPDATE NO ACTION;

### DODAJANJE PODATKOV V BAZO ###

INSERT INTO drzava VALUES
	(null, 'Slovenija'),
    (null, 'Avstrija'),
    (null, 'Hrvaška'),
    (null, 'Madžarska'),
    (null, 'Rusija');


INSERT INTO posta VALUES
	(1292, 'Ig'),
    (1000, 'Ljubljana'),
    (1355, 'Polhov Gradec'),
    (2000, 'Maribor'),
    (5000, 'Nova Gorica');

INSERT INTO obcina VALUES
	(null, 'Ig'),
    (null, 'Ljubljana'),
    (null, 'Polhov Gradec'),
    (null, 'Maribor'),
    (null, 'Nova Gorica');

INSERT INTO kraj VALUES
	(null, 'Ig', 1, 1292, 1),
    (null, 'Staje', 1, 1292, 1),
    (null, 'Kot', 1, 1292, 1),
    (null, 'Matena', 1, 1292, 1),
    (null, 'Golo', 1, 1292, 1),
    (null, 'Zapotok', 1, 1292, 1),
    (null, 'Tomišelj', 1, 1292, 1),
    (null, 'Iška vas', 1, 1292, 1),
    (null, 'Iška loka', 1, 1292, 1),
    (null, 'Dobravica', 1, 1292, 1);

INSERT INTO naslov VALUES
	(null, 'Banija', '5', 1),
    (null, 'Staje', '1a', 1),
    (null, 'Kot', '15', 1),
    (null, 'Matena', '36', 1),
    (null, 'Golo', '12', 1),
    (null, 'Zapotok', '33c', 1),
    (null, 'Tomišelj', '28', 1),
    (null, 'Iška vas', '56', 1),
    (null, 'Iška loka', '91', 1),
    (null, 'Dobravica', '2', 1);

INSERT INTO tipZavarovanje (naziv) VALUES
	('Osnovno'),
    ('Dopolnilno'),
    ('V tujini');
    
INSERT INTO zavarovalnica VALUES
	(null, 'Adriatic Slovenica zavarovalna družba d.d.', 1),
    (null, 'Generali zavarovalnica d.d.', 2),
    (null, 'Grawe zavarovalnica d.d.', 3),
    (null, 'NLB Vita d.d', 4),
    (null, 'Merkur zavarovalnica d.d.', 5),
    (null, 'Triglav zdravstvena zavarovalnica d.d.', 5),
    (null, 'Vzajemna zdravstvena zavarovalnica d.d.', 6),
    (null, 'Weiner Staedtische zavarovalnica d.d.', 7),
    (null, 'Zavarovalnica Tilia d.d.', 8),
    (null, 'SID - prva kreditna zavarovalnica d.d.', 9),
    (null, 'ZZZS', 10);

INSERT INTO zavarovanje VALUES
	('042632359', '2018-01-01', '2019-12-31', 'MDK', 1, 2),
    ('042632358', '2018-01-01', '2019-12-31', 'MDK', 2, 2),
    ('042632357', '2018-01-01', '2019-12-31', 'MDK', 3, 2),
    ('042632356', '2018-01-01', '2019-12-31', 'MDK', 4, 2),
    ('042632355', '2018-01-01', '2019-12-31', 'MDK', 5, 2),
    ('042632354', '2018-01-01', '2019-12-31', 'MDK', 6, 2),
    ('042632353', '2018-01-01', '2019-12-31', 'MDK', 7, 2),
    ('042632352', '2018-01-01', '2019-12-31', 'MDK', 8, 2),
    ('042632351', '2018-01-01', '2019-12-31', 'FERI', 9, 2),
    ('042632350', '2018-01-01', '2019-12-31', 'ZZZS', 10, 1);

INSERT INTO oseba VALUES 
	('2909995500367', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632359'),
    ('2909995500123', 'Luka', 'Hrgarek', '1995-09-29', '041886970', 0, 0, null, '042632358'),
    ('2909995500321', 'Tatjana', 'Welzer', '1995-09-29', '041886970', 1, 0, null, '042632357'),
    ('2909995500111', 'Neven', 'Jevtić', '1995-09-29', '041886970', 0, 1, 'neven.jevtic@student.um.si', '042632350'),
    ('2909995500112', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632356'),
    ('2909995500113', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632355'),
    ('2909995500114', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632354'),
    ('2909995500115', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632353'),
    ('2909995500116', 'Neven', 'Jevtić', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632352'),
    ('2909995500117', 'Slavica', 'Kodrun', '1995-09-29', '041886970', 1, 1, 'neven.jevtic@student.um.si', '042632351');

INSERT INTO tipBivanje (tip) VALUES
	('Stalno'),
    ('Zacasno');
    
INSERT INTO bivanje VALUES
	(null, '2018-01-01', null, 1, 1, '2909995500367'),
    (null, '2018-01-01', null, 1, 1, '2909995500123'),
    (null, '2018-01-01', null, 1, 1, '2909995500321'),
    (null, '2018-01-01', null, 1, 1, '2909995500111'),
    (null, '2018-01-01', null, 1, 1, '2909995500112'),
    (null, '2018-01-01', null, 1, 1, '2909995500114'),
    (null, '2018-01-01', null, 1, 1, '2909995500115'),
    (null, '2018-01-01', null, 1, 1, '2909995500116'),
    (null, '2018-01-01', null, 1, 1, '2909995500113'),
    (null, '2018-01-01', null, 1, 2, '2909995500117');
    
INSERT INTO zdravljenje VALUES
	(null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115'),
    (null, '2909995500115');
    
INSERT INTO tipBolezen VALUES
	(null, 'Artereoskleroza', 'ASL'),
    (null, 'Srčna Kap', 'Heart Stroke'),
    (null, 'Pljučnica', 'Pneumonia'),
    (null, 'Sladkorna bolezen', 'Diabetus'),
    (null, 'Tuberkuloza', 'Tuberculosis');
    
INSERT INTO bolezen VALUES
	(null, '2018-09-06 22:12:33', '2018-11-06 00:00:00', null, 1, 1),
    (null, '2018-09-06 22:12:33', '2018-11-06 00:00:00', null, 2, 2),
    (null, '2018-09-06 22:12:33', '2018-11-06 00:00:00', null, 3, 3),
    (null, '2018-09-06 22:12:33', '2018-11-06 00:00:00', null, 4, 4),
    (null, '2018-09-06 22:12:33', '2018-11-06 00:00:00', null, 5, 5),
    (null, '2019-09-06 22:12:33', null, null, 1, 1),
    (null, '2019-09-06 22:12:33', null, null, 2, 2),
    (null, '2019-09-06 22:12:33', null, null, 3, 3),
    (null, '2019-09-06 22:12:33', null, null, 4, 4),
    (null, '2019-09-06 22:12:33', null, null, 5, 5);
    
INSERT INTO tipOsebje VALUES
	(null, 'Zdravnik'),
    (null, 'Medicinska sestra'),
    (null, 'Bolničar'),
    (null, 'Kuhar'),
    (null, 'Snažilka');
    
INSERT INTO specializacija VALUES
	(null, 'Anesteziolog'),
    (null, 'Kardiolog'),
    (null, 'Internist'),
    (null, 'Kirurg'),
    (null, 'Psihiatrija');

INSERT INTO oddelek VALUES 
	(null, 'Anesteziologija', 'Pritličje', 1, 1),
    (null, 'Kirurgija', 'Pritličje', 2, 1),
    (null, 'Psihiatrija', 'Pritličje', 3, 1),
    (null, 'Ambulanta', 'Pritličje', 4, 1),
    (null, 'Intenzivna nega', 'Pritličje', 5, 1),
    (null, 'Paradontologija', 'Pritličje', 6, 1),
    (null, 'Zobozdravstvena ambulanta', 'Pritličje', 7, 1),
    (null, 'Nevrokirurgija', 'Pritličje', 8, 1),
    (null, 'Maksiofacialna', 'Pritličje', 9, 1),
    (null, 'Oddelek za plastično kirurgijo I', 'Pritličje', 10, 1);

INSERT INTO osebje VALUES
	(null, 1, 1, '2909995500123', 1),
    (null, 1, 1, '2909995500321', 2),
    (null, 1, 2, '2909995500123', 1),
    (null, 1, 2, '2909995500123', 1),
    (null, 1, 3, '2909995500123', 1),
    (null, 1, 3, '2909995500123', 1),
    (null, 1, 4, '2909995500123', 1),
    (null, 1, 4, '2909995500123', 1),
    (null, 1, 3, '2909995500123', 1),
    (null, 1, 2, '2909995500117', null);
    
INSERT INTO pregled VALUES 
	(null, '2018-11-15 11:45:00', 1, '2909995500367'),
    (null, '2018-10-15 11:45:00', 1, '2909995500367'),
    (null, '2018-11-14 11:45:00', 1, '2909995500367'),
    (null, '2018-11-13 11:45:00', 1, '2909995500367'),
    (null, '2018-11-12 11:45:00', 1, '2909995500367'),
    (null, '2018-11-11 11:45:00', 1, '2909995500367'),
    (null, '2018-11-10 11:45:00', 1, '2909995500367'),
    (null, '2018-11-09 11:45:00', 1, '2909995500367'),
    (null, '2018-11-08 11:45:00', 1, '2909995500123'),
    (null, '2018-11-07 11:45:00', 1, '2909995500123');

INSERT INTO klinicniPrimer VALUES 
	(null, 1, 1),
    (null, 1, 2),
    (null, 1, 3),
    (null, 1, 4),
    (null, 1, 5),
    (null, 1, 6),
    (null, 1, 7),
    (null, 1, 8),
    (null, 1, 9),
    (null, 1, 10);
    
    
INSERT INTO storitev VALUES 
	(null, 'Pregled srca z ultrazvokom'),
    (null, 'Izdelava mavca'),
    (null, 'Operacija srca'),
    (null, 'Operacija kolena'),
    (null, 'Odstranitev ledvičnih kamnov');
    
INSERT INTO racun VALUES
	('0000001', 1),
    ('0000002', 2),
    ('0000003', 3),
    ('0000004', 4),
    ('0000005', 5),
    ('0000006', 6),
    ('0000007', 7),
    ('0000008', 8),
    ('0000009', 9),
    ('0000010', 10);
    
INSERT INTO opravljenaStoritev VALUES
	(null, '2010-01-01', 1, 1, '0000001'),
    (null, '2018-01-01', 1, 1, '0000001'),
    (null, '2018-01-01', 2, 2, '0000001'),
    (null, '2018-01-01', 2, 2, '0000001'),
    (null, '2018-01-01', 3, 2, '0000001'),
    (null, '2018-01-01', 3, 3, '0000001'),
    (null, '2018-01-01', 4, 4, '0000001'),
    (null, '2018-01-01', 4, 4, '0000001'),
    (null, '2018-01-01', 5, 4, '0000001'),
    (null, '2018-01-01', 5, 4, '0000001');
    
INSERT INTO cena VALUES 
	(null, '2018-10-22', 20.55, 1),
    (null, '2018-10-22', 22.55, 1),
    (null, '2018-10-22', 222.55, 2),
    (null, '2018-10-22', 20, 2),
    (null, '2018-10-22', 99.00, 3),
	(null, '2018-10-22', 411, 3),
    (null, '2018-10-22', 99.99, 4),
    (null, '2018-10-22', 22.11, 4),
    (null, '2018-10-22', 29.65, 4),
    (null, '2018-10-22', 330.33, 4);
    
INSERT INTO postelja VALUES
	(NULL, 1),
    (NULL, 2),
    (NULL, 3),
    (NULL, 1),
	(NULL, 1),
    (NULL, 2),
    (NULL, 3),
    (NULL, 1),
    (NULL, 5),
    (NULL, 4),
    (NULL, 1);
    
INSERT INTO zdravljenje_postelja VALUES
	(NULL, '2018-11-11 12:00:00', null, 1, 1),
    (NULL, '2018-11-11 12:00:00', null, 2, 2),
    (NULL, '2018-11-11 12:00:00', null, 3, 3),
    (NULL, '2018-11-11 12:00:00', null, 4, 4),
    (NULL, '2018-11-11 12:00:00', null, 5, 5),
    (NULL, '2018-11-11 12:00:00', null, 6, 6),
    (NULL, '2018-11-11 12:00:00', null, 7, 7),
    (NULL, '2018-11-11 12:00:00', null, 8, 8),
    (NULL, '2018-11-11 12:00:00', null, 9, 9),
    (NULL, '2018-11-11 12:00:00', null, 10, 10);
    
### KONEC DODAJANJA PODATKOV ###bivanje

INSERT INTO oddelek VALUES (null, 'Interna', '2', 2, 1);
INSERT INTO postelja VALUES 
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
	(null, 11),
    (null, 11);
                        
INSERT INTO zdravljenje_postelja VALUES
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 12),
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 13),
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 14),
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 15),
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 16),
	(null, '2018-11-11 00:00:00', '2018-12-10 00:00:00', 1, 17),
	(null, '2018-11-11 00:00:00', null, 1, 18),
	(null, '2018-11-11 00:00:00', null, 1, 19),
	(null, '2018-11-10 00:00:00', '2018-11-11 00:00:00', 1, 20),
	(null, '2018-11-10 00:00:00', '2018-11-11 00:00:00', 1, 21);
    
# 1. Koliko postelj je prostih na oddelku 'Interna'?
SELECT COUNT(idPostelja) as steviloProstihPostelj FROM postelja
LEFT JOIN zdravljenje_postelja ON postelja_idPostelja = postelja.idPostelja
INNER JOIN oddelek ON oddelek_idOddelek = oddelek.idOddelek
WHERE imeOddelek = 'Interna' AND (datumCasKonec IS NOT NULL OR postelja_idPostelja IS NULL);

# 2. Kolikšna je povprečna vrednost storitve?
SELECT idCena, AVG(cena) as povprecnaVrednostStoritve
FROM cena
INNER JOIN storitev ON storitev_idStoritev = storitev.idStoritev
#GROUP BY idStoritev
HAVING idCena IN 
(
	SELECT idCena FROM 
	(
		SELECT idCena, MAX(datum) FROM cena GROUP BY storitev_idStoritev
	) as asd
);

# 3. Koliko 'pregledov srca z ultrazvokom' smo opravili od 1.1.2010 do 30.6.2010?

SELECT COUNT(idOpravljenaStoritev) FROM opravljenaStoritev
INNER JOIN storitev ON storitev_idStoritev = storitev.idStoritev
WHERE naziv = 'Pregled srca z ultrazvokom' AND datum BETWEEN '2010-01-01' AND '2010-06-29';

# 4. Kateri zdravnik je opravil največ storitev?

SELECT osebje_idOsebje, count(idOpravljenaStoritev) as najvec
FROM opravljenaStoritev
GROUP BY osebje_idOsebje
HAVING najvec = 
	(SELECT MAX(najvec) as ma FROM 
		(SELECT osebje_idOsebje, count(idOpravljenaStoritev) as najvec
		FROM opravljenaStoritev
		GROUP BY osebje_idOsebje) as e
    );
    

# 5. Spremeni ime oddelka 'Oddelek za plastično kirurgijo I' v 'Oddelek za plastično kirurgijo roke'.

SET SQL_SAFE_UPDATES = 0;
UPDATE oddelek
    SET imeOddelek = 'Oddelek za plastično kirurgijo roke'
    WHERE imeOddelek = 'Oddelek za plastično kirurgijo I';


# 6. Izbriši medicinsko sestro z imenom 'Slavica Kodrun'.

SET foreign_key_checks = 0; 
DELETE oseba FROM oseba 
INNER JOIN osebje ON oseba_EMSO = oseba.EMSO
INNER JOIN tipOSebje ON tipOsebje_idTipOsebje = tipOsebje.idTipOsebje
WHERE ime = 'Slavica' AND priimek = 'Kodrun' AND tipOsebje = 'Medicinska sestra';


#Trigger

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
	INSERT INTO izbrisanaZavarovalnica VALUES (NULL, OLD.idZavarovalnica, OLD.imeZavarovalnica, OLD.naslov_idNaslov);
    
DELETE zavarovalnica FROM zavarovalnica
WHERE idZavarovalnica = 2;
SET foreign_key_checks = 1; 
SET SQL_SAFE_UPDATES = 1;

select * FROM izbrisanazavarovalnica;