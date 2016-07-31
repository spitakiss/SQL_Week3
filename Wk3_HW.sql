

DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS rooms;
DROP TABLE rooms_groups;


CREATE TABLE people (
user_id INTEGER PRIMARY KEY,
user_name VARCHAR(15) NOT NULL,
group_id VARCHAR(15) NULL REFERENCES groups(group_id)
);

INSERT INTO people VALUES(1, 'Modesto',1);
INSERT INTO people VALUES(2, 'Ayine',1);
INSERT INTO people VALUES(3, 'Christopher',2);
INSERT INTO people VALUES(4, 'Cheong woo',2);
INSERT INTO people VALUES(5, 'Saulat',3);
INSERT INTO people VALUES(6, 'Heidi', Null);
    

CREATE TABLE groups (
group_id INTEGER PRIMARY KEY,
group_name VARCHAR(15) NOT NULL
);

INSERT INTO groups VALUES (1, 'I.T.');
INSERT INTO groups VALUES (2, 'Sales');
INSERT INTO groups VALUES (3, 'Administration');
INSERT INTO groups VALUES (4, 'Operations');

CREATE TABLE rooms (
room_id INTEGER PRIMARY KEY,
room_name VARCHAR(15) NOT NULL
);

INSERT INTO rooms VALUES (1, '101');
INSERT INTO rooms VALUES (2, '102');
INSERT INTO rooms VALUES (3, 'Auditorium A');
INSERT INTO rooms VALUES (4, 'Auditorium B');

CREATE TABLE rooms_groups(
group_id INTEGER REFERENCES groups(group_id),
room_id INTEGER REFERENCES rooms(room_id),
CONSTRAINT uk_rooms_groups UNIQUE KEY(group_id, room_id)
);

INSERT INTO rooms_groups VALUES(1,1);
INSERT INTO rooms_groups VALUES(1,2);
INSERT INTO rooms_groups VALUES(2,2);
INSERT INTO rooms_groups VALUES(2,3);
INSERT INTO rooms_Groups VALUES(3,Null);

# Q1 select all groups, with  associated users
SELECT groups.group_name, people.user_name FROM groups
LEFT JOIN people
ON groups.group_id = people.group_id;

# Q2 select all rooms with associated groups
SELECT rooms.room_name, groups.group_name FROM rooms
LEFT JOIN rooms_groups
ON rooms.room_id = rooms_groups.room_id
LEFT JOIN groups
ON rooms_groups.group_id = groups.group_id;


# Q3 select all users.  Pull associated groups and rooms for selected users
SELECT people.user_name, groups.group_name, rooms.room_name
FROM people

LEFT JOIN groups
ON people.group_id = groups.group_id
LEFT JOIN rooms_groups
ON groups.group_id = rooms_groups.group_id
LEFT JOIN rooms
ON rooms_groups.room_id = rooms.room_id

ORDER BY people.user_name, groups.group_name, rooms.room_name 
;

# Alternative pull:  pull all users, all groups, all rooms  
# Simulatiing outer join using multiple UNION statements

SELECT user_name, group_name, room_name FROM (

SELECT people.user_name, groups.group_name, rooms.room_name
FROM people
LEFT JOIN groups
ON people.group_id = groups.group_id

LEFT JOIN rooms_groups
ON groups.group_id = rooms_groups.group_id
LEFT JOIN rooms
ON rooms_groups.room_id = rooms.room_id 
 

UNION

SELECT people.user_name, groups.group_name, rooms.room_name
FROM people
RIGHT JOIN groups
ON people.group_id = groups.group_id

RIGHT JOIN rooms_groups
ON groups.group_id = rooms_groups.group_id
RIGHT JOIN rooms
ON rooms_groups.room_id = rooms.room_id
 


UNION

SELECT people.user_name, groups.group_name, rooms.room_name
FROM groups
LEFT JOIN people 

ON groups.group_id = people.group_id

LEFT JOIN rooms_groups
ON people.group_id = rooms_groups.group_id

LEFT JOIN rooms 
ON rooms_groups.room_id = rooms.room_id 
) a
ORDER BY user_name, group_name, room_name
 
;