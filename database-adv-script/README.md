# We will talk about advanced SQL Queries with practical examples.
## Let us begin. It will be easy to undestand once you get the time to studu the short I write

### There are a number of joins that help get data you need. It might not be understood practically, but I ask for your brain power a little.

#### Joins are connectors. 
#### Tables are separate notebooks that contain information on something you are working on.

Let us use the project guide. We are having AirBnB Clone project and our aim is to optimise the search, retrival and aggragation of data captured by the AirBnB application.

#### First. How to optimise our database to reduce long load times. 'Joins' come in here.

The notebooks include:

- ##### user table
- ##### booking table
- ##### review table

### How to work it out follows; Practical example is to retrieve how users with their booked listings and perhaps reviews if need be.

## The question - Retrieve all bookings with their respective booking individuals. 

### This query acts like AND in programming. Both sides must meet the criteria in order to be returned. What do I mean. A booking will be returned with a user alongside it. Your name will not be returned in the data that has been pulled by a DBA (Database Administrator) if you have not booked a listing. P.s Any listing not booked will be jumped by this instruction.

- ### give me the booked spaces with the respective occupants.

## The question - Retrieve all properties with or without reviews.

### This query acts like OR in programming. - Either of the criteria should be met in order to satisfy this particular instrution. Very practical. How do we go about it then? This particular query can be used to show the listings that get most frequented, least frequented, need improvement, maitain the form and more. This is for Data analysis and security purposes. PS: The left table is the one left of the equal (=) sign.

## The question - Retrieve all users and all bookings where the status 'canceled', 'pending', 'confirmed'