-- 1. Department info with manager name
SELECT D.Dnum, D.Dname, D.MGRSSN,
       E.Fname + ' ' + E.Lname AS ManagerName
FROM dbo.Departments D
JOIN dbo.Employee E ON D.MGRSSN = E.SSN;

-- 2. Departments and projects they control
SELECT D.Dname, P.Pname
FROM dbo.Departments D, dbo.Project P
WHERE D.Dnum = P.Dnum;

-- 3. Dependents and their employees
SELECT DEP.*, 
       E.Fname + ' ' + E.Lname AS EmployeeName
FROM dbo.Dependent DEP
JOIN dbo.Employee E ON DEP.ESSN = E.SSN;

-- 4. Projects in Cairo or Alex
SELECT P.Pnumber, P.Pname, P.Plocation
FROM dbo.Project P
WHERE P.City IN ('Cairo', 'Alex');

-- 5. Projects starting with 'A'
SELECT * 
FROM dbo.Project
WHERE Pname LIKE 'A%';

-- 6. Employees in department 30 with salary 1000–2000
SELECT SSN, Fname, Lname
FROM dbo.Employee
WHERE Dno = 30 AND Salary BETWEEN 1000 AND 2000;

-- 7. Department 10 employees working ≥10h on “AL Rabwah”
SELECT E.Fname, E.Lname
FROM dbo.Employee E, dbo.Works_for W, dbo.Project P
WHERE E.SSN = W.ESSN AND W.Pno = P.Pnumber
  AND E.Dno = 10 AND P.Pname = 'AL Rabwah' AND W.Hours >= 10;

-- 8. Employees supervised by "Kamel Mohamed"
SELECT E.Fname, E.Lname
FROM dbo.Employee E
JOIN dbo.Employee S ON E.Superssn = S.SSN
WHERE S.Fname = 'Kamel' AND S.Lname = 'Mohamed';

-- 9. Employees and projects they work on (sorted)
SELECT E.Fname + ' ' + E.Lname AS EmployeeName,
       P.Pname
FROM dbo.Employee E, dbo.Works_for W, dbo.Project P
WHERE E.SSN = W.ESSN AND W.Pno = P.Pnumber
ORDER BY P.Pname;

-- 10. Cairo projects with dept and manager info
SELECT P.Pnumber, D.Dname, M.Lname AS ManagerLname, M.Address, M.Bdate
FROM dbo.Project P
JOIN dbo.Departments D ON P.Dnum = D.Dnum
JOIN dbo.Employee M ON D.MGRSSN = M.SSN
WHERE P.City = 'Cairo';

-- 11. All data of company managers
SELECT E.*
FROM dbo.Employee E, dbo.Departments D
WHERE E.SSN = D.MGRSSN;

-- 12. All employees and their dependents (even if none)
SELECT E.SSN, E.Fname, E.Lname, D.Dependent_name, D.Dependent_name
FROM dbo.Employee E
LEFT JOIN dbo.Dependent D ON E.SSN = D.ESSN;
