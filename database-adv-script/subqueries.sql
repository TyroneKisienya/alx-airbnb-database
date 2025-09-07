--write a query to find all properties where the average rating is greater than 4.0
--using a subquery

SELECT p.property_id, p.name, p.location, p.description
FROM Property p
WHERE > (
    SELECT AVG(r.rating)
    FROM Review r
    WHERE r.property_id = p.property_id
) > 4.0;

--write a corelated subquery to find users who have made more than 3 bookings

SELECT u.user_id, u.first_name, u.last_name, u.phone_number, u.email
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;