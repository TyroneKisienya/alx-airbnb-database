-- write a query using Inner Join to retrieve all bookings and the respective
-- users who made those bookings

select b.booking_id, b.start_date, b.end_date, b.status, u.first_name, u.last_name, u.email, u.phone_number
from Booking
INNER JOIN User  u ON b.user_id = u.user_id