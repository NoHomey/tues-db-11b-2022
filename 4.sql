-- Which are the users that have at least 2 orders with price that is at least 50% of the avarage price of their orders?

-- You can use https://www.mycompiler.io/new/sql to run this script and modify it if you don't have local MySQL running.

CREATE TABLE Book (
    id INT PRIMARY KEY,
    name VARCHAR(256),
    price FLOAT
);

INSERT INTO Book(id, name, price) VALUES (0, 'Book1', 10), (1, 'Book2', 20);

CREATE TABLE User (
    id INT PRIMARY KEY,
    name VARCHAR(256)
);

INSERT INTO User(id, name) VALUES (0, 'Ivan'), (1, 'Georgi');

CREATE TABLE `Order` (
    id INT PRIMARY KEY,
    user INT NOT NULL,
    FOREIGN KEY (user) REFERENCES User(id)
);

INSERT INTO `Order`(id, user) VALUES (0, 0), (1, 1), (2, 0);

CREATE TABLE OrderItem (
    id INT PRIMARY KEY,
    `order` INT NOT NULL,
    book INT NOT NULL,
    FOREIGN KEY (`order`) REFERENCES `Order`(id),
    FOREIGN KEY (book) REFERENCES Book(id)
);

INSERT INTO OrderItem(id, `order`, book) VALUES (0, 0, 0), (1, 1, 1), (2, 0, 1), (3, 2, 0);

WITH
  OrderAndPrice AS (
  SELECT
    OrderItem.`order` AS `order`,
    SUM(Book.price) AS price
  FROM
    OrderItem JOIN Book on OrderItem.book = Book.id
  GROUP BY
    OrderItem.`order`
  ),
  OrderWithPrice AS (  
  SELECT
    `Order`.id AS `order`,
    `Order`.user AS user,
    OrderAndPrice.price AS price
  FROM
    `Order` JOIN OrderAndPrice on `Order`.id = OrderAndPrice.`order`
  ),
  AvgPriceForUser AS (
  SELECT
    user,
    AVG(price) AS price
  FROM
    OrderWithPrice
  GROUP BY
    user
  ),
  MatchingUser AS (
  SELECT
    user
  FROM
    OrderWithPrice
  WHERE price >= 0.5 * (
    SELECT
      price
    FROM 
      AvgPriceForUser
    WHERE
      OrderWithPrice.user = AvgPriceForUser.user
    )
  GROUP BY
    user
  HAVING
    COUNT(*) >= 2
  )
SELECT
  User.name as name
FROM
  MatchingUser JOIN User ON MatchingUser.user = User.id
;
