# Notes - Week 3

A summary of the chapters 13 and 14 in Rockoff's *The Language of SQL*.



## 13. Self joins and views

### Self joins

WE can perform self joins on tables that reference themselves.

Let's say that we have the following table in our database:

*Personnel*

|EmployeeID|EmployeeName|ManagerID|
|:--:|:--|:--:|
|1|Susan Ford|NULL|
|2|Harold Jenkins|1|
|3|Jacqueline Baker|1|
|4|Richard Fielding|1|
|5|Carol Bland|2|
|6|Janet Midling|2|
|7|Andrew Brown|3|
|8|Anne Nichol|4|
|9|Bradley Cash|4|
|10|David Sweet|5|

Notice that this table is self referencing because the foreign key *ManagerID* relates this table to itself via the primary key *EmployeeID*.

We can see who the manager of each employee is with the following query:

```sql
SELECT
  Employees.EmployeeName AS 'EmployeeName',
  Managers.EmployeeName AS 'ManagerName'
FROM
  Personnel AS Employees INNER JOIN 
    Personnel AS Managers
      ON Employees.ManagerID = Managers.EmployeeID
ORDER BY Employees.EmployeeID;
```

Which outputs:

|EmplyeeName|ManagerName|
|:--|:--|
|Harold Jenkins|Susan Ford|
|Jacqueline Baker|Susan Ford|
|Richard Fielding|Susan Ford|
|Carol Bland|Harold Jenkins|
|Janet Midling|Harold Jenkins|
|Andrew Brown|Jacqueline Baker|
|Anne Nichol|Richard Fielding|
|Bradley Cash|Richard Fielding|
|David Sweet|Carol Bland|

### Creating views

A view is a is a `SELECT` query that has been saved to the database and can be used in the same way as a table.

The basic syntax for creating a view is:

```sql
CREATE ViewName AS
SelectQuery;
```

Views can: 

* Reduce complexity and increase reusability of SQL code.
* Format data or calculate new data so that it is easier to make the queries we are interested in. 
* Rename columns.
* Restrict access to only certain columns of an underlying table to users.

## 14. Subqueries

A subquery is a `SELECT` query within a `SELECT` query. 

### Using a subquery as a data source

We can use a subquery as a data source making it part of the `FROM` clause. For example, let's say that we have the following tables in our database:

*Customers*

|CustomerID|CustomerName|
|:--:|:--|
|1|William Smith|
|2|Natalie Lopez|
|3|Brenda Harper|
|4|Adam Petrie|

*Orders*

|OrderID|CustomerID|OrderAmount|OrderType|
|:--:|:--:|:--|:--|
|1|1|22.25|Cash|
|2|2|11.75|Credit|
|3|2|5.00|Credit|
|4|2|8.00|Cash|
|5|3|9.33|Credit|
|6|3|10.11|Credit|

We could use a subquery as a data source to get a list of customers along with the sum of each customers cash orders as follows:

```sql
SELECT
  Customers.CustomerName AS 'Customer',
  IFNULL(Temp.Sum, 0) AS 'Sum'
FROM Customers LEFT JOIN (
  SELECT 
    CustomerID, 
    SUM(OrderAmount) AS 'Sum'
  FROM Orders
  WHERE OrderType = 'Cash'
  GROUP BY CustomerID
) AS Temp
ON Customers.CustomerID = Temp.CustomerID
ORDER BY Customers.CustomerID;
```

Which produces:

|Customer|Sum|
|:--|:--|
|William Smith|22.25|
|Natalie Lopez|8.00|
|Brenda Harper|0|
|Adam Petrie|0|

### Using a subquery in selection criteria

A subquery can act as an argument to the `IN` operation to create selection criteria. For example, we could generate a list of customers who have paid cash at some point as follows:

```sql
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
  SELECT CustomerID
  FROM Orders
  WHERE OrderType = 'Cash'
);
```

|CustomerName|
|:--|
|William Smith|
|Natalie Lopez|

A subquery that returns a single value can be used directly in a conditional statement. For example, let's say we would like a list of customers who placed at least one order but whose total orders amounted to less that twenty dollars. We could do this as follows:

```sql
SELECT CustomerName
FROM Customers
WHERE (
  SELECT SUM(OrderAmount)
  FROM Orders
  WHERE Customers.CustomerID = Orders.CustomerID
) < 20;
```

|CustomerName|
|:--|
|Brenda Harper|

Notice that in this example the subquery needed to be executed for each row of *Customers* because it depends on *Customers.CustomerID*, which changes for each row. This type of subquery is said to be a **correlated** subquery. An **uncorrelated** subquery only needs to be evaluated once (and is only evaluated once) during the execution of the outer query.

The `EXISTS` operator can be used to check whether a subqury contains at least one row. For example, the following query can be used to get a list of customers who have placed at least one order:

```sql
SELECT CustomerName
FROM Customers
WHERE EXISTS (
  SELECT *
  FROM Orders
  WHERE Customers.CustomerID = Orders.CustomerID
);
``` 

Which Returns:

|CustomerName|
|:--|
|William Smith|
|Natalie Lopez|
|Brenda Harper|

### Using a subquery as a calculated column

We can also use a subquery to define a column in our output. For example, if we want to know how many orders each of the customers made, we could use the following query:

```sql
SELECT
  CustomerName,
  (
    SELECT COUNT(*)
    FROM Orders
    WHERE Customers.CustomerID = Orders.CustomerID
  ) AS NumberOfOrders
FROM Customers
ORDER BY Customers.CustomerID;
```

Which returns:

|CustomerName|NumberOfOrders|
|:--|:--|
|William Smith|1|
|Natalie Lopez|3|
|Brenda Harper|2|
|Adam Petrie|0|

