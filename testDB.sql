--test project
-- DROP TABLES (if they exist)
DROP TABLE Grade CASCADE CONSTRAINTS;
DROP TABLE Course CASCADE CONSTRAINTS;
DROP TABLE Student CASCADE CONSTRAINTS;

-- CREATE TABLES
CREATE TABLE Student (
    ID NUMBER PRIMARY KEY,
    First VARCHAR2(50),
    Last VARCHAR2(50),
    Enrolment_Date DATE
);

CREATE TABLE Course (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Start_Date DATE,
    End_Date DATE,
    Enrolment_Date DATE
);

CREATE TABLE Grade (
    ID NUMBER PRIMARY KEY,
    Course_ID NUMBER,
    Student_ID NUMBER,
    Grade NUMBER(3,1),
    Semester VARCHAR2(10),
    FOREIGN KEY (Course_ID) REFERENCES Course(ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(ID)
);

--Insert
INSERT INTO Student VALUES (1, 'Alice', 'Smith', TO_DATE('2023-09-01', 'YYYY-MM-DD'));
INSERT INTO Student VALUES (2, 'Bob', 'Johnson', TO_DATE('2023-09-01', 'YYYY-MM-DD'));
INSERT INTO Student VALUES (3, 'Charlie', 'Davis', TO_DATE('2023-09-01', 'YYYY-MM-DD'));

INSERT INTO Course VALUES (1, 'Mathematics', TO_DATE('2023-09-10', 'YYYY-MM-DD'), TO_DATE('2023-12-15', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'));
INSERT INTO Course VALUES (2, 'History', TO_DATE('2023-09-12', 'YYYY-MM-DD'), TO_DATE('2023-12-18', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'));
INSERT INTO Course VALUES (3, 'Physics', TO_DATE('2023-09-15', 'YYYY-MM-DD'), TO_DATE('2023-12-20', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'));

-- Alice
INSERT INTO Grade VALUES (1, 1, 1, 92.0, 'Fall2023');
INSERT INTO Grade VALUES (2, 2, 1, 85.5, 'Fall2023');

-- Bob
INSERT INTO Grade VALUES (3, 1, 2, 78.0, 'Fall2023');
INSERT INTO Grade VALUES (4, 3, 2, 88.0, 'Fall2023');

-- Charlie
INSERT INTO Grade VALUES (5, 2, 3, 91.0, 'Fall2023');
INSERT INTO Grade VALUES (6, 3, 3, 89.5, 'Fall2023');


--grade report for each student
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    c.Name AS Course_Name,
    g.Grade AS Course_Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
    JOIN Course c ON g.Course_ID = c.ID
ORDER BY
    s.ID, c.Name;

--best grade
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    c.Name AS Course_Name,
    g.Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
    JOIN Course c ON g.Course_ID = c.ID
WHERE
    g.Grade = (SELECT MAX(Grade) FROM Grade);

--best student
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    ROUND(AVG(g.Grade), 2) AS Average_Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
GROUP BY
    s.ID, s.First, s.Last
ORDER BY
    Average_Grade DESC
FETCH FIRST 1 ROWS ONLY;

--Sorted by Best Average Grades
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    ROUND(AVG(g.Grade), 2) AS Average_Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
GROUP BY
    s.ID, s.First, s.Last
ORDER BY
    Average_Grade DESC;


--Get the Lowest Grade per Student
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    c.Name AS Course_Name,
    g.Grade AS Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
    JOIN Course c ON g.Course_ID = c.ID
WHERE
    g.Grade = (
        SELECT MIN(Grade)
        FROM Grade
        WHERE Student_ID = s.ID
    )
ORDER BY
    s.ID, c.Name;

--Get the Highest Grade per Student
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    c.Name AS Course_Name,
    g.Grade AS Grade
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
    JOIN Course c ON g.Course_ID = c.ID
WHERE
    g.Grade = (
        SELECT MAX(Grade)
        FROM Grade
        WHERE Student_ID = s.ID
    )
ORDER BY
    s.ID, c.Name;

--Case
SELECT
    s.ID AS Student_ID,
    s.First || ' ' || s.Last AS Student_Name,
    ROUND(AVG(g.Grade), 2) AS Average_Grade,
    CASE
        WHEN AVG(g.Grade) >= 90 THEN 'Excellent'
        WHEN AVG(g.Grade) >= 75 THEN 'Good'
        WHEN AVG(g.Grade) >= 60 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS Performance
FROM
    Grade g
    JOIN Student s ON g.Student_ID = s.ID
GROUP BY
    s.ID, s.First, s.Last;

SELECT * FROM grade;
--update
UPDATE Grade
SET Grade = 95
WHERE Student_ID = 2 AND Course_ID = 1;

SELECT * FROM grade;

DELETE FROM Grade
WHERE Student_ID = 1 AND Course_ID = 1;

SELECT * FROM grade;
SELECT * FROM student;
SELECT * FROM test;
COMMIT;
