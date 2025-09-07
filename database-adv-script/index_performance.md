## Identify high-usage columns in your User, Booking, and Property tables (e.g., columns used in WHERE, JOIN, ORDER BY clauses).

#### User Table:

- email (login lookups, UNIQUE constraints)
- role (filtering by user type)
- user_id (JOINs - already PRIMARY KEY)

#### Property Table:

- host_id (finding properties by host)
- location (searching by area)
- pricepernight (price filtering, sorting)
- property_id (JOINs - already PRIMARY KEY)

#### Booking Table:

- user_id (finding user's bookings)
- property_id (finding property bookings)
- start_date, end_date (date range searches)
- status (filtering by booking status)
- created_at (recent bookings, sorting)

# Review Table:

- property_id (finding property reviews)
- user_id (finding user's reviews)
- rating (filtering by rating)
- created_at (recent reviews, sorting)


