-- write a query using Inner Join to retrieve all bookings and the respective
-- users who made those bookings

select booking_id from Booking INNER JOIN User ON user_id = booking_id