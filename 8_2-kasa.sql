-- Task: Do so that for a given day on one Kasa there could be only one Kasier
--       and one Kasier can only be on one Kasa.

CREATE TABLE Kasier(
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Kasa(
    id INT PRIMARY KEY
);

CREATE TABLE Smqna(
    id INT PRIMARY KEY,
    kasier INT,
    kasa INT,
    day INT,
    
    FOREIGN KEY (kasier) references Kasier(id),
    FOREIGN KEY (kasa) references Kasa(id),
    UNIQUE(day, kasa),
    UNIQUE(day, kasier)
);

INSERT INTO Kasier(id, name) VALUES (1, 'Ivan'), (2, 'Gosho');

INSERT INTO Kasa(id) VALUES (1), (2);

-- This will fail because Kasier with ids 1 and 2 on day 1 will be both on
-- Kasa with id 1.
-- INSERT INTO Smqna(id, kasier, kasa, day) VALUES (1, 1, 1, 1), (2, 2, 1, 1);

-- This will fail because Kasier with id 1 on day 1 will be both on Kasa with
-- ids 1 and 2.
-- INSERT INTO Smqna(id, kasier, kasa, day) VALUES (1, 1, 1, 1), (2, 1, 2, 1);
