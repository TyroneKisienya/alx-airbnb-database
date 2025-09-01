--seeding the User table

insert into User(user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
('user-1', 'John', 'Doe', 'johndoe@email.com', 'password1', '+1234567890', 'guest'),
('user-2', 'Millie', 'Doe', 'milliedow@email.com', 'password2', '+2134567890', 'admin'),
('user-3', 'Bobby', 'Brown', 'bobbybrown@email.com', 'password3', '+3214567890', 'host');

insert into Property(property_id, host_id, name, description, location, pricepernight) VALUES
('property1', 'host1', 'Cozy', 'Nice 2BR storey building', 'New York, NY, USA', 150.00),
('property2', 'host', 'Warm', 'Nice 1BR Penthouse', 'Barcelona, Spain', 270.00);

insert into Booking(booking_id, property_id, user_id, start_date, end_date,status) VALUES
('booking1', 'property1', 'user-1', '2025-09-01', '2025-09-07', 'confirmed'),
('booking2', 'property2', 'user-3', '2025-09-01', '2025-09-07', 'pending');
