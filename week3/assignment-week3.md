# Assignment 3

> An organization grants key-card access to rooms based on groups that key-card holders belong to. You may assume that users below to only one group. Your job is to design the database that supports the key-card system.
>
> There are six *users*, and four *groups*. *Modesto* and *Ayine* are in group *“I.T.”*, *Christopher* and *Cheong woo* are in group
*“Sales”*. There are four rooms: *“101”*, *“102”*, *“Auditorium A”*, and *“Auditorium B”*. *Saulat* is in group *“Administration.”* Group *“Operations”* currently doesn’t have any users assigned. *I.T.* should be able to access Rooms *101* and *102*. *Sales* should be able to access rooms *102* and *Auditorium A*. *Administration* does not have access to any rooms. *Heidy* is a new employee, who has not yet been assigned to any group.
>
> After you determine the tables any relationships between the tables (One to many? Many to one? Many to many?), you should create the tables and populate them with the information indicated above.
>
> Next, write SELECT statements that provide the following information:
>
> * All groups, and the users in each group. A group should appear even if there are no users assigned to the group.
> * All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been assigned to them.
> * A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted alphabetically by user, then by group, then by room.

## Definitions

For this assignment I decided to define the main data in three tables, namely *Users*, *Groups* and *Rooms*. I created and populated them as follows:

### *Users*

```sql
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
  UserID INT PRIMARY KEY,
  UserName TEXT
);

INSERT INTO Users (UserID, UserName)
VALUES
  (1, 'Modesto'),
  (2, 'Ayine'),
  (3, 'Christopher'),
  (4, 'Cheong woo'),
  (5, 'Saulat'),
  (6, 'Heidy');
```

|UserID|UserName|
|:--:|:--|
|1|Modesto|
|2|Ayine|
|3|Christopher|
|4|Cheong woo|
|5|Saulat|
|6|Heidy|

### *Groups*

```sql
DROP TABLE IF EXISTS Groups;
  
  CREATE TABLE Groups (
    GroupID INT PRIMARY KEY,
    GroupName TEXT
);

INSERT INTO Groups (GroupID, GroupName)
VALUES
  (1, 'I.T.'),
  (2, 'Sales'),
  (3, 'Administration'),
  (4, 'Operations');
```

|GroupID|GroupName|
|:--:|:--|
|1|I.T.|
|2|Sales|
|3|Administration|
|4|Operations|

### *Rooms*

```sql
DROP TABLE IF EXISTS Rooms;
  
CREATE TABLE Rooms (
  RoomID INT PRIMARY KEY,
  RoomName TEXT
);

INSERT INTO Rooms (RoomID, RoomName)
VALUES
  (1, '101'),
  (2, '102'),
  (3, 'Auditorium A'),
  (4, 'Auditorium B');
```

|RoomID|RoomName|
|:--:|:--|
|1|101|
|2|102|
|3|Auditorium A|
|4|Auditorium B|

## Relationships

I then established the relationships between the data via two tables that I called *GroupAssignments* and *AccessPermission*.

### *GroupAssignment*

```sql
DROP TABLE IF EXISTS GroupAssignment;

CREATE TABLE GroupAssignment (
  UserID INT,
  GroupID INT
);

INSERT INTO GroupAssignment (UserID, GroupID)
VALUES
  (1, 1), -- Modesto assigned to group I.T.
  (2, 1), -- Ayine, I.T.
  (3, 2), -- Christopher, Sales
  (4, 2), -- Cheong woo, Sales
  (5, 3); -- Saulat, Administration
```

|UserID|GroupID|
|:--:|:--:|
|1|1|
|2|1|
|3|2|
|4|2|
|5|3|

(Notice that this *GroupAssignment* represents a *many-to-one* relationship between *Users* and *Groups*. For example, notice that both *Modesto* and *Ayine* are mapped by this relation to *I.T.*.)

### *AccessPermission*

```sql
DROP TABLE IF EXISTS AccessPermission;
  
  CREATE TABLE AccessPermission (
    GroupID INT,
    RoomID INT
);

INSERT INTO AccessPermission (GroupID, RoomID)
VALUES
  (1, 1), -- I.T. has access permission for 101
  (1, 2), -- I.T, 102
  (2, 2), -- Sales, 102
  (2, 3); -- Sales, Auditorium A
```

|GroupID|RoomID|
|:--:|:--:|
|1|1|
|1|2|
|2|2|
|2|3|

(Notice that *AccessPermission* represents a *many-to-many* relationship between *Groups* and *Rooms*. For example, notice that *I.T.* is mapped to *101* and *102*, and that both *I.T.* and *Sales* are mapped to *102*.)

## Assignment queries

Now that the data is set up, we can extract the requested information.

### Query 1

> All groups, and the users in each group. A group should appear even if there are no users assigned to the group.

```sql
SELECT 
    Groups.GroupName, 
    IFNULL(Users.UserName, '(Nobody)') AS 'UserName'
FROM
    Groups
        LEFT JOIN
    GroupAssignment ON Groups.GroupID = GroupAssignment.GroupID
        LEFT JOIN
    Users ON GroupAssignment.UserID = Users.UserID;
```
|GroupName|UserName|
|:--|:--|
|I.T.|Modesto|
|I.T.|Ayine|
|Sales|Christopher|
|Sales|Cheong woo|
|Administration|Saulat|
|Operations|(Nobody)|

### Query 2

> All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been
assigned to them.

```sql
SELECT 
    Rooms.RoomName, 
    IFNULL(Groups.GroupName, '(None)') AS 'GroupName'
FROM
    Rooms
        LEFT JOIN
    AccessPermission ON Rooms.RoomID = AccessPermission.RoomID
        LEFT JOIN
    Groups ON AccessPermission.GroupID = Groups.GroupID;
```

|RoomName|GroupName|
|:--|:--|
|101|I.T.|
|102|I.T.|
|102|Sales|
|Auditorium A|Sales|
|Auditorium B|(None)|

### Query 3

> A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted alphabetically by user, then by group, then by room.

```sql
SELECT 
    Users.UserName, 
    IFNULL(Groups.GroupName, '(None)') AS 'GroupName', 
    IFNULL(Rooms.RoomName, '(None)') AS 'RoomName'
FROM
    Users
        LEFT JOIN
    GroupAssignment ON Users.UserID = GroupAssignment.UserID
        LEFT JOIN
    Groups ON GroupAssignment.GroupID = Groups.GroupID
        LEFT JOIN
    AccessPermission ON Groups.GroupID = AccessPermission.GroupID
        LEFT JOIN
    Rooms ON AccessPermission.RoomID = Rooms.RoomID
ORDER BY Users.UserName , Groups.GroupName , Rooms.RoomName;
```

|UserName|GroupName|RoomName|
|:--|:--|:--|
|Ayine|I.T.|101|
|Ayine|I.T.|102|
|Cheong woo|Sales|102|
|Cheong woo|Sales|Auditorium A|
|Christopher|Sales|102|
|Christopher|Sales|Auditorium A|
|Heidy|(None)|(None)|
|Modesto|I.T.|101|
|Modesto|I.T.|102|
|Saulat|Administration|(None)|


