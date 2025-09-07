-- write a query using Inner Join to retrieve all bookings and the respective
-- users who made those bookings

SELECT b.booking_id, b.start_date, b.end_date, b.status, u.first_name, u.last_name, u.email, u.phone_number
FROM Booking
INNER JOIN User  u ON b.user_id = u.user_id

--write a query using LEFT JOIN to retrieve all properties and their reviews,
--including properties that have no listings

SELECT p.property_id, p.name, p.description, p.location, r.review_id, r.rating, r.comment, r.created_at AS review_date
FROM Property p
LEFT JOIN Property p ON p,property_id = r.property_id
ORDER BY p,property_id, r.rating DESC