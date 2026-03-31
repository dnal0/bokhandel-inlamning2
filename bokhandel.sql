
-- Skapa och hantera testdata
-- Raderar och återskapar databasen varje gång för att vara ren
DROP DATABASE IF EXISTS Bokhandel;
CREATE DATABASE Bokhandel CHARACTER SET utf8mb4 COLLATE utf8mb4_swedish_ci;
USE Bokhandel;

-- Tabeller (som Inlämning 1 + constraint på Pris > 0)
CREATE TABLE Kunder (
    KundID INT PRIMARY KEY AUTO_INCREMENT,
    Namn VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(20),
    Adress VARCHAR(200)
);

CREATE TABLE Böcker (
    ISBN VARCHAR(20) PRIMARY KEY,
    Titel VARCHAR(200) NOT NULL,
    Författare VARCHAR(100) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL CHECK (Pris > 0),  -- Constraint
    Lager INT NOT NULL DEFAULT 0
);

CREATE TABLE Beställningar (
    Ordernummer INT PRIMARY KEY AUTO_INCREMENT,
    KundID INT NOT NULL,
    Datum DATE NOT NULL,
    Totalsumma DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID) ON DELETE CASCADE
);

CREATE TABLE Orderrader (
    Ordernummer INT NOT NULL,
    ISBN VARCHAR(20) NOT NULL,
    Antal INT NOT NULL DEFAULT 1,
    PRIMARY KEY (Ordernummer, ISBN),
    FOREIGN KEY (ISBN) REFERENCES Böcker(ISBN) ON DELETE RESTRICT,
    FOREIGN KEY (Ordernummer) REFERENCES Beställningar(Ordernummer) ON DELETE CASCADE
);

-- Extra tabell för trigger (loggning av nya kunder)
CREATE TABLE KundLogg (
    LoggID INT PRIMARY KEY AUTO_INCREMENT,
    KundID INT,
    Namn VARCHAR(100),
    Email VARCHAR(255),
    RegistreringsTid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Testdata (som Inlämning 1 + extra för att uppfylla HAVING > 2 beställningar)
INSERT INTO Kunder (Namn, Email, Telefon, Adress) VALUES
('Anna Karlsson', 'Anna@mail.se', '0701234567', 'Storgatan 1, Kalmar'),
('Eric Svensson', 'Eric@mail.se', '0703214567', 'Kungsgatan 4, Stockholm'),
('Kalle Karlsson', 'Kalle@mail.se', '0701234765', 'Kalasgatan 7, Nybro'),
('Johannes Carlsson', 'Johannes@mail.se', '0704532567', 'Nygatan 14, Oskarshamn'),
('Filippa Fjord', 'Filippa@mail.se', '0731234567', 'Storgatan 11, Kalmar'),
('Kajsa Stigsson', 'Kajsa@mail.se', '0761234567', 'Havsgatan 5, Karlskrona'),
('Emma Jonsson', 'Emma@mail.se', '0721234567', 'Lokgatan 2, Stockholm'),
('Jonas Franzen', 'Jonas@mail.se', '0722234567', 'Torggatan 15, Halmstad'),
('Hannes Åfors', 'Hannes@mail.se', '0722224567', 'Pilgatan 22, Kalmar');

INSERT INTO Böcker (ISBN, Titel, Författare, Pris, Lager) VALUES
('978-0161214722', 'Klenoden', 'Klas Östergren', 199.00, 12),
('978-0122533964', 'Julkalas Alfons Åberg', 'Gunilla Bergström', 179.00, 14),
('978-0141439600', 'A Tale of Two Cities', 'Charles Dickens', 349.00, 15),
('978-0156012195', '1984', 'George Orwell', 279.00, 20),
('978-0061120084', 'The Alchemist', 'Paulo Coelho', 329.00, 18),
('978-0747532699', 'Harry Potter and the Philosopher''s Stone', 'J. K. Rowling', 399.00, 25),
('978-0006479888', 'And Then There Were None', 'Agatha Christie', 349.00, 12),
('978-0140449266', 'Dream of the Red Chamber', 'Cao Xueqin', 229.00, 10),
('978-0140301694', 'The Hobbit', 'J. R. R. Tolkien', 429.00, 22),
('978-0140366990', 'Alice''s Adventures in Wonderland', 'Lewis Carroll', 329.00, 16),
('978-0140283297', 'She: A History of Adventure', 'H. Rider Haggard', 179.00, 14),
('978-0385504201', 'The Da Vinci Code', 'Dan Brown', 249.00, 19),
('978-0747538486', 'Harry Potter and the Chamber of Secrets', 'J. K. Rowling', 379.00, 21),
('978-0316769488', 'The Catcher in the Rye', 'J. D. Salinger', 279.00, 13),
('978-0747546245', 'Harry Potter and the Prisoner of Azkaban', 'J. K. Rowling', 329.00, 23),
('978-0747551003', 'Harry Potter and the Goblet of Fire', 'J. K. Rowling', 369.00, 24),
('978-0747591054', 'Harry Potter and the Order of the Phoenix', 'J. K. Rowling', 379.00, 20),
('978-0747581086', 'Harry Potter and the Half-Blood Prince', 'J. K. Rowling', 349.00, 18),
('978-0545010221', 'Harry Potter and the Deathly Hallows', 'J. K. Rowling', 329.00, 26),
('978-0446518628', 'The Bridges of Madison County', 'Robert James Waller', 279.00, 11),
('978-0060975548', 'One Hundred Years of Solitude', 'Gabriel García Márquez', 329.00, 17),
('978-0140283334', 'Lolita', 'Vladimir Nabokov', 199.00, 15);

-- Originalbeställningar
INSERT INTO Beställningar (KundID, Datum, Totalsumma) VALUES 
(1, '2025-11-20', 977.00), 
(3, '2025-11-21', 987.00),  
(5, '2025-11-22', 399.00),
(7, '2025-11-23', 698.00),
(9, '2025-11-24', 916.00);

INSERT INTO Orderrader (Ordernummer, ISBN, Antal) VALUES
(1, '978-0141439600', 2), 
(1, '978-0156012195', 1),  
(2, '978-0061120084', 3),  
(3, '978-0747532699', 1),
(4, '978-0006479888', 2),
(5, '978-0140449266', 4);

-- Extra testdata (så att KundID 1 har >2 beställningar så vi kan testa triggers)
INSERT INTO Beställningar (KundID, Datum, Totalsumma) VALUES 
(1, '2025-12-01', 500.00),
(1, '2025-12-02', 600.00),
(1, '2025-12-03', 700.00);

-- Orderrader till de extra beställningarna (så att stock-trigger triggas)
INSERT INTO Orderrader (Ordernummer, ISBN, Antal) VALUES
(6, '978-0161214722', 1),
(7, '978-0122533964', 2),
(8, '978-0141439600', 3);

-- Kontroll att allt skapades korrekt
SHOW TABLES;
DESCRIBE Kunder;
DESCRIBE Böcker;
DESCRIBE Beställningar;
DESCRIBE Orderrader;
DESCRIBE KundLogg;

-- =============================================
-- Moment 2: Hämta, filtrera och sortera data
-- =============================================
SELECT * FROM Kunder;                                           -- Alla kunder
SELECT * FROM Beställningar;                                    -- Alla beställningar

-- Filtrera kunder baserat på namn och e-post (WHERE)
SELECT Namn, Email, Telefon 
FROM Kunder 
WHERE Namn LIKE '%Karlsson%' AND Email LIKE '%@mail.se%';

-- Sortera produkter (böcker) efter pris (ORDER BY)
SELECT ISBN, Titel, Pris 
FROM Böcker 
ORDER BY Pris DESC;

-- =============================================
-- Moment 3: Modifiera data (UPDATE, DELETE, TRANSAKTIONER)
-- =============================================
-- Exempel: Uppdatera en kunds e-post
START TRANSACTION;
    UPDATE Kunder 
    SET Email = 'anna.ny@mail.se' 
    WHERE KundID = 1;
    
    -- Kontroll under transaktionen
    SELECT KundID, Namn, Email FROM Kunder WHERE KundID = 1;
ROLLBACK;  -- Ångra ändringen

-- Kontroll efter rollback
SELECT KundID, Namn, Email FROM Kunder WHERE KundID = 1;

-- Ta bort en specifik kund (utan beställningar) – CASCADE tar bort relaterade rader
START TRANSACTION;
    DELETE FROM Kunder WHERE KundID = 8;  -- Jonas Franzen (ingen beställning)
ROLLBACK;  -- Rollback så databasen förblir intakt för nästa körning

-- =============================================
-- Moment 4: Arbeta med JOINs & GROUP BY
-- =============================================
-- INNER JOIN – vilka kunder har lagt beställningar
SELECT DISTINCT k.Namn, k.Email
FROM Kunder k
INNER JOIN Beställningar b ON k.KundID = b.KundID;

-- LEFT JOIN – alla kunder, även de utan beställningar
SELECT k.Namn, k.Email, COUNT(b.Ordernummer) AS AntalBestallningar
FROM Kunder k
LEFT JOIN Beställningar b ON k.KundID = b.KundID
GROUP BY k.KundID, k.Namn, k.Email;

-- GROUP BY – antal beställningar per kund
SELECT k.Namn, COUNT(b.Ordernummer) AS AntalBestallningar
FROM Kunder k
LEFT JOIN Beställningar b ON k.KundID = b.KundID
GROUP BY k.KundID, k.Namn
ORDER BY AntalBestallningar DESC;

-- HAVING – endast kunder med fler än 2 beställningar
SELECT k.Namn, COUNT(b.Ordernummer) AS AntalBestallningar
FROM Kunder k
LEFT JOIN Beställningar b ON k.KundID = b.KundID
GROUP BY k.KundID, k.Namn
HAVING AntalBestallningar > 2;

-- =============================================
-- Moment 5: Index, Constraints & Triggers
-- =============================================
-- Index på e-post i Kunder
CREATE INDEX idx_email ON Kunder(Email);

-- Trigger 1: Logga ny kund
DELIMITER //
CREATE TRIGGER log_new_customer
AFTER INSERT ON Kunder
FOR EACH ROW
BEGIN
    INSERT INTO KundLogg (KundID, Namn, Email)
    VALUES (NEW.KundID, NEW.Namn, NEW.Email);
END //
DELIMITER ;

-- Trigger 2: Minska lagersaldo efter ny orderrad
DELIMITER //
CREATE TRIGGER decrease_stock
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Böcker 
    SET Lager = Lager - NEW.Antal 
    WHERE ISBN = NEW.ISBN;
END //
DELIMITER ;

-- Testa triggers
-- Ny kund → logg
INSERT INTO Kunder (Namn, Email, Telefon, Adress) 
VALUES ('Trigger Test', 'trigger@mail.se', '0700000000', 'Testgatan 99');

SELECT * FROM KundLogg ORDER BY LoggID DESC LIMIT 1;

-- Ny orderrad → lagersaldo minskar
SELECT Lager AS Lager_Fore FROM Böcker WHERE ISBN = '978-0161214722';

INSERT INTO Beställningar (KundID, Datum, Totalsumma) VALUES (1, CURDATE(), 199.00);
SET @new_order = LAST_INSERT_ID();
INSERT INTO Orderrader (Ordernummer, ISBN, Antal) VALUES (@new_order, '978-0161214722', 3);

SELECT Lager AS Lager_Efter FROM Böcker WHERE ISBN = '978-0161214722';

-- =============================================
-- Moment 6: Backup & Restore
-- =============================================
-- 
-- Backup I Powershell/CMD
-- mysqldump -u root -p Bokhandel > bokhandel_backup.sql
-- 
-- För att återställa:
-- mysql -u root -p Bokhandel < bokhandel_backup.sql
-- 
-- Testa efter restore:
SELECT Namn, COUNT(b.Ordernummer) AS AntalBestallningar 
FROM Kunder k 
LEFT JOIN Beställningar b ON k.KundID = b.KundID 
GROUP BY k.KundID, k.Namn 
HAVING AntalBestallningar > 2;
