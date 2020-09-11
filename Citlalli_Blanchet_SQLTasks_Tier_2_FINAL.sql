
Citlalli Blanchet

/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you:
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1.

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface.
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT  `name`
FROM  `Facilities`
WHERE  `membercost` <>0
LIMIT 0 , 30


name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(  `name` ) AS  'number of facilities'
FROM  `Facilities`
WHERE  `membercost` =0
LIMIT 0 , 30

4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT `facid`,`name`,`membercost`,`monthlymaintenance` FROM `Facilities` WHERE `membercost`<.2*`monthlymaintenance`



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM  `Facilities`
WHERE  `facid`
IN ( 1, 5 )
LIMIT 0 , 30


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */


*** DID NOT WORK
SELECT f.name, f.monthlymaintenance,
CASE
WHEN f.monthlymaintenance >=100
THEN  "expensive"
WHEN f.monthlymaintenance <100
THEN  "cheap"
END
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname ,surname, MAX(joindate) AS Last_To_Join
FROM Members




/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */



SELECT DISTINCT(CONCAT(m.firstname,f.name)) AS MemberFac
FROM Members AS m
LEFT JOIN Bookings AS b
ON m.memid=b.memid
LEFT JOIN Facilities AS f
ON b.facid=f.facid
WHERE f.name in  ("Tennis Court 1","Tennis Court 2")
ORDER BY m.firstname


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */




___SELECT surname AS Member, name AS Facility,
CASE
WHEN Members.memid =0
THEN Bookings.slots * Facilities.guestcost
ELSE Bookings.slots * Facilities.membercost
END AS cost
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.starttime >= '2012-09-14'
AND Bookings.starttime < '2012-09-15'
AND ((Members.memid =0
AND Bookings.slots * Facilities.guestcost >30)
OR (Members.memid !=0
AND Bookings.slots * Facilities.membercost >30))
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
??Error #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'WHERE TotCost>30' at line 16


SELECT surname AS Member, name AS Facility,
CASE
WHEN Members.memid =0
THEN Bookings.slots * Facilities.guestcost
ELSE Bookings.slots * Facilities.membercost
END AS cost
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.starttime >= '2012-09-14'
AND Bookings.starttime < '2012-09-15'
AND ((Members.memid =0
AND Bookings.slots * Facilities.guestcost >30)
OR (Members.memid !=0
AND Bookings.slots * Facilities.membercost >30))
ORDER BY cost DESC

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook
for the following questions.

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */



SELECT name, totalrevenue
FROM (
SELECT Facilities.name, SUM(
CASE WHEN memid =0
THEN slots * Facilities.guestcost
ELSE slots * membercost
END ) AS totalrevenue
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
GROUP BY Facilities.name
) AS selected_facilities
WHERE totalrevenue <=1000
ORDER BY totalrevenue


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


SELECT recommendedby,surname,firstname FROM Members ORDER BY surname,firstname



/* Q12: Find the facilities with their usage by member, but not guests */

SELECT f.name,COUNT(m.surname) AS numMember
FROM Bookings AS b
 LEFT JOIN
     Members AS m
     ON b.memid=m.memid
LEFT JOIN
     Facilities AS f
     ON b.facid=f.facid
WHERE m.memid <> 0
GROUP BY f.name;


/* Q13: Find the facilities usage by month, but not guests */

SELECT f.name, COUNT(f.facid) AS NumMembers,month
FROM Facilities AS f
LEFT JOIN (
SELECT b.starttime,strftime('%m',b.starttime) AS month,m.memid,b.facid
FROM Bookings AS b
LEFT JOIN
     Members AS m
     ON b.memid=m.memid
WHERE m.memid <> 0) AS s
ON f.facid=s.facid
ORDER BY f.name,month;

OTHER SOLUTION:

SELECT f.name,COUNT(m.surname) AS numMember,strftime('%m',b.starttime) AS month
FROM Bookings AS b
 LEFT JOIN
     Members AS m
     ON b.memid=m.memid
 LEFT JOIN
     Facilities AS f
     ON b.facid=f.facid
WHERE m.memid <> 0
ORDER BY month;

? Is the solution correct?
