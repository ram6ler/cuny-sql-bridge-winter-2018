# Assignment 1

## Problem 1

> Which destination in the flights database is the furthest distance away, based on information in the flights table?

To get the furthest five destination faa codes:

```sql
SELECT DISTINCT
  dest,
  distance
FROM flights
ORDER BY distance DESC
LIMIT 5;
```
|dest|distance|
|:--|:--|
|HNL|4983|
|HNL|4963|
|ANC|3370|
|SFO|2586|
|OAK|2576|

Curiously, two distances are recorded to HNL. In any case, this is the furthest destination.

To check the airport that this FAA code matches:

```sql
SELECT name
FROM airports
WHERE faa = 'HNL';
```
|name|
|:--|
|Honolulu Intl|

HNL is the FAA code for *Honolulu International Airport*.

Thus, according to the *flights* table, the furthest destination is *Honolulu International Airport*.

## Problem 2

> What are the different numbers of engines in the planes table? For each number of engines, which aircraft have the most number of seats?

To see the maximum number of seats for each value of engine number we can execute the following query:

```sql
SELECT 
  engines,
  MAX(seats) AS max_seats
FROM planes
GROUP BY engines
ORDER BY engines;
```

|engines|max_seats|
|:--|:--|
|1|16|
|2|400|
|3|379|
|4|450|

Then to filter the *planes* table so that it only shows the aircraft (which we can define to be the concatenation of *manufacturer* and *model*) that have the maximum seats in their engine class, we can execute the following query.


```sql
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
```
|aircraft|engines|seats|
|:--|:--|:--|
|DEHAVILLAND OTTER DHC-3|1|16|
|BOEING 777-200|2|400|
|BOEING 777-222|2|400|
|BOEING 777-224|2|400|
|BOEING 777-232|2|400|
|AIRBUS A330-223|3|379|
|BOEING 747-451|4|450|

Now we can clearly see that the single-engine aircraft with the most seats is the *DEHAVILLAND OTTER DHC-3* with 16 seats; the twin-engine aircraft with the most seats is the *BOEING 777* (various models) with 400 seats; the 3-engine aircraft that has the most seats is the *AIRBUS A330-223* with 379 seats; the 4-engine aircraft with the most seats is the *BOEING 747-451* with 450 seats.

## Problem 3

> Show the total number of flights.

We can get the total number of flights by simply counting the number of rows in the *flights* table.

```sql
SELECT COUNT(*) AS 'total_flights' FROM flights;
```
|total_flights|
|:--|
|336776|

The total number of flights in the record is 336776.

## Problem 4

> Show the total number of flights by airline (carrier).

We can achieve this using `GROUP BY` on the previous problem's query:

```sql
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY carrier;
```
|carrier|total_flights|
|:--|:--|
|9E|18460|
|AA|32729|
|AS|714|
|B6|54635|
|DL|48110|
|EV|54173|
|F9|685|
|FL|3260|
|HA|342|
|MQ|26397|
|OO|32|
|UA|58665|
|US|20536|
|VX|5162|
|WN|12275|
|YV|601|


## Problem 5

> Show all of the airlines, ordered by number of flights in descending order.

Ordering the data by the number of flights:

```sql
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY total_flights DESC;
```

|carrier|total_flights|
|:--|:--|
|UA|58665|
|B6|54635|
|EV|54173|
|DL|48110|
|AA|32729|
|MQ|26397|
|US|20536|
|9E|18460|
|WN|12275|
|VX|5162|
|FL|3260|
|AS|714|
|F9|685|
|YV|601|
|HA|342|
|OO|32|

## Problem 6

> Show only the top 5 airlines, by number of flights, ordered by number of flights in descending order.

We can simply limit the number of rows returned by the previous problem's query:

```sql
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
GROUP BY carrier
ORDER BY total_flights DESC
LIMIT 5;
```

|carrier|total_flights|
|:--|:--|
|UA|58665|
|B6|54635|
|EV|54173|
|DL|48110|
|AA|32729|


## Problem 7

> Show only the top 5 airlines, by number of flights of distance 1,000 miles or greater, ordered by number of flights in descending order.

Filtering the previous problem's query to only consider flights of 1000 miles or more:

```sql
SELECT
  carrier,
  COUNT(*) AS 'total_flights'
FROM flights
WHERE distance >= 1000
GROUP BY carrier
LIMIT 5;
```

|carrier|total_flights|
|:--|:--|
|9E|2720|
|AA|23583|
|AS|714|
|B6|30022|
|DL|28096|

## Problem 8
> Create a question that (a) uses data from the flights database, and (b) requires aggregation to answer it, and write down both the question, and the query that answers the question.

### Question

What was the mean departure delay, in minutes, for each airline, ordered from best to worst?

```sql
SELECT
  carrier,
  AVG(dep_delay) AS 'mean_delay'
FROM flights
GROUP BY carrier
ORDER BY mean_delay;
```

|carrier|mean_delay|
|:--|:--|
|US|3.7824|
|HA|4.9006|
|AS|5.8048|
|AA|8.5860|
|DL|9.2645|
|MQ|10.5520|
|UA|12.1061|
|OO|12.5862|
|VX|12.8694|
|B6|13.0225|
|9E|16.7258|
|WN|17.7117|
|FL|18.7261|
|YV|18.9963|
|EV|19.9554|
|F9|20.2155|


