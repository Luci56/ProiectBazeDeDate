create database proiect_bd
go

use proiect_bd
go

CREATE TABLE Produs (
    id_produs INT PRIMARY KEY IDENTITY(1,1),
    nume VARCHAR(255) NOT NULL,
    cantitate INT NOT NULL,
    categorie VARCHAR(100) NOT NULL
);
EXEC sp_rename 'Produs.nume', 'name', 'COLUMN';



INSERT INTO Produs (nume, cantitate, categorie)
VALUES ('Adidasi albi sport', 50, 'Sport'),
       ('Adidasi negri casual', 40, 'Casual'),
       ('Adidasi albastri de alergare', 30, 'Alergare'),
       ('Adidași roz pentru fitness', 35, 'Fitness'),
       ('Adidași gri pentru alergat', 28, 'Alergare');
SELECT * from Produs;
TRUNCATE TABLE Users;


CREATE TABLE Users (
    id_user INT PRIMARY KEY IDENTITY(1,1),
    nume VARCHAR(255) NOT NULL,
    adresa VARCHAR(500) NOT NULL
);



INSERT INTO Users (nume, adresa)
VALUES ('Ana Maria', 'Strada Principala, Nr. 123, București'),
       ('Mihai Popescu', 'Bulevardul Libertății, Nr. 45, Cluj-Napoca'),
       ('Elena Ionescu', 'Aleea Trandafirilor, Nr. 67, Iași');
SELECT * FROM Users;

CREATE TABLE CosDeCumparaturi (
    id_cos INT PRIMARY KEY IDENTITY(1,1),
    id_user INT FOREIGN KEY REFERENCES Users(id_user)
);
TRUNCATE TABLE CosDeCumparaturi;


-- Presupunând că ID-ul produsului "Adidași albi sport" este 1 și ID-ul utilizatorului "Ana Maria" este 1
INSERT INTO CosDeCumparaturi (id_user)
VALUES (1);
SELECT * FROM CosDeCumparaturi;

CREATE TABLE PlaseazaComanda (
    id_comanda INT PRIMARY KEY IDENTITY(1,1),
    id_user INT FOREIGN KEY REFERENCES Users(id_user),
    data_comanda DATE NOT NULL
);

INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (1, GETDATE());  -- Utilizăm GETDATE() pentru a introduce data curentă
SELECT * FROM PlaseazaComanda;


CREATE TABLE ListaDeComenzi (
    id_lista INT PRIMARY KEY IDENTITY(1,1),
    id_comanda INT FOREIGN KEY REFERENCES PlaseazaComanda(id_comanda),
    id_produs INT FOREIGN KEY REFERENCES Produs(id_produs),
    cantitate_comandata INT NOT NULL
);
DROP TABLE ListaDeComenzi;


INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES (1, 1, 2);  
SELECT * FROM ListaDeComenzi;

Vom afișa produsele care au o cantitate disponibilă pentru comandă (adica, cantitatea > 0).
CREATE VIEW ProduseDisponibile AS
SELECT * FROM Produs WHERE cantitate > 0;

SELECT * FROM ProduseDisponibile;

Vom afișa comenzile care au fost plasate în ultima săptămână.
CREATE VIEW ComenziUltimaSaptamana AS
SELECT * FROM PlaseazaComanda WHERE data_comanda >= DATEADD(WEEK, -1, GETDATE());

SELECT * FROM ComenziUltimaSaptamana;

-- Presupunând că ID-ul utilizatorului "Ana Maria" este 1 și ID-ul produsului "Adidași albaștri de alergare" este 3
INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (1, GETDATE());  -- Utilizăm GETDATE() pentru a introduce data curentă

-- Presupunând că ultima comandă plasată a fost adăugată cu ID-ul 1 în tabelul PlaseazaComanda
INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES (1, 3, 1);  -- Presupunem că Ana Maria dorește o pereche de adidași albaștri de alergare




Vom afișa comenzile care includ produse din categoria 'Alergare'.
CREATE VIEW ComenziCuProduseAlergare AS
SELECT pc.* 
FROM PlaseazaComanda pc
JOIN ListaDeComenzi ldc ON pc.id_comanda = ldc.id_comanda
JOIN Produs p ON ldc.id_produs = p.id_produs
WHERE p.categorie = 'Alergare';
SELECT *FROM ComenziCuProduseAlergare;

-- Afișarea tuturor indexurilor pentru tabelul "Produs"
SELECT 
    ind.name AS IndexName,
    ind.type_desc AS IndexType
FROM sys.indexes ind
JOIN sys.tables t ON ind.object_id = t.object_id
WHERE t.name = 'Produs';

-- Afișarea coloanelor și tipurilor de date pentru tabelul "Produs"
SELECT 
    column_name AS ColumnName,
    data_type AS DataType
FROM information_schema.columns
WHERE table_name = 'Produs';






USE proiect_bd; 
SELECT name AS TableName
FROM sys.tables
ORDER BY name;

USE proiect_bd;  
EXEC sp_columns 'Produs'; 

USE proiect_bd;  
EXEC sp_columns 'Users'; 

USE proiect_bd;  
EXEC sp_columns 'CosDeCumparaturi'; 

USE proiect_bd;  
EXEC sp_columns 'PlaseazaComanda'; 

USE proiect_bd;  
EXEC sp_columns 'ListaDeComenzi'; 

CREATE VIEW VizualizareProduse AS
SELECT id_produs, name, cantitate, categorie
FROM Produs;

CREATE TABLE SecventaProduse (
    id INT IDENTITY(1,1) PRIMARY KEY,
    descriere VARCHAR(255)
);

INSERT INTO SecventaProduse (descriere) VALUES ('Produs 1');
INSERT INTO SecventaProduse (descriere) VALUES ('Produs 2');

CREATE SYNONYM SinonimProduse FOR Produs;

select * from SinonimProduse;


CREATE INDEX idx_name 
ON Produs(name);

SELECT * FROM INFORMATION_SCHEMA.TABLES;

UPDATE Produs
SET cantitate = 120
WHERE id_produs = 1;

SELECT * FROM Produs;

DELETE FROM PlaseazaComanda
WHERE id_comanda = 1;

SELECT * FROM PlaseazaComanda;

UPDATE CosDeCumparaturi
SET quantity = 2
WHERE id_user = 2 AND id_produs = 4;

SELECT id_produs, name
FROM Produs
WHERE categorie = 'Sport';

-- Plasarea comenzii pentru "Adidasi albi sport"
INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (2, GETDATE());

-- Adăugarea detaliilor comenzii pentru "Adidasi albi sport" în ListaDeComenzi
INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES (SCOPE_IDENTITY(), 1, 1);  -- Presupunând că ID-ul comenzii curente este returnat prin SCOPE_IDENTITY()

-- Plasarea comenzii pentru "Adidasi negri casual"
INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (2, GETDATE());

-- Adăugarea detaliilor comenzii pentru "Adidasi negri casual" în ListaDeComenzi
INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES (SCOPE_IDENTITY(), 2, 1);  -- Presupunând că ID-ul comenzii curente este returnat prin SCOPE_IDENTITY()



 Afișarea totalului cheltuit de utilizatorul cu ID-ul 2 pe produsele de tip "Sport".
SELECT 
    p.name AS ProductName,
    ldc.cantitate_comandata AS QuantityOrdered
FROM 
    Produs p
JOIN 
    ListaDeComenzi ldc ON p.id_produs = ldc.id_produs
JOIN 
    PlaseazaComanda pc ON ldc.id_comanda = pc.id_comanda
JOIN 
    Users u ON pc.id_user = u.id_user
WHERE 
    u.nume = 'Ana Maria';

--Afisarea tuturor produselor care nu au fost comandate niciodata
	SELECT 
    p.name AS NumeProdus
FROM 
    Produs p
LEFT JOIN 
    ListaDeComenzi lc ON p.id_produs = lc.id_produs
WHERE 
    lc.id_produs IS NULL;



	-- Adăugare a unei noi comenzi pentru utilizatorul cu ID-ul 2
INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (2, GETDATE());

-- Adăugare detaliilor comenzii pentru produse de tip "Sport"
INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES 
    ((SELECT MAX(id_comanda) FROM PlaseazaComanda), 1, 2),  -- Adidasi albi sport
    ((SELECT MAX(id_comanda) FROM PlaseazaComanda), 2, 1);  -- Adidasi negri casual


	-- Adăugare a unei noi comenzi pentru utilizatorul cu ID-ul 3
INSERT INTO PlaseazaComanda (id_user, data_comanda)
VALUES (3, GETDATE());

-- Adăugare detaliilor comenzii pentru produse de tip "Fitness"
INSERT INTO ListaDeComenzi (id_comanda, id_produs, cantitate_comandata)
VALUES 
    ((SELECT MAX(id_comanda) FROM PlaseazaComanda), 4, 3),  -- Adidasi roz pentru fitness
    ((SELECT MAX(id_comanda) FROM PlaseazaComanda), 5, 2);  -- Adidasi gri pentru alergat



--Afișare numărului total de produse comandate de fiecare utilizator
	SELECT 
    u.nume AS NumeUtilizator,
    COUNT(lc.id_produs) AS NumarProduseComandate
FROM 
    Users u
JOIN 
    PlaseazaComanda pc ON u.id_user = pc.id_user
JOIN 
    ListaDeComenzi lc ON pc.id_comanda = lc.id_comanda
GROUP BY 
    u.nume;

















