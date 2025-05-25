-- 1. Department ID, name, and faculty name managing it
SELECT D.DepartmentID, D.DepartmentName, F.Name AS FacultyName
FROM Department D
JOIN Faculty F ON D.DepartmentName = F.Department;


-- 2. Program (Course) name and its department
SELECT C.CourseName, D.DepartmentName
FROM Course C
JOIN Department D ON C.DepartmentID = D.DepartmentID;

-- 3. Full student data and their faculty advisor name
SELECT S.*, F.Name AS FacultyAdvisor
FROM Student S
JOIN Faculty F ON S.FacultyID = F.FacultyID;

-- 4. Class IDs, course titles, and room locations for building A or B
SELECT E.ExamCode, C.CourseName, E.Room
FROM Exam E
JOIN Department D ON E.DepartmentID = D.DepartmentID
JOIN Course C ON D.CourseName = C.CourseName
WHERE E.Room LIKE 'A%' OR E.Room LIKE 'B%';

-- 5. Full course data with titles starting with 'I'
SELECT *
FROM Course
WHERE CourseName LIKE 'D%';





-- 8. Students advised by "Dr. Ahmed Hassan"
SELECT S.FirstName, S.LastName
FROM Student S
JOIN Faculty F ON S.FacultyID = F.FacultyID
WHERE F.Name = 'Dr. Ahmed Al-Busaidi';

-- 9. Student names and enrolled courses, ordered by course title
SELECT S.FirstName + ' ' + S.LastName AS StudentName, C.CourseName
FROM Student S
JOIN Enrols E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
ORDER BY C.CourseName;

-- 10. Classes in 'Main' building with class ID, course name, department, faculty
SELECT E.ExamCode, C.CourseName, D.DepartmentName
FROM Exam E
JOIN Department D ON E.DepartmentID = D.DepartmentID
JOIN Course C ON C.DepartmentID = D.DepartmentID
WHERE E.Room LIKE 'A%' OR E.Room LIKE 'B%';


-- 11. Faculty who manage any department --0 VALIES
SELECT DISTINCT F.*
FROM Faculty F
JOIN Department D ON F.Department = D.CourseName;

-- 12. All students and their advisor names 
SELECT DISTINCT F.*
FROM Faculty F
JOIN Department D ON LOWER(F.Department) = LOWER(D.DepartmentName);--MAKES THE VALUE IN LOWE CASE 

