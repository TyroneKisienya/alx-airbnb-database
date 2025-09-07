--write a query to find all properties where the average rating is greater than 4.0
--using a subquery

SELECT property_id, name, rating, location, description
FROM Property
WHERE rating > (
    SELECT AVG(4.0)
    from Property
);