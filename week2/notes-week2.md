# Notes - Week 2

A summary of the chapters 11, 12, 15, 16 and 17 in Rockoff's *The Language of SQL*, [Software Carpentry's tutorial, *Creating and modifying data*](https://swcarpentry.github.io/sql-novice-survey/09-create/) and some pertinent sections of [the official MySQL Server 5.7 documentation](https://dev.mysql.com/doc/refman/5.7/en/).



## 11. Combining tables with an inner join

Let's say that we have the following two tables in our database:

*Customers*

|CustomerID|FirstName|LastName|
|:--:|:--|:--|
|1|William|Smith|
|2|Natalie|Lopez|
|3|Brenda|Harper|
|4|Adam|Petrie|

*Orders*

|OrderID|CustomerID|Quantity|PricePerItem|
|:--:|:--:|:--|:--|
|1|1|4|2.50|
|2|2|10|1.25|
|3|2|12|1.50|
|4|3|5|4.00|

Notice that these two tables are related by the column *CustomerID*. *CustomerID* is the **primary key** of the *Customers* table, because it acts as a unique identifier for each row of that table, and as a **foreign key** of the *Orders* table, because it relates this table to another table.

### The inner join

An *inner join* creates a single table from two related tables. An inner join only produces data for which there is a match in both tables. For example:

The query:

```sql
SELECT *
FROM
  Customers INNER JOIN Orders 
    ON Customers.CustomerID = Orders.CustomerID; 
```

Yields:

|CustomerID|FirstName|LastName|OrderID|CustomerID|Quantity|PricePerItem|
|:--:|:--|:--|:--:|:--:|:--|:--|
|1|William|Smith|1|1|4|2.50|
|2|Natalie|Lopez|2|2|10|1.25|
|2|Natalie|Lopez|3|2|12|1.50|
|3|Brenda|Harper|4|3|5|4.00|

Notice that there are two records for *Natalie Lopez* and no records for *Adam Petrie*.

An **alternative way to specify an inner join**, without using `INNER JOIN` or `ON` is:

```sql
SELECT *
FROM Customers, Orders
WHERE Customers.CustomerID = Orders.CustomerID;
```

This would produce the same result as the previous query. The previous query is possibly clearer to the reader.

To avoid duplicate columns from a join, we can explicitly select the output columns using aliases. For example:

```sql
SELECT
  C.CustomerID AS 'CustomerID',
  C.FirstName AS 'FirstName',
  C.LastName AS 'LastName',
  O.orderID AS 'OrderID',
  O.Quantity as 'Quantity',
  O.PricePerItem AS 'PricePerItem'
FROM Customers AS C
  INNER JOIN Orders AS O
    ON C.CustomerID = O.CustomerID;
```

Returns:

|CustomerID|FirstName|LastName|OrderID|Quantity|PricePerItem|
|:--:|:--|:--|:--:|:--|:--|
|1|William|Smith|1|4|2.50|
|2|Natalie|Lopez|2|10|1.25|
|2|Natalie|Lopez|3|12|1.50|
|3|Brenda|Harper|4|5|4.00|

Note that it isn't necessary to specify `INNER JOIN` for inner joins; `JOIN` will by default execute an inner join.

## 12. Combining tables with an outer join

Let's say that we have the following tables in our database:

*Customers*

|CustomerID|FirstName|LastName|
|:--:|:--|:--|
|1|William|Smith|
|2|Natalie|Lopez|
|3|Brenda|Harper|
|4|Adam|Petrie|

*Orders*

|OrderID|CustomerID|OrderDate|OrderAmount|
|:--:|:--:|:--|:--|
|1|1|2009-09-01|10.00|
|2|2|2009-09-01|12.50|
|3|2|2009-10-03|18.00|
|4|3|2009-09-15|20.00|

*Refunds*

|RefundID|OrderID|RefundDate|RefundAmount|
|:--:|:--:|:--|:--|
|1|1|2009-09-02|5.00|
|2|3|2009-10-12|18.00|

### Left joins

The query:

```sql
SELECT
  Customers.FirstName AS 'FirstName',
  Customers.LastName AS 'LastName',
  Orders.OrderDate AS 'OrderDate',
  Orders.OrderAmount AS 'OrderAmount',
  Refunds.RefundDate AS 'RefundDate',
  Refunds.RefundAmount AS 'RefundAmount'
FROM Customers 
  LEFT JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
  LEFT JOIN Refunds
    ON Orders.OrderID = Refunds.OrderID
ORDER BY Customers.CustomerID, Orders.OrderID, RefundID;
```

Returns:

|FirstName|LastName|OrderDate|OrderAmount|RefundDate|RefundAmount|
|:--|:--|:--|:--|:--|:--|
|William|Smith|2009-09-01|10.00|2009-09-02|5.00|
|Natalie|Lopez|2009-09-01|12.50|NULL|NULL|
|Natalie|Lopez|2009-10-03|18.00|2009-10-12|18.00|
|Brenda|Harper|2009-09-15|20.00|NULL|NULL|
|Adam|Petrie|NULL|NULL|NULL|NULL|

The table to the left of a *left join* operation is called the **primary table**; the table to the right is called the **secondary table**. Notice that all the rows in the primary table will be included regardless of whether it is related to any rows in the secondary table.

### Right joins

*Right joins* behave similarly to left joins, but the primary table is the table on the right of the operation.

### Full joins

A *full join* is a left join and a right join together; that is, all rows in each table will appear in the output even if there is not a related row in the other table.

Note that MySQL does not provide a full join!


## 15. Set logic

### Using the `UNION` operator

Let's say that we have the following tables in our data set:

*Orders*

|OrderID|CustomerID|OrderDate|OrderAmount|
|:--:|:--:|:--|:--|
|1|1|2009-10-13|10|
|2|2|2009-10-13|8|
|3|2|2009-12-05|7|
|4|2|2009-12-15|21|
|5|3|2009-12-28|11|

*Returns*

|ReturnID|CustomerID|ReturnDate|ReturnAmount|
|:--:|:--:|:--|:--|
|1|1|2009-10-23|2|
|2|1|2009-12-07|7|
|3|1|2009-12-28|3|

Notice that these two tables are not directly related to each other (though they both appear to be related to some third *Customers* table.

Let's say that we want to generate a table that shows the all the orders and returns for the customer with *CustomerID* 2. This can be achieved, for example, by the following query:

```sql
SELECT
  OrderDate AS 'Date',
  'Order' AS 'Type',
  OrderAmount AS 'Amount'
FROM Orders
WHERE CustomerID = 2

  UNION
  
SELECT
  ReturnDate AS 'Date',
  'Return' AS 'Type',
  ReturnAmount AS 'Amount'
FROM Returns
WHERE CustomerID = 2

ORDER BY Date;
```

Which returns:

|Date|Type|Amount|
|:--|:--|:--|
|2009-10-13|Order|8|
|2009-12-05|Order|7|
|2009-12-07|Return|7|
|2009-12-15|Order|21|

Notice that `UNION` simply appends the rows of the second table to the rows of the first. Of course, the second table's columns must match the first table's columns in number and type.

Note that `UNION` only produces distinct rows (as if adding elements to a set). To add all indistinct rows, use `UNION ALL`.

### Using the `INTERSECT` operator

The `INTERSECT` operator is used like `UNION` but only returns the rows that the two tables have in common.

## 16. Stored procedures and parameters

*Stored procedures* are sets of SQL queries. They can be used to simplify complicated queries or to repeat queries.

The general format of a stored procedure (in MySQL) is:

```sql
DELIMITER $$
  CREATE PROCEDURE ProcedureName(Arguments & ArgumentTypes)
  BEGIN
    SQLStatements
  END $$
DELIMITER ;
```

To execute a procedure (in MySQL) we use the `CALL` keyword.

For example, let's say that we have the following table in our database:

*Orders*

|OrderID|CustomerID|OrderDate|OrderAmount|
|:--:|:--:|:--|:--|
|1|1|2009-10-13|10|
|2|2|2009-10-13|8|
|3|2|2009-12-05|7|
|4|2|2009-12-15|21|
|5|3|2009-12-28|11|


And that we have defined the following procedure:

```sql
DELIMITER $$
  CREATE PROCEDURE OrdersForCustomer(CustID INT)
  BEGIN
    SELECT *
    FROM Orders
    WHERE CustomerID = CustID;
  END$$
DELIMITER ;
```

Then the query:

```sql
CALL OrdersForCustomer(2);
```

Yields:

|OrderID|CustomerID|OrderDate|OrderAmount|
|:--:|:--:|:--|:--|
|2|2|2009-10-13|8|
|3|2|2009-12-05|7|
|4|2|2009-12-15|21|

To delete a procedure, use:

```sql
DROP PROCEDURE ProcedureName;
```

## (Various) creating tables

We create a new table using:

```sql
CREATE TABLE tableName(
  column1name column1type, 
  column2name column2type,
  etc.
);
```

Some MySQL types:

|Type|Description|
|:--|:--|
|**Numbers**||
|`BIT([m = 1])`|An integer consisting of m bits.|
|`TINYINT [UNSIGNED] [ZEROFILL]`|8-bit integer.|
|`SMALLINT [UNSIGNED][ZEROFILL]`|16-bit integer.|
|`MEDIUMINT [UNSIGNED][ZEROFILL]`|24-bit integer.|
|`INT/INTEGER [UNSIGNED][ZEROFILL]`|32-bit integer.|
|`BIGINT [UNSIGNED][ZEROFILL]`|64-bit integer.|
|`SERIAL`|Alias for `BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE`|
|`BOOL/BOOLEAN`|Boolean; zero interpreted as false, non zero as true.|
|`DECIMAL([M=?, D=?) [UNSIGNED][ZEROFILL]`|An m-digit precision real number with D decimal places.|
|`FLOAT [UNSIGNED][ZEROFILL]`|A small floating-point number.|
|`DOUBLE [UNSIGNED][ZEROFILL]`|A larger floating-point number.|
|**Dates and times**||
|`DATE`|A date-representation in the form `YYYY-MM-DD`.|
|`TIME([fsp])`|A time representation in the form `HH-MM-SS`.|
|`DATETIME([fsp])`|A date-and-time-representation.|
|**Strings**||
|`CHAR`|...|
|`VARCHAR`|...|
|`TEXT`|A character string.|
|**Other**||
|BLOB|A *binary large object*, such as an image.|


Example:

```sql
CREATE TABLE publishers (
  publisher_id INT PRIMARY KEY,
  publisher VARCHAR(30) NOT NULL,
  date_established DATE
);
```


## 17. Modifying data

### Inserting rows

We use the `INSERT INTO` keyword to insert rows to a table.

Let's say that we have the following table in our database:

*Customers*

|CustomerID|FirstName|LastName|State|
|:--:|:--|:--|:--|
|1|William|Smith|IL|
|2|Natalie|Lopez|WI|
|3|Brenda|Harper|NV|

With *CustomerID* an auto-incremented primary key.

Then we can insert a new row with the following query:

```sql
INSERT INTO Customers
  (FirstName, LastName, State)  -- Specifies order of new values.
VALUES
  ('Virginia', 'Jones', 'OH'),
  ('Clark', 'Woodland', 'CA'); 
```

Now *Customers* is:

|CustomerID|FirstName|LastName|State|
|:--:|:--|:--|:--|
|1|William|Smith|IL|
|2|Natalie|Lopez|WI|
|3|Brenda|Harper|NV|
|4|Virginia|Jones|OH|
|5|Clark|Woodland|CA|

Any columns not specified in the insert are assigned a `NULL`.

We can also use `INSERT INTO` to add rows generated from another query. For example, let's say that we have the following table in our database:

*Transactions*

|CustomerID|State|Name1|Name2|
|:--:|:--|:--|:--|
|1|RI|Susan|Harris|
|2|DC|Michael|Blake|
|3|RI|Alan|Canter|

And that we want to add all the Rhode Island *Transactions* data to the *Customers* table. We can do this with the query:

```sql
INSERT INTO Customers
  (FirstName, LastName, State)
SELECT
  Name1, 
  Name2, 
  State
FROM Transactions
WHERE State = 'RI';
```

*Customers* is now:

|CustomerID|FirstName|LastName|State|
|:--:|:--|:--|:--|
|1|William|Smith|IL|
|2|Natalie|Lopez|WI|
|3|Brenda|Harper|NV|
|4|Virginia|Jones|OH|
|5|Clark|Woodland|CA|
|6|Susan|Harris|RI|
|7|Alan|Canter|RI|

### Removing rows

We can remove rows from a table using the `DELETE FROM` and `WHERE` keywords.

For example, let's say we want to remove all the Rhode Island customers from the *Customers* table. We could do this using:

```sql
DELETE FROM Customers
WHERE State = 'RI';
```

*Customers* is now:

|CustomerID|FirstName|LastName|State|
|:--:|:--|:--|:--|
|1|William|Smith|IL|
|2|Natalie|Lopez|WI|
|3|Brenda|Harper|NV|
|4|Virginia|Jones|OH|
|5|Clark|Woodland|CA|

We can also use:

```sql
TRUNCATE TABLE TableName;
```

To remove all the rows from a table. Unlike `DELETE FROM` queries, `TRUNCATE TABLE` resets the auto-increment column values.

### Updating rows

We use the `UPDATE` and `SET` keywords to update stored data silimarly to the way we use `SELECT`. The basic update query is:

```sql
UPDATE TableName
SET
  Column1 = Expression1,
  Column2 = Expression2,
  (etc.)
WHERE Condition;
```

For example, after the query:

```sql
UPDATE Customers
SET
  FirstName = 'Bill',
  LastName = 'Smythe'
WHERE CustomerID = 1;
```

*Customers* becomes:

|CustomerID|FirstName|LastName|State|
|:--:|:--|:--|:--|
|1|Bill|Smythe|IL|
|2|Natalie|Lopez|WI|
|3|Brenda|Harper|NV|
|4|Virginia|Jones|OH|
|5|Clark|Woodland|CA|

