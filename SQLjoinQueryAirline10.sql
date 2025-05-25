-- 1. Flight leg's ID, schedule, and airplane assigned
SELECT L.leg_no, L.date, A.airplane_id
FROM LEG_INSTANCE L
JOIN AIRPLANE A ON L.airplane_id = A.airplane_id;

-- 2. Flight numbers and departure/arrival airport names
SELECT FL.numberOfFlight, A.name AS DepartureAirport
FROM FLIGHT_LEG FL
JOIN AIRPORT A ON FL.Airport_code = A.Airport_code;

-- 3. Reservation data with customer name and phone
SELECT seat_no, date, Customer_name, cphone
FROM SEAT;

-- 4. IDs and locations of flights departing from 'CAI' or 'DXB'
SELECT numberOfFlight, Airport_code
FROM FLIGHT_LEG
WHERE Airport_code IN ('MCT', 'SUR');

-- 5. Full data of flights whose airline name starts with 'A'
SELECT *
FROM FLIGHT
WHERE airline LIKE 'S%';

-- 6. Customers with total booking payments between 3000 and 5000(EMPTY)
SELECT S.Customer_name, SUM(F.amount) AS TotalPayment
FROM SEAT S
JOIN FARES F ON S.numberOfFlight = F.numberOfFlight
GROUP BY S.Customer_name
HAVING SUM(F.amount) BETWEEN 3000 AND 5000;


-- 8. Passengers whose booking was handled by agent "Youssef Hamed"
-- Cannot be answered: schema has no agent/booking handler info

-- 9. Passenger names and flights they booked, ordered by flight date
SELECT S.Customer_name, S.numberOfFlight, L.date
FROM SEAT S
JOIN LEG_INSTANCE L 
  ON S.numberOfFlight = L.numberOfFlight AND S.leg_no = L.leg_no
ORDER BY L.date;

-- 10. Flights departing from 'Cairo': number, departure time, airline
SELECT F.numberOfFlight, A.dep_time, F.airline
FROM FLIGHT F
JOIN FLIGHT_LEG FLG ON F.numberOfFlight = FLG.numberOfFlight
JOIN AIRPORT A ON FLG.Airport_code = A.Airport_code
WHERE A.city = 'Muscat';

-- 11. Staff assigned as supervisors for flights
-- Cannot be answered: schema has no staff or supervisor relationship

-- 12. All bookings and related passengers, even if unpaid
SELECT S.*, F.amount
FROM SEAT S
LEFT JOIN FARES F ON S.numberOfFlight = F.numberOfFlight;
