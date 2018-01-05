-- Assignment 1

-- Problem 1
SELECT DISTINCT
  dest,
  distance
FROM flights
ORDER BY distance DESC
LIMIT 5;

SELECT name
FROM airports
WHERE faa = 'HNL';

-- Problem 2
SELECT 
  engines,
  MAX(seats) AS max_seats
FROM planes
GROUP BY engines
ORDER BY engines;

SELECT DISTINCT
  CONCAT(manufacturer, ' ', model) as 'aircraft',
  engines,
  seats
FROM planes
WHERE engines = 1 AND seats = 16
  OR engines = 2 AND seats = 400
  OR engines = 3 AND seats = 379
  OR engines = 4 AND seats = 450
ORDER BY engines;

-- Problem 3
SELECT COUNT(*) AS 'total_flights' FROM flights;

-- Problem 4
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY carrier;


-- Problem 5
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY total_flights DESC;

-- Problem 6
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY total_flights DESC
LIMIT 5;

-- Problem 7
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
WHERE distance >= 1000
GROUP BY carrier
LIMIT 5;

-- Problem 8
SELECT
  carrier,
  AVG(dep_delay) AS 'mean_delay'
FROM flights
GROUP BY carrier
ORDER BY mean_delay;

 