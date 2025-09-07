-- write a query using Inner Join to retrieve all bookings and the respective
-- users who made those bookings

SELECT b.booking_id, b.start_date, b.end_date, b.status, u.first_name, u.last_name, u.email, u.phone_number
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id;

--write a query using LEFT JOIN to retrieve all properties and their reviews,
--including properties that have no listings

SELECT p.property_id, p.name, p.description, p.location, r.review_id, r.rating, r.comment, r.created_at AS review_date
FROM Property p
LEFT JOIN Property p ON p,property_id = r.property_id
ORDER BY p,property_id, r.rating DESC;

--write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user
--has no booking or a booking is not linked to a user

SELECT u.user_id, u.first_name, u.last_name, u.phone_number,b.booking_id, b.status
FROM User u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id
ORDER BY FIELD(status, 'confirmed', 'pending', 'canceled');