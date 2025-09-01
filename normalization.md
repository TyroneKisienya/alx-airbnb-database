# Normalising the AirBnB Database

## Violations and Redundancies captured

### Violation
* **total_price:** This is a transitive dependency. Calculated attributes should not be represented in a schema

* **Solution:**
Remove this entry and calculate dynamically when needed

### Redundacy
* **total_price vs payment_amount**
The two store relatively the same data
