-- 1. Branch ID, name, and the name of the employee who manages it
SELECT B.BranchID, B.Address, E.Name AS ManagerName
FROM Branch B
JOIN Employee E ON B.BranchID = E.BranchID;

-- 2. Branch names and the accounts opened under each
SELECT B.Address AS BranchName, A.AccountNumber
FROM Branch B
JOIN Employee E ON B.BranchID = E.BranchID
JOIN Account A ON E.EmployeeID = A.EmployeeID;

-- 3. Full customer details along with their loans
SELECT C.*, L.LoanID, L.DateIssued, L.Amount
FROM Customer C
JOIN Loan L ON C.CustomerID = L.CustomerID;

-- 4. Loan records where the loan office is in 'Alexandria' or 'Giza'
SELECT L.*
FROM Loan L
JOIN Employee E ON L.EmployeeID = E.EmployeeID
JOIN Branch B ON E.BranchID = B.BranchID
WHERE B.Address IN ('Muscat', 'Sohar');

-- 5. Account data where the type starts with "S" (e.g., Saving)
SELECT *
FROM Account
WHERE Saving IS NOT NULL;

-- 6. Customers with accounts having balances between 20000 and 50000
SELECT DISTINCT C.Name, A.Balance
FROM Customer C
JOIN Account A ON C.CustomerID = A.CustomerID
WHERE A.Balance BETWEEN 2000 AND 50000;

-- 7. Customer names who borrowed more than 100,000 from 'Cairo Main Branch'
SELECT C.Name, L.Amount
FROM Loan L
JOIN Customer C ON L.CustomerID = C.CustomerID
JOIN Employee E ON L.EmployeeID = E.EmployeeID
JOIN Branch B ON E.BranchID = B.BranchID
WHERE L.Amount > 1000 AND B.Address = 'Nizwa';

-- 8. Customers assisted by employee "Amira Khaled"
SELECT C.Name
FROM Assists A
JOIN Customer C ON A.CustomerID = C.CustomerID
JOIN Employee E ON A.EmployeeID = E.EmployeeID
WHERE E.Name = 'Salim Al-Maskari';

-- 9. Customer names and the accounts they hold, sorted by account type
SELECT C.Name, A.AccountNumber
FROM Customer C
JOIN Account A ON C.CustomerID = A.CustomerID
ORDER BY A.Saving DESC, A.Checking DESC;

-- 10. Loans issued in Cairo: loan ID, customer, employee, branch
SELECT L.LoanID, C.Name AS CustomerName, E.Name AS EmployeeName, B.Address AS BranchName
FROM Loan L
JOIN Customer C ON L.CustomerID = C.CustomerID
JOIN Employee E ON L.EmployeeID = E.EmployeeID
JOIN Branch B ON E.BranchID = B.BranchID
WHERE B.Address LIKE '%Sohar%';

-- 11. All employees who manage any branch
SELECT DISTINCT E.*
FROM Employee E
JOIN Branch B ON E.BranchID = B.BranchID;

-- 12. All customers and their transactions, even if some customers have no transactions
SELECT C.Name, T.TransactionID, T.Amount, T.Date
FROM Customer C
LEFT JOIN Account A ON C.CustomerID = A.CustomerID
LEFT JOIN Transactions T ON A.AccountNumber = T.AccountNumber;
