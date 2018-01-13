USE week3_assignment;

-- Users

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
  
  -- Groups
  
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
  
-- Rooms

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
  
-- Room access permission

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


-- Group assignment

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


-- Assignment
-- All groups, and the users in each group. A group should appear even if 
-- there are no users assigned to the group.

SELECT 
    Groups.GroupName, 
    Users.UserName
FROM
    Groups
        LEFT JOIN
    GroupAssignment ON Groups.GroupID = GroupAssignment.GroupID
        LEFT JOIN
    Users ON GroupAssignment.UserID = Users.UserID;
    
-- All rooms, and the groups assigned to each room. The rooms should appear 
-- even if no groups have been assigned to them.

SELECT 
    Rooms.RoomName, 
    Groups.GroupName
FROM
    Rooms
        LEFT JOIN
    AccessPermission ON Rooms.RoomID = AccessPermission.RoomID
        LEFT JOIN
    Groups ON AccessPermission.GroupID = Groups.GroupID;
    
-- A list of users, the groups that they belong to, and the rooms to which they are 
-- assigned. This should be sorted alphabetically by user, then by group, then by room.

SELECT 
    Users.UserName, Groups.GroupName, Rooms.RoomName
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