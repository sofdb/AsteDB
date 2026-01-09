CREATE TABLE Utente (
    ID_utente INT PRIMARY KEY,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE, 
    Password VARCHAR(20) NOT NULL,
    Data_registrazione DATE NOT NULL
);

CREATE TABLE Cliente (
  ID_cliente INT PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL,
  Cognome VARCHAR(100) NOT NULL,
  Indirizzo_spedizione_predef VARCHAR(255) NOT NULL,
  FOREIGN KEY (ID_cliente) REFERENCES Utente(ID_utente) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Venditore (
  ID_venditore INT PRIMARY KEY,
  P_IVA VARCHAR(16) NOT NULL UNIQUE,
  Tipo_venditore VARCHAR(7) NOT NULL CHECK (Tipo_venditore IN ('azienda', 'privato')),
  FOREIGN KEY (ID_venditore) REFERENCES Utente(ID_utente) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Categoria (
  Nome_categoria VARCHAR(100) PRIMARY KEY,
  Descrizione TEXT NOT NULL
);

CREATE TABLE Oggetto (
  Titolo VARCHAR(100) PRIMARY KEY,
  Descrizione TEXT NOT NULL,
  Valore_iniziale DECIMAL(10,2) NOT NULL DEFAULT 0,
  Data_inserimento DATE NOT NULL,
  Stato_oggetto VARCHAR(9) NOT NULL CHECK (Stato_oggetto IN ('venduto', 'invenduto')),
  Venditore INT NOT NULL,
  Categoria VARCHAR(100) NOT NULL,
  FOREIGN KEY (Venditore) REFERENCES Venditore(ID_venditore) ON UPDATE CASCADE ON DELETE NO ACTION, -- non si può eliminare un venditore se ha oggetti collegati e gli oggetti non possono sussistere senza un venditore
  FOREIGN KEY (Categoria) REFERENCES Categoria(Nome_categoria) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Asta (
  ID_asta INT PRIMARY KEY,
  Data_inizio DATE NOT NULL,
  Data_fine DATE NOT NULL,
  Stato_asta VARCHAR(8) NOT NULL CHECK (Stato_asta IN ('attiva', 'conclusa')),
  Oggetto VARCHAR(100)  NOT NULL,
  FOREIGN KEY (Oggetto) REFERENCES Oggetto(Titolo) ON UPDATE CASCADE ON DELETE NO ACTION -- non eliminare un oggetto se ci sono aste collegate
);

CREATE TABLE Partecipazione (
  Utente INT NOT NULL,
  Asta INT NOT NULL,
  PRIMARY KEY (Utente, Asta),
  FOREIGN KEY (Utente) REFERENCES Utente(ID_utente) ON UPDATE CASCADE ON DELETE NO ACTION, -- mantiene lo storico delle partecipazioni per verificare l'effettiva partecipazione in passato per recensioni
  FOREIGN KEY (Asta) REFERENCES Asta(ID_asta) ON UPDATE CASCADE ON DELETE NO ACTION -- mantiene lo storico delle partecipazioni per verificare l'effettiva partecipazione in passato per recensioni
);

CREATE TABLE Recensione (
  ID_recensione INT PRIMARY KEY,
  Data_recensione DATE NOT NULL,
  Ora_recensione TIME NOT NULL,
  Punteggio INT NOT NULL CHECK (Punteggio BETWEEN 1 AND 5),
  Commento TEXT,
  Autore INT NOT NULL,
  Destinatario INT NOT NULL,
  Asta INT NOT NULL,
  FOREIGN KEY (Autore) REFERENCES Utente(ID_utente) ON UPDATE CASCADE ON DELETE NO ACTION, -- mantiene lo storico delle recensioni fatte da un partecipante
  FOREIGN KEY (Destinatario) REFERENCES Utente(ID_utente) ON UPDATE CASCADE ON DELETE NO ACTION, -- mantiene lo storico delle recensioni ricevuto da un partecipante
  FOREIGN KEY (Asta) REFERENCES Asta(ID_asta) ON UPDATE CASCADE ON DELETE NO ACTION -- mantiene lo storico delle recensioni tra partecipanti alla stessa asta
);

CREATE TABLE Offerta (
  ID_offerta INT PRIMARY KEY,
  Data_offerta DATE NOT NULL,
  Ora_offerta TIME NOT NULL,
  Stato_offerta VARCHAR(8) NOT NULL CHECK (Stato_offerta IN ('vincente', 'perdente')),
  Importo DECIMAL(10,2) NOT NULL,
  Asta INT NOT NULL,
  Cliente INT NOT NULL,
  FOREIGN KEY (Asta) REFERENCES Asta(ID_asta) ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY (Cliente) REFERENCES Cliente(ID_cliente) ON UPDATE CASCADE ON DELETE NO ACTION,
  UNIQUE(Cliente, Asta, Data_offerta, Ora_offerta)
);

CREATE TABLE Pagamento (
  ID_pagamento INT PRIMARY KEY,
  Data_pagamento DATE NOT NULL,
  Metodo VARCHAR(8) NOT NULL CHECK (Metodo IN ('Carta', 'PayPal', 'Bonifico')),
  FOREIGN KEY (ID_pagamento) REFERENCES Offerta(ID_offerta) ON UPDATE CASCADE ON DELETE NO ACTION -- non si può cancellare un'offerta se è associata ad un pagamento
);

-- Popolamento utente
INSERT INTO Utente (ID_utente, Telefono, Email, Password, Data_registrazione) VALUES
(1, '000001234567890', 'pierpaolo.grifeo@email.com', 'password123', '2025-05-27'),
(2, '000081531952058', 'azienda2@business.com', 'password234', '2025-05-10'),
(3, '000000987654321', 'emilio.platini@email.com', 'password456', '2025-03-09'),
(4, '000001234509876', 'claudia.iannucci@email.com', 'password789', '2024-05-29'),
(5, '000059532787747', 'berenice.zetticci@email.com', 'password321', '2020-12-13'),
(6, '000005678901234', 'rembrandt.malipiero@email.com', 'password654', '2025-03-14'),
(7, '000006789012345', 'pasquale.stucchi@email.com', 'password987', '2021-06-29'),
(8, '000059255562588', 'imelda.malacarne@email.com', 'password741', '2021-10-15'),
(9, '000055852398680', 'eraldo.borromini@email.com', 'password852', '2023-09-24'),
(10, '000076527758416', 'azienda10@business.com', 'password963', '2020-06-10'),
(11, '000078527758426', 'azienda11@business.com', 'password159', '2020-10-21'),
(12, '000007890123456', 'adelasia.sagredo@email.com', 'password753', '2025-02-04'),
(13, '000008901234567', 'manuel.parri@email.com', 'password456', '2021-01-11'),
(14, '000009012345678', 'vincenzo.ramazzotti@email.com', 'password678', '2022-12-31'),
(15, '000000123456789', 'iolanda.verdone@email.com', 'password987', '2025-04-19'),
(16, '000067473450541', 'azienda16@business.com', 'password111', '2023-03-03'),
(17, '000002345678901', 'ludovica.cianciolo@email.com', 'password222', '2024-07-11'),
(18, '000003456789012', 'adriana.turchetta@email.com', 'password333', '2020-10-19'),
(19, '000004567890123', 'gianpietro.valmarana@email.com', 'password444', '2021-09-13'),
(20, '000005678951234', 'greca.gonzaga@email.com', 'password555', '2022-10-15'),
(21, '000012172715518', 'imelda.guarato@email.com', 'password666', '2021-01-16'),
(22, '000097021355690', 'concetta.tron@email.com', 'password777', '2024-02-19'),
(23, '000001123456789', 'gianna.argan@email.com', 'password333', '2020-11-22'),
(24, '000001223456789', 'federico.impastato@email.com', 'password444', '2025-01-22'),
(25, '000001323456789', 'gianni.luria@email.com', 'password555', '2020-03-16'),
(26, '000009367680123', 'francesca.monti@email.com', 'password111', '2021-02-24'),
(27, '000002914812345', 'fabrizia.monteverdi@email.com', 'password222', '2024-06-09'),
(28, '000057872982595', 'renata.lercari@email.com', 'password333', '2022-07-06'),
(29, '000090010943969', 'luisa.interiano@email.com', 'password444', '2022-05-08'),
(30, '000071473210469', 'dionigi.bassi@email.com', 'password555', '2024-11-01'),
(31, '000006706512345', 'emilio.maderno@email.com', 'password666', '2024-04-01'),
(32, '000027868144739', 'pasqual.orengo@email.com', 'password777', '2025-03-21'),
(33, '000001043212345', 'gianpietro.pavone@email.com', 'password888', '2025-05-14'),
(34, '000005978212345', 'benito.mastroianni@email.com', 'password999', '2023-02-09'),
(35, '000025177852892', 'alina.cuda@email.com', 'password000', '2025-05-26'),
(36, '000003884912345', 'olga.mennea@email.com', 'password123', '2024-12-27'),
(37, '000001249912345', 'stefania.tremonti@email.com', 'password234', '2020-09-19'),
(38, '000092247466268', 'helena.grigi@email.com', 'jucfc8uf', '2023-09-08'),
(39, '000007826312345', 'gianluca.carli@email.com', 'password345', '2020-06-22'),
(40, '000002053912345', 'giampiero.giannone@email.com', 'password456', '2023-02-10'),
(41, '000087339500479', 'cirillo.pace@email.com', 'password567', '2025-01-06'),
(42, '000047364710276', 'azienda42@business.com', 'password678', '2023-09-15'),
(43, '000001234512345', 'maria.rossi@email.com', 'password123', '2023-06-18'),
(44, '000005273512345', 'adele.sordi@email.com', 'password789', '2023-10-04'),
(45, '000001476712345', 'piero.sansoni@email.com', 'password890', '2023-12-07'),
(46, '000071838214710', 'giorgio.verdi@email.com', 'dq444l8o', '2020-10-19'),
(47, '000005562312345', 'elvira.luna@email.com', 'password901', '2025-01-29'),
(48, '000003124312345', 'susanna.mastroianni@email.com', 'password012', '2024-12-08'),
(49, '000078291146786', 'azienda49@business.com', 'password123', '2021-03-09'),
(50, '000007947312345', 'milena.calvo@email.com', 'password234', '2025-01-03'),
(51, '000016245650609', 'azienda51@business.com', 'password345', '2021-08-16'),
(52, '000001718712345', 'susanna.farnese@email.com', 'password456', '2021-12-28'),
(53, '000006899812345', 'lorenzo.nievo@email.com', 'password567', '2022-03-07'),
(54, '000003455812345', 'daria.tiepolo@email.com', 'password678', '2023-02-11'),
(55, '000009909112345', 'sandro.tedesco@email.com', 'password789', '2022-11-01'),
(56, '000022583132370', 'azienda56@business.com', 'password890', '2025-03-10'),
(57, '000089702838578', 'azienda57@business.com', 'password901', '2021-01-16'),
(58, '000006562712345', 'adriano.nievo@email.com', 'password012', '2020-11-28'),
(59, '000002480812345', 'francesco.travaglia@email.com', 'password123', '2020-09-03'),
(60, '000003696812345', 'sophia.mazzi@email.com', 'password234', '2024-11-07');

-- Popolamento cliente
INSERT INTO Cliente (ID_cliente, Nome, Cognome, Indirizzo_spedizione_predef) VALUES
(1, 'Pierpaolo', 'Grifeo', 'Piazza Neri 626 Piano 9 Appartamento 71, Napoli, 82850 NA'),
-- 2 solo venditore
(3, 'Emilio', 'Platini', 'Borgo Verdi 743 Piano 10 Appartamento 31, Bari, 40145 FI'),
(4, 'Claudia', 'Iannucci', 'Incrocio Grigi 965 Piano 3 Appartamento 4, Napoli, 58302 GE'),
(5, 'Berenice', 'Zetticci', 'Vicolo Bianchi 202 Piano 5 Appartamento 6, Bologna, 16083 BA'),
(6, 'Rembrandt', 'Malipiero', 'Contrada Gialli 792 Piano 3 Appartamento 59, Catania, 25785 MI'),
(7, 'Pasquale', 'Stucchi', 'Borgo Gialli 953 Piano 6 Appartamento 46, Milano, 22406 BA'),
(8, 'Imelda', 'Malacarne', 'Borgo Marroni 186 Piano 9 Appartamento 87, Torino, 56631 MI'),
(9, 'Eraldo', 'Borromini', 'Via Marroni 275 Piano 6 Appartamento 21, Firenze, 47295 BO'),
-- 10 solo venditore
-- 11 solo venditore
(12, 'Adelasia', 'Sagredo', 'Piazza Bianchi 102 Piano 5 Appartamento 63, Genova, 80391 FI'),
(13, 'Manuel', 'Parri', 'Borgo Marroni 865 Piano 2 Appartamento 89, Roma, 70090 NA'),
(14, 'Vincenzo', 'Ramazzotti', 'Strada Verdi 582 Piano 8 Appartamento 28, Napoli, 46059 BO'),
(15, 'Iolanda', 'Verdone', 'Incrocio Verdi 470 Piano 7 Appartamento 18, Genova, 32102 FI'),
(17, 'Ludovica', 'Cianciolo', 'Contrada Rossi 611 Piano 9 Appartamento 13, Catania, 84951 BO'),
(18, 'Adriana', 'Turchetta', 'Strada Rossi 737 Piano 10 Appartamento 67, Catania, 82264 GE'),
(19, 'Gianpietro', 'Valmarana', 'Strada Verdi 140 Piano 9 Appartamento 25, Roma, 15200 CT'),
(20, 'Greca', 'Gonzaga', 'Piazza Viola 793 Piano 6 Appartamento 29, Roma, 82522 BO'),
(21, 'Imelda', 'Guarato', 'Piazza Viola 400 Piano 3 Appartamento 10, Napoli, 36611 MI'),
(22, 'Concetta', 'Tron', 'Vicolo Rossi 738 Piano 10 Appartamento 13, Napoli, 20291 BO'),
(23, 'Gianna', 'Argan', 'Piazza Marroni 454 Piano 5 Appartamento 59, Napoli, 40671 PA'),
(24, 'Federico', 'Impastato', 'Contrada Marroni 979 Piano 9 Appartamento 92, Roma, 64804 BA'),
(25, 'Gianni', 'Luria', 'Viale Verdi 970 Piano 7 Appartamento 5, Bologna, 21012 CT'),
(26, 'Francesca', 'Monti', 'Vicolo Azzurri 261 Piano 6 Appartamento 61, Bari, 30469 MI'),
(27, 'Fabrizia', 'Monteverdi', 'Via Viola 579 Piano 3 Appartamento 73, Torino, 29597 FI'),
(28, 'Renata', 'Lercari', 'Borgo Viola 666 Piano 8 Appartamento 52, Bologna, 29846 BO'),
(29, 'Luisa', 'Interiano', 'Piazza Azzurri 643 Piano 3 Appartamento 89, Bologna, 95309 BO'),
(30, 'Dionigi', 'Bassi', 'Via Viola 279 Piano 6 Appartamento 13, Napoli, 67831 NA'),
(31, 'Emilio', 'Maderno', 'Piazza Viola 504 Piano 5 Appartamento 25, Roma, 62896 TO'),
(32, 'Pasqual', 'Orengo', 'Vicolo Azzurri 381 Piano 10 Appartamento 43, Napoli, 86183 MI'),
(33, 'Gianpietro', 'Pavone', 'Viale Viola 541 Piano 7 Appartamento 41, Bari, 48636 CT'),
(34, 'Benito', 'Mastroianni', 'Via Bianchi 343 Piano 2 Appartamento 48, Genova, 12083 MI'),
(35, 'Alina', 'Cuda', 'Piazza Rosa 940 Piano 8 Appartamento 77, Bologna, 46430 NA'),
(36, 'Olga', 'Mennea', 'Incrocio Gialli 973 Piano 9 Appartamento 40, Genova, 73514 CT'),
(37, 'Stefania', 'Tremonti', 'Piazza Marroni 913 Piano 4 Appartamento 54, Roma, 90629 CT'),
(38, 'Helena', 'Grigi', 'Via Mazzini 89, 90100 Milano (NA)'),
(39, 'Gianluca', 'Carli', 'Borgo Bianchi 875 Piano 1 Appartamento 52, Torino, 89051 RM'),
(40, 'Giampiero', 'Giannone', 'Incrocio Azzurri 526 Piano 2 Appartamento 86, Firenze, 60261 MI'),
(41, 'Cirillo', 'Pace', 'Piazza Azzurri 692 Piano 1 Appartamento 92, Genova, 19114 TO'),
-- 42 solo venditore
(43, 'Maria', 'Rossi', 'Incrocio Verdi 483 Piano 5 Appartamento 22, Palermo, 15889 RM'),
(44, 'Adele', 'Sordi', 'Piazza Grigi 323 Piano 3 Appartamento 86, Palermo, 61957 NA'),
(45, 'Piero', 'Sansoni', 'Strada Bianchi 614 Piano 1 Appartamento 21, Bologna, 58529 FI'),
(46, 'Giorgio', 'Verdi', 'Via Manzoni 66, 20100 Bologna (VR)'),
(47, 'Elvira', 'Luna', 'Rotonda Marroni 372 Piano 9 Appartamento 26, Roma, 16420 TO'),
(48, 'Susanna', 'Mastroianni', 'Viale Rosa 822 Piano 10 Appartamento 9, Milano, 24756 CT'),
-- 49 solo venditore
(50, 'Milena', 'Calvo', 'Rotonda Verdi 922 Piano 10 Appartamento 35, Catania, 13062 TO'),
-- 51 solo venditore
(52, 'Susanna', 'Farnese', 'Strada Bianchi 761 Piano 5 Appartamento 49, Napoli, 87377 BA'),
(53, 'Lorenzo', 'Nievo', 'Piazza Gialli 190 Piano 9 Appartamento 27, Milano, 64873 FI'),
(54, 'Daria', 'Tiepolo', 'Strada Azzurri 296 Piano 9 Appartamento 48, Milano, 30142 MI'),
(55, 'Sandro', 'Tedesco', 'Piazza Gialli 211 Piano 6 Appartamento 91, Palermo, 16165 NA'),
-- 56 solo venditore
-- 57 solo venditore
(58, 'Adriano', 'Nievo', 'Contrada Rosa 533 Piano 9 Appartamento 67, Genova, 43372 RM'),
(59, 'Francesco', 'Travaglia', 'Viale Viola 665 Piano 4 Appartamento 2, Bologna, 37144 CT'),
(60, 'Sophia', 'Mazzi', 'Contrada Neri 616 Piano 3 Appartamento 20, Milano, 17541 TO');

-- Popolamento venditore
INSERT INTO Venditore (ID_venditore, P_IVA, Tipo_venditore) VALUES 
(2, '81531952058', 'azienda'), -- 2025-05-10 ogg 14
(5, '59532787747', 'privato'), -- 2020-12-13 anche cliente ogg 18
(8, '59255562588', 'privato'), -- 2021-10-15 anche cliente ogg 19
(9, '55852398680', 'privato'), -- 2023-09-24 anche cliente ogg 06
(10, '76527758416', 'azienda'), -- 2020-06-10 ogg 03
(11, '78527758426', 'azienda'), -- 2020-10-2 ogg 07 11
(16, '67473450541', 'azienda'), -- 2023-03-03 ogg 09
(21, '12172715518', 'privato'), -- 2021-01-16 anche cliente ogg 15
(22, '97021355690', 'privato'), -- 2024-02-19 anche cliente ogg 01
(28, '57872982595', 'privato'), -- 2022-07-06 anche cliente ogg 12 17
(29, '90010943969', 'privato'), -- 2022-05-08 anche cliente ogg 10
(30, '71473210469', 'privato'), -- 2024-11-01 anche cliente ogg 13
(32, '27868144739', 'privato'), -- 2025-03-21 anche cliente ogg 05
(35, '25177852892', 'privato'), -- 2025-05-26 anche cliente ogg 08
(42, '87339500479', 'privato'), -- 2025-01-06 anche cliente ogg 20 23
(46, '47364710276', 'privato'), -- 2023-09-15 anche cliente ogg 23
(49, '78291146786', 'azienda'), -- 2021-03-09 ogg 02 24
(51, '16245650609', 'azienda'), -- 2021-08-16 ogg 16
(56, '22583132370', 'azienda'), -- 2025-03-10 ogg 21
(57, '89702838578', 'azienda'); -- 2021-01-1 ogg 25

-- Popolamento categoria
INSERT INTO Categoria (Nome_categoria, Descrizione) VALUES
('Elettronica', 'Dispositivi elettronici come smartphone, tablet e laptop.'),
('Abbigliamento', 'Abiti e accessori di moda, nuovi o vintage, per donne, uomini e bambini.'),
('Libri', 'Libri rari, prime edizioni, collezionabili e manuali venduti da privati o librerie.'),
('Sport', 'Attrezzature e abbigliamento sportivo per varie discipline.'),
('Casa e Cucina', 'Arredi, piccoli elettrodomestici e accessori per la casa.'),
('Giocattoli', 'Giocattoli nuovi e da collezione, compresi set LEGO, action figures e altro.'),
('Bellezza', 'Prodotti per la cura della persona, spesso venduti in lotti.'),
('Musica', 'CD, vinili e strumenti musicali.'),
('Videogiochi', 'Console, videogiochi vintage e moderni, collezioni e accessori gaming.'),
('Auto e Moto', 'Ricambi, accessori e articoli da collezione per appassionati di motori.');


-- Popolamento oggetto
INSERT INTO Oggetto (Titolo, Descrizione, Valore_iniziale, Data_inserimento, Stato_oggetto, Venditore, Categoria) VALUES -- Venditore e date da controllare
('ABB_X01', 'Capo alla moda, adatto a ogni stagione.', 205.87, '2024-02-20', 'invenduto', 22, 'Abbigliamento'), 
('LIB_X02', 'Edizione rara o da collezione, perfetta per appassionati.', 140.94, '2021-05-10', 'venduto', 49, 'Libri'), 
('SPO_X03', 'Attrezzatura sportiva usata ma ben tenuta.', 161.67, '2020-07-29', 'venduto', 10, 'Sport'), 
('CAS_X04', 'Accessorio utile per la vita domestica quotidiana.', 67.45, '2024-07-09', 'invenduto', 28, 'Casa e Cucina'), 
('GIO_X05', 'Gioco educativo, perfetto per bambini o collezionisti.', 257.66, '2025-04-16', 'invenduto',32, 'Giocattoli'), 
('BEL_X06', 'Prodotto per la cura personale, confezione integra.', 289.41, '2023-11-27', 'invenduto', 9, 'Bellezza'), 
('MUS_X07', 'Articolo musicale da collezione o uso amatoriale.', 120.27, '2022-12-06', 'invenduto', 11, 'Musica'), 
('VID_X08', 'Titolo o console da gioco in buono stato, usato.', 94.77, '2025-05-26', 'invenduto', 35, 'Videogiochi'),
('ELE_X09', 'Dispositivo tecnologico per uso personale, in ottime condizioni.', 629.50, '2023-03-18', 'invenduto', 16, 'Elettronica'), 
('LIB_X10', 'Edizione rara o da collezione, perfetta per appassionati.', 48.00, '2022-08-22', 'venduto', 29, 'Libri'), 
('MUS_X11', 'Articolo musicale da collezione o uso amatoriale.', 135.75, '2021-03-30', 'venduto', 11, 'Musica'), 
('CAS_X12', 'Accessorio utile per la vita domestica quotidiana.', 89.90, '2025-04-02', 'invenduto', 28, 'Casa e Cucina'),
('ABB_X13', 'Capo alla moda, adatto a ogni stagione.', 72.45, '2023-11-25', 'venduto', 30, 'Abbigliamento'),
('GIO_X14', 'Gioco educativo, perfetto per bambini o collezionisti.', 44.20, '2025-05-28', 'invenduto', 2, 'Giocattoli'),
('SPO_X15', 'Attrezzatura sportiva usata ma ben tenuta.', 159.30, '2022-04-06', 'venduto', 21, 'Sport'),
('BEL_X16', 'Prodotto per la cura personale, confezione integra.', 38.99, '2022-04-11', 'invenduto', 51, 'Bellezza'),
('AUT_X17', 'Accessorio o ricambio per veicoli, originale o compatibile.', 215.00, '2024-07-09', 'venduto', 28, 'Auto e Moto'),
('VID_X18', 'Titolo o console da gioco in buono stato, usato.', 399.99, '2025-05-10', 'venduto', 2, 'Videogiochi'),
('ELE_X19', 'Dispositivo tecnologico per uso personale, in ottime condizioni.', 745.00, '2021-12-01', 'venduto', 8, 'Elettronica'),
('LIB_X20', 'Edizione rara o da collezione, perfetta per appassionati.', 39.90, '2025-01-24', 'invenduto', 42, 'Libri'),
('CAS_X21', 'Accessorio utile per la vita domestica quotidiana.', 52.30, '2025-03-27', 'venduto', 56, 'Casa e Cucina'),
('VID_X22', 'Titolo o console da gioco in buono stato, usato.', 299.99, '2025-02-10', 'invenduto', 5, 'Videogiochi'),
('ABB_X23', 'Capo alla moda, adatto a ogni stagione.', 89.50, '2024-03-31', 'venduto', 42, 'Abbigliamento'),
('GIO_X24', 'Gioco educativo, perfetto per bambini o collezionisti.', 67.25, '2025-01-06', 'invenduto', 49, 'Giocattoli'),
('SPO_X25', 'Attrezzatura sportiva usata ma ben tenuta.', 120.00, '2025-01-30', 'venduto', 57, 'Sport');

-- Popolamento asta
INSERT INTO Asta (ID_asta, Data_inizio, Data_fine, Stato_asta, Oggetto) VALUES
(101, '2024-02-19', '2024-02-26', 'conclusa', 'ABB_X01'),  -- nessuna offerta 
(102, '2025-05-20', '2025-05-30', 'attiva', 'ABB_X01'), -- nessuna offerta vincente
(103, '2021-03-10', '2021-03-14', 'conclusa', 'LIB_X02'), -- offerta vincente
(104, '2020-06-20', '2020-07-02', 'conclusa', 'SPO_X03'), -- offerta vincente
(105, '2022-07-08', '2022-07-22', 'conclusa', 'CAS_X04'), -- nessuna offerta 
(106, '2025-04-10', '2025-05-30', 'attiva', 'CAS_X04'), -- nessuna offerta vincente
(107, '2025-05-01', '2025-05-30', 'attiva', 'GIO_X05'), -- nessuna offerta vincente
(108, '2023-10-05', '2023-10-13', 'conclusa', 'BEL_X06'), -- nessuna offerta 
(109, '2025-04-01', '2025-05-30', 'attiva', 'BEL_X06'), -- nessuna offerta vincente
(110, '2020-10-03', '2020-11-13', 'conclusa','MUS_X07'), -- nessuna offerta 
(111, '2023-04-15', '2024-01-25', 'conclusa', 'MUS_X07'), -- nessuna offerta 
(112, '2025-03-20', '2025-05-30', 'attiva', 'MUS_X07'), -- nessuna offerta vincente
(113, '2025-05-27', '2025-05-30', 'attiva', 'VID_X08'), -- nessuna offerta vincente
(114, '2023-03-22', '2023-05-01', 'conclusa', 'ELE_X09'), -- nessuna offerta 
(115, '2025-01-07', '2025-05-30', 'attiva', 'ELE_X09'), -- nessuna offerta vincente
(116, '2022-06-01', '2022-06-05', 'conclusa', 'LIB_X10'),  -- offerta vincente
(117, '2022-08-05', '2022-08-15', 'conclusa', 'MUS_X11'),  -- offerta vincente
(118, '2024-06-02', '2025-07-12', 'conclusa', 'CAS_X12'), -- nessuna offerta 
(119, '2025-04-18', '2025-05-30', 'attiva', 'CAS_X12'), -- nessuna offerta vincente
(120, '2024-11-12', '2024-11-22', 'conclusa', 'ABB_X13'), -- offerta vincente
(121, '2025-05-08', '2025-05-30', 'attiva', 'GIO_X14'), -- nessuna offerta vincente
(122, '2021-03-16', '2021-04-15', 'conclusa', 'SPO_X15'), -- offerta vincente
(123, '2021-09-09', '2021-11-19', 'conclusa', 'BEL_X16'), -- nessuna offerta vincente
(124, '2023-03-28', '2023-04-07', 'conclusa', 'BEL_X16'), -- nessuna offerta vincente
(125, '2025-04-08', '2025-05-30', 'attiva', 'BEL_X16'), -- nessuna offerta vincente
(126, '2022-09-30', '2022-10-09', 'conclusa', 'AUT_X17'), -- offerta vincente
(127, '2020-12-30', '2021-01-21', 'conclusa', 'VID_X18'), -- offerta vincente
(128, '2021-12-05', '2021-12-23', 'conclusa', 'ELE_X19'), -- offerta vincente
(129, '2025-01-10', '2025-03-21', 'conclusa', 'LIB_X20'), -- nessuna offerta vincente
(130, '2025-05-14', '2025-05-30', 'attiva', 'LIB_X20'), -- nessuna offerta vincente
(131, '2025-04-15', '2025-04-25', 'conclusa', 'CAS_X21'), -- offerta vincente
(132, '2025-03-11', '2025-03-17', 'attiva', 'VID_X22'), -- nessuna offerta vincente
(133, '2023-09-17', '2023-10-04', 'conclusa', 'ABB_X23'), -- offerta vincente
(134, '2025-05-12', '2025-05-30', 'attiva', 'GIO_X24'), -- nessuna offerta vincente
(135, '2022-04-06', '2022-04-28', 'conclusa','SPO_X25'); -- offerta vincente

-- Popolamento partecipazione
INSERT INTO Partecipazione (Utente, Asta) VALUES
(22, 101), -- vend
(22, 102), -- vend
(53, 102),
(21, 102),
(15, 102),
(43, 102),
(49, 103), -- vend
(23, 103),
(25, 103),
(13, 103),
(59, 103),
(10, 104), -- vend
(39, 104),
(25, 104),
(28, 105), -- vend
(28, 106), -- vend
(44, 106),
(32, 106),
(19, 106),
(17, 106),
(32, 107), -- vend
(41, 107),
(38, 107),
(44, 107),
(9, 108), -- vend
(9, 109), -- vend
(28, 109),
(36, 109),
(32, 109),
(4, 109),
(11, 110), -- vend
(11, 111), -- vend
(11, 112), -- vend
(41, 112),
(20, 112),
(15, 112),
(31, 112),
(36, 112),
(35, 113), -- vend
(50, 113),
(26, 113),
(39, 113),
(29, 113),
(40, 113),
(16, 114), -- vend
(16, 115), -- vend
(22, 115),
(30, 115),
(20, 115),
(29, 116), -- vend
(5, 116),
(8, 116),
(58, 116),
(25, 116),
(11, 117), -- vend
(59, 117),
(18, 117),
(39, 117),
(28, 118), -- vend
(28, 119), -- vend
(60, 119),
(3, 119),
(41, 119),
(30, 120), -- vend
(4, 120), 
(46, 120), 
(54, 120), 
(2, 121), -- vend
(26, 121),
(17, 121),
(32, 121),
(19, 121),
(1, 121),
(21, 122), -- vend
(46, 122),
(23, 122),
(18, 122),
(37, 122),
(51, 123), -- vend
(51, 124), -- vend
(51, 125), -- vend
(9, 125),
(26, 125),
(15, 125),
(5, 125),
(28, 126), -- vend
(25, 126), 
(13, 126), 
(2, 127), -- vend
(37, 127),
(23, 127),
(18, 127),
(8, 128), -- vend
(46, 128),
(13, 128),
(26, 128),
(42, 129), -- vend
(42, 130), -- vend
(12, 130),
(17, 130),
(40, 130),
(56, 131), -- vend
(29, 131),
(17, 131),
(30, 131),
(5, 132), -- vend
(13, 132),
(30, 132),
(18, 132),
(31, 132),
(42, 133), -- vend
(43, 133),
(20, 133),
(38, 133),
(49, 134), -- vend
(17, 134),
(55, 134),
(52, 134),
(57, 135), -- vend
(52, 135),
(7, 135),
(53, 135);

-- Popolamento recensione
INSERT INTO Recensione (ID_recensione, Data_recensione, Ora_recensione, Punteggio, Commento, Autore, Destinatario, Asta) VALUES
(1, '2021-03-15', '03:18:07', 5, 'Buon rapporto qualità-prezzo.', 25, 49, 103),
(2, '2020-07-03', '13:10:19', 4, 'Qualità discreta.', 25, 10, 104),
(3, '2020-07-05', '06:31:39', 5, 'Esperienza positiva.', 39, 25, 104),
(4, '2022-06-06', '08:12:36', 5, 'Ottimo prodotto!', 58, 29, 116),
(5, '2022-06-07', '19:45:00', 4, 'NULL', 58, 8, 116),
(6, '2022-06-06', '05:06:37', 5, 'Esperienza positiva.', 58, 5, 116),
(7, '2022-08-16', '10:21:14', 4, NULL, 21, 59, 117),
(8, '2022-08-18', '09:03:35', 3, 'Non come mi aspettavo.', 59, 11, 117),
(9, '2022-08-17', '13:59:16', 5, 'Esperienza positiva.', 11, 59, 117),
(10, '2024-11-23', '19:54:36', 5, 'Esperienza positiva.', 54, 30, 120),
(11, '2021-04-16', '09:06:37', 5, 'Esperienza positiva.', 23, 46, 122),
(12, '2021-12-25', '04:12:47', 4, 'Qualità discreta.', 26, 8, 128),
(13, '2025-04-26', '12:00:56', 5, 'Servizio clienti eccellente.', 17, 56, 131),
(14, '2025-04-26', '20:51:00', 1, NULL, 29, 30, 131),
(15, '2022-04-30', '01:35:17', 3, 'Non come mi aspettavo.', 53, 57, 135);

-- Popolamento offerta
INSERT INTO Offerta (ID_offerta, Asta, Data_offerta, Ora_offerta, Stato_offerta, Importo, Cliente) VALUES
-- 101 nessuna offerta
(1, 102, '2025-05-22', '06:03:37', 'perdente', 222.25, 53),
(2, 102, '2025-05-25', '14:24:16', 'perdente', 230.61, 21),
(3, 102, '2025-05-27', '16:20:35', 'perdente', 240.17, 15),
(4, 102, '2025-05-30', '08:09:59', 'perdente', 245.2, 43),
(5, 103, '2021-03-10', '19:59:15', 'perdente', 143.67, 23),
(6, 103, '2021-03-11', '12:12:08', 'perdente', 147.1, 25),
(7, 103, '2021-03-12', '11:36:07', 'perdente', 150.73, 13),
(8, 103, '2021-03-12', '18:00:06', 'perdente', 152.18, 59),
(9, 103, '2021-03-13', '11:42:33', 'perdente', 153.23, 13),
(10, 103, '2021-03-14', '15:38:20', 'vincente', 157.1, 25),
(11, 104, '2020-06-23', '05:17:58', 'perdente', 205.64, 39),
(12, 104, '2020-06-26', '05:26:02', 'perdente', 211.64, 25),
(13, 104, '2020-06-29', '15:56:26', 'perdente', 218.51, 39),
(14, 104, '2020-07-02', '14:17:13', 'vincente', 221.47, 25),
-- 105 nessuna offerta
(15, 106, '2025-04-22', '02:28:38', 'perdente', 71.06, 44),
(16, 106, '2025-05-05', '13:54:30', 'perdente', 73.74, 32),
(17, 106, '2025-05-17', '04:30:56', 'perdente', 75.64, 19),
(18, 106, '2025-05-30', '05:39:13', 'perdente', 83.18, 17),
(19, 107, '2025-05-10', '19:54:23', 'perdente', 298.65, 41),
(20, 107, '2025-05-20', '23:08:36', 'perdente', 304.3, 38),
(21, 107, '2025-05-30', '18:02:45', 'perdente', 309.19, 44),
-- 108 nessuna offerta
(22, 109, '2025-04-10', '19:21:11', 'perdente', 300.01, 28),
(23, 109, '2025-04-20', '11:59:28', 'perdente', 307.57, 36),
(24, 109, '2025-04-30', '18:11:59', 'perdente', 316.24, 32),
(25, 109, '2025-05-10', '23:23:58', 'perdente', 318.25, 36),
(26, 109, '2025-05-20', '18:00:13', 'perdente', 327.63, 28),
(27, 109, '2025-05-30', '14:29:56', 'perdente', 330.45, 4),
-- 110 nessuna offerta
-- 111 nessuna offerta
(28, 112, '2025-04-03', '12:19:39', 'perdente', 162.26, 41),
(29, 112, '2025-04-17', '11:22:43', 'perdente', 163.43, 20),
(30, 112, '2025-05-01', '15:47:20', 'perdente', 166.14, 15),
(31, 112, '2025-05-15', '20:22:09', 'perdente', 175.01, 31),
(32, 112, '2025-05-30', '03:05:26', 'perdente', 176.25, 36),
(33, 113, '2025-05-27', '21:01:51', 'perdente', 137.74, 50),
(34, 113, '2025-05-28', '02:20:03', 'perdente', 147.08, 26),
(35, 113, '2025-05-28', '11:21:30', 'perdente', 151.39, 39),
(36, 113, '2025-05-29', '01:36:49', 'perdente', 156.23, 29),
(37, 113, '2025-05-30', '15:53:39', 'perdente', 162.72, 40),
-- 114 nessuna offerta
(38, 115, '2025-02-23', '00:27:39', 'perdente', 653.11, 22),
(39, 115, '2025-04-12', '22:18:32', 'perdente', 658.11, 30),
(40, 115, '2025-05-30', '21:09:39', 'perdente', 661.02, 20),
(41, 116, '2022-06-01', '04:12:19', 'perdente', 69.49, 5),
(42, 116, '2022-06-02', '21:59:18', 'perdente', 74.3, 8),
(43, 116, '2022-06-03', '13:23:02', 'perdente', 83.74, 58),
(44, 116, '2022-06-03', '20:56:45', 'perdente', 85.79, 25),
(45, 116, '2022-06-04', '23:37:45', 'perdente', 89.92, 8),
(46, 116, '2022-06-05', '02:07:27', 'vincente', 90.96, 58),
(47, 117, '2022-08-07', '01:48:40', 'perdente', 137.42, 59),
(48, 117, '2022-08-10', '03:43:04', 'perdente', 139.6, 18),
(49, 117, '2022-08-12', '17:36:38', 'perdente', 141.49, 39),
(50, 117, '2022-08-15', '15:43:52', 'vincente', 147.22, 59),
-- 118 nessuna offerta
(51, 119, '2025-04-28', '06:39:17', 'perdente', 99.8, 60),
(52, 119, '2025-05-09', '13:53:34', 'perdente', 108.6, 3),
(53, 119, '2025-05-19', '21:04:15', 'perdente', 118.39, 60),
(54, 119, '2025-05-30', '16:06:00', 'perdente', 121.39, 41),
(55, 120, '2024-11-14', '15:09:33', 'perdente', 87.15, 4),
(56, 120, '2024-11-16', '20:27:11', 'perdente', 95.35, 46),
(57, 120, '2024-11-18', '23:31:10', 'perdente', 97.09, 54),
(58, 120, '2024-11-20', '18:18:12', 'perdente', 103.1, 4),
(59, 120, '2024-11-22', '22:48:51', 'vincente', 112.0, 54),
(60, 121, '2025-05-12', '20:00:36', 'perdente', 69.26, 26),
(61, 121, '2025-05-16', '11:49:32', 'perdente', 71.1, 17),
(62, 121, '2025-05-21', '02:31:10', 'perdente', 79.59, 32),
(63, 121, '2025-05-25', '21:00:27', 'perdente', 88.14, 19),
(64, 121, '2025-05-30', '21:53:04', 'perdente', 96.09, 1),
(65, 122, '2021-03-22', '06:32:33', 'perdente', 208.91, 46),
(66, 122, '2021-03-28', '18:24:06', 'perdente', 218.09, 23),
(67, 122, '2021-04-03', '11:29:50', 'perdente', 223.52, 18),
(68, 122, '2021-04-09', '13:18:39', 'perdente', 228.99, 23),
(69, 122, '2021-04-15', '08:34:10', 'vincente', 234.87, 37),
-- 123 nessuna offerta
-- 124 nessuna offerta
(70, 125, '2025-04-21', '19:38:58', 'perdente', 78.56, 9),
(71, 125, '2025-05-04', '08:37:09', 'perdente', 88.5, 26),
(72, 125, '2025-05-17', '12:24:58', 'perdente', 93.87, 15),
(73, 125, '2025-05-30', '07:36:36', 'perdente', 100.69, 5),
(74, 126, '2022-10-03', '12:28:54', 'perdente', 226.81, 25),
(75, 126, '2022-10-06', '22:08:03', 'perdente', 232.3, 13),
(76, 126, '2022-10-09', '07:05:08', 'vincente', 233.92, 25),
(77, 127, '2021-01-04', '06:18:51', 'perdente', 426.67, 37),
(78, 127, '2021-01-10', '04:24:56', 'perdente', 430.32, 23),
(79, 127, '2021-01-15', '01:27:59', 'perdente', 432.64, 18),
(80, 127, '2021-01-21', '09:06:47', 'vincente', 436.2, 37),
(81, 128, '2021-12-08', '19:57:32', 'perdente', 760.01, 46),
(82, 128, '2021-12-12', '19:35:30', 'perdente', 768.84, 13),
(83, 128, '2021-12-15', '15:15:10', 'perdente', 772.24, 26),
(84, 128, '2021-12-19', '03:51:49', 'perdente', 781.25, 13),
(85, 128, '2021-12-23', '05:52:28', 'vincente', 790.89, 26),
-- 129 nessuna offerta
(86, 130, '2025-05-19', '03:10:37', 'perdente', 53.73, 12),
(87, 130, '2025-05-24', '20:25:48', 'perdente', 58.26, 17),
(88, 130, '2025-05-30', '00:41:07', 'perdente', 64.74, 40),
(89, 131, '2025-04-17', '13:49:01', 'perdente', 73.33, 29),
(90, 131, '2025-04-19', '05:26:05', 'perdente', 82.51, 17),
(91, 131, '2025-04-21', '15:11:10', 'perdente', 87.26, 30),
(92, 131, '2025-04-23', '12:19:31', 'perdente', 92.7, 29),
(93, 131, '2025-04-25', '16:28:03', 'vincente', 101.43, 17),
(94, 132, '2025-03-12', '01:26:04', 'perdente', 349.9, 13),
(95, 132, '2025-03-13', '03:54:57', 'perdente', 358.27, 30),
(96, 132, '2025-03-14', '02:36:22', 'perdente', 362.24, 18),
(97, 132, '2025-03-15', '21:50:04', 'perdente', 365.62, 31),
(98, 132, '2025-03-17', '11:55:35', 'vincente', 372.83, 30),
(99, 133, '2023-09-20', '15:57:35', 'perdente', 100.65, 43),
(100, 133, '2023-09-23', '13:04:20', 'perdente', 107.28, 20),
(101, 133, '2023-09-27', '08:02:14', 'perdente', 108.55, 43),
(102, 133, '2023-09-30', '01:15:08', 'perdente', 113.8, 38),
(103, 133, '2023-10-04', '11:16:58', 'vincente', 117.3, 43),
(104, 134, '2025-05-18', '15:07:48', 'perdente', 104.52, 17),
(105, 134, '2025-05-24', '13:08:12', 'perdente', 110.59, 55),
(106, 134, '2025-05-30', '14:11:26', 'perdente', 114.05, 52),
(107, 135, '2022-04-13', '11:32:22', 'perdente', 142.99, 52),
(108, 135, '2022-04-20', '01:07:20', 'perdente', 146.15, 7),
(109, 135, '2022-04-28', '10:03:57', 'vincente', 148.95, 53);

-- Popolamento pagamento
INSERT INTO Pagamento (ID_pagamento, Data_pagamento, Metodo) VALUES
(10, '2021-03-22', 'PayPal'),
(14, '2020-07-07', 'Bonifico'),
(46, '2022-06-13', 'Bonifico'),
(50, '2022-08-23', 'Carta'),
(59, '2024-11-23', 'PayPal'),
(69, '2021-04-16', 'PayPal'),
(76, '2022-10-10', 'PayPal'),
(80, '2021-01-24', 'Carta'),
(85, '2022-01-08', 'Bonifico'),
(93, '2025-04-28', 'Carta'),
(98, '2025-03-22', 'Bonifico'),
(103, '2023-10-05', 'PayPal'),
(109, '2022-04-29', 'PayPal');

-- Query 1 (join tra tabelle e operatore aggregato MAX): Restituire, per ogni asta attiva, l’offerta con l’importo più alto, con il relativo cliente e l’oggetto in vendita.
SELECT a.ID_asta, o.Titolo AS Oggetto, of.ID_offerta, c.Nome, c.Cognome, of.Importo
FROM Asta a
JOIN Oggetto o ON a.Oggetto = o.Titolo
JOIN Offerta of ON a.ID_asta = of.Asta
JOIN Cliente c ON of.Cliente = c.ID_cliente
WHERE a.Stato_asta = 'attiva'
AND of.Importo = (
    SELECT MAX(Importo) 
    FROM Offerta 
    WHERE Asta = a.ID_asta
)
ORDER BY a.ID_asta;

-- indici
CREATE INDEX idx_asta_oggetto ON Asta USING HASH (Oggetto);
CREATE INDEX idx_offerta_cliente ON Offerta USING HASH (Cliente);
CREATE INDEX idx_asta_stato ON Asta USING HASH (Stato_asta);
CREATE INDEX idx_offerta_asta_importo ON Offerta(Asta, Importo DESC);

-- Query 2 (Group by, con operatore aggregato COUNT): Trovare le aste associate ad oggetti di una determinata categoria (es.Videogiochi) e contare le offerte fatte durante quelle aste. Ordinarle per asta.
SELECT a.ID_asta, COUNT(of.ID_offerta) AS Numero_offerte
FROM Categoria cat
JOIN Oggetto o ON cat.Nome_categoria = o.Categoria
JOIN Asta a ON o.Titolo = a.Oggetto
JOIN Offerta of ON a.ID_asta = of.Asta
WHERE cat.Nome_categoria = 'Videogiochi'
GROUP BY a.ID_asta
ORDER BY a.ID_asta;

-- Query 3 (Group by, operatori aggregati COUNT e AVG): Per ogni utente, mostra quante recensioni ha scritto e il punteggio medio che ha assegnato.
SELECT u.ID_utente, COUNT(r.ID_recensione) AS Numero_recensioni_fatte,
    ROUND(AVG(r.Punteggio), 3)  AS Punteggio_medio_dato
FROM Utente u
JOIN Recensione r ON u.ID_utente = r.Autore
GROUP BY u.ID_utente;

-- Query 4 (Group by, Having e operatore aggregato COUNT): Clienti che hanno partecipato ad almeno x aste (es. 2).
SELECT u.ID_utente, COUNT(DISTINCT p.Asta) AS Numero_aste
FROM Partecipazione p
JOIN Utente u ON p.Utente = u.ID_utente
GROUP BY u.ID_utente
HAVING COUNT(DISTINCT p.Asta) >= 2;

-- Query 5 (Group by, Having e operatore aggregato COUNT): Numero aste associate allo stesso oggetto dopo una determinata data (es. 2022-10-11), ordinate per oggetto.
SELECT o.Titolo, COUNT(a.ID_asta) AS Numero_aste
FROM Oggetto o
JOIN Asta a ON o.Titolo = a.Oggetto
WHERE a.Data_inizio > '2022-10-11'
GROUP BY o.Titolo
HAVING COUNT(a.ID_asta) > 1;