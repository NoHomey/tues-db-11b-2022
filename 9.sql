CREATE TABLE Bus(
    id INT primary key,
    number VARCHAR(10)    
);

-- Seat represents a seat in a Bus
CREATE TABLE Seat(
    id INT primary key,
    bus INT NOT NULL,
    number INT,
    foreign key (bus) references Bus(id)
);

-- Drive represents a taken seat during a bus drive
CREATE TABLE Drive(
    id INT,
    seat INT,
    
    foreign key(seat) references Seat(id)
);

INSERT INTO Bus(id, number) VALUES (1, 'ab-1'), (2, 'xy-2'), (3, 'ad-3');

INSERT INTO Seat(id, bus, number) VALUES
    (1, 1, 1), (2,  1, 2), (3, 2, 1), (4, 2, 2), (5, 3, 1);
    
INSERT INTO Drive(id, seat) VALUES
    (1, 1),
    (2, 3),
    (2, 4),
    (3, 1),
    (3, 2);

-- Find how many times each seat has been taken during bus drives.
SELECT
    Seat.id as seat,
    Bus.number as bus,
    COUNT(Drive.seat) as drives
FROM Seat LEFT JOIN Drive ON Drive.seat = Seat.id
                JOIN Bus  ON Seat.bus   = Bus.id
GROUP BY Seat.id;

-- Find all the seats which were never taken durring drives.
SELECT
    Bus.number,
    Seat.number
FROM Seat JOIN Bus ON Seat.bus = Bus.id
WHERE NOT EXISTS (
    SELECT * FROM Drive WHERE Drive.seat = Seat.id
);

-- Fing all Buses that were not droven.
SELECT
    number
FROM Bus
WHERE NOT EXISTS (
    SELECT *
    FROM Drive JOIN Seat ON Drive.seat = Seat.id
    WHERE Seat.bus = Bus.id
);

-- Same as above but by using IN instead of EXISTS.
SELECT
    number
FROM Bus
WHERE id NOT IN (
    SELECT DISTINCT Seat.bus
    FROM Drive JOIN Seat ON Drive.seat = Seat.id
    WHERE Seat.bus = Bus.id
);

-- Find all the bus ids of the buses that have been droven.
SELECT DISTINCT Seat.bus
FROM Drive JOIN Seat ON Drive.seat = Seat.id;

-- Example for a Delete statement
-- DELETE FROM Bus WHERE id = 3;
-- SELECT * FROM BUS;

-- Find all the Buses whose number starts with 'a' and ends with '2'.
SELECT *
FROM Bus
WHERE number LIKE 'a%2';

-- Same as above but with AND of two LIKEs (one for the prefix and one for the suffix).
SELECT *
FROM Bus
WHERE number LIKE 'a%' AND number LIKE '%2';

-- Same as above but done as INTERSECT-ion of two separate queries.
-- NOTE: The table schema of the results must match!
SELECT *
FROM Bus
WHERE number LIKE 'a%'
INTERSECT
SELECT *
FROM Bus
WHERE number LIKE '%2';

-- Finda all the Buses whose number starts with 'a' or ends with '2' by making a UNION of
-- two queries. UNION is interpreted as Set union operation - duplicates are ignored.
SELECT *
FROM Bus
WHERE number LIKE 'a%'
UNION
SELECT *
FROM Bus
WHERE number LIKE '%2';

-- Example of UNION ALL which just concats the result of two queries.
-- NOTE: In 99.99% cases you want the schemas of the two query results to match!
SELECT *
FROM Bus
WHERE number LIKE 'a%'
UNION ALL
SELECT *
FROM Bus
WHERE number LIKE '%2';

-- standard OR example
SELECT * FROM Bus WHERE id=1 OR id=2;

-- The result is the same as above but with IN instead of OR.
-- INs are handy when the list is actually a result of a sub-query.
SELECT * FROM Bus WHERE id IN (1, 2);
