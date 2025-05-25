-- 1. Library ID, name, and the name of the manager
SELECT L.Library_ID, L.Name AS LibraryName, S.Full_Name AS ManagerName
FROM Library L
JOIN Staff S ON L.Library_ID = S.Library_ID
WHERE S.Position = 'Manager';

-- 2. Library names and the books available in each one
SELECT L.Name AS LibraryName, B.Title
FROM Library L
JOIN Book B ON L.Library_ID = B.Library_ID;

-- 3. All member data along with their loan history
SELECT M.*, L.Loan_ID, L.Book_ID, L.Loan_Date, L.Return_Date, L.Status
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID;

-- 4. Books located in 'Zamalek' or 'Downtown'
SELECT B.*
FROM Book B
JOIN Library L ON B.Library_ID = L.Library_ID
WHERE L.Location IN ('City Center', 'North Ave');

-- 5. Books whose titles start with 'T'
SELECT *
FROM Book
WHERE Title LIKE 'C%';

-- 6. Members who borrowed books priced between 100 and 300 LE
SELECT DISTINCT M.Name
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE B.Price BETWEEN 10 AND 300;

-- 7. Members who borrowed and returned books titled 'The Alchemist'
SELECT DISTINCT M.Name
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE B.Title = 'Data Science' AND L.Return_Date IS NOT NULL;

-- 8. Members assisted by librarian "Sarah Fathy"
-- Not available: No assistance relationship in schema
-- This query can't be answered based on current schema

-- 9. Each member’s name and the books they borrowed, ordered by book title
SELECT M.Name, B.Title
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
ORDER BY B.Title;

-- 10. Books in 'Cairo Branch' with title, library name, manager, and shelf info
SELECT B.Title, L.Name AS LibraryName, S.Full_Name AS ManagerName, B.Shelf_Location
FROM Book B
JOIN Library L ON B.Library_ID = L.Library_ID
JOIN Staff S ON L.Library_ID = S.Library_ID
WHERE L.Name = 'City Center' AND S.Position = 'Manager';

-- 11. All staff members who manage libraries
SELECT *
FROM Staff
WHERE Position = 'Manager';

-- 12. All members and their reviews, even if some didn’t submit any review yet
SELECT M.Name, R.Comments, R.Rating
FROM dbo.Member M
LEFT JOIN dbo.Review R ON M.Member_ID = R.Member_ID;

