/*List all the data in all tables.*/
SELECT *
FROM s13.baseoption;

SELECT *
FROM s13.car;

SELECT *
FROM s13.customer;

SELECT *
FROM s13.employee;

SELECT *
FROM s13.invoption;

SELECT *
FROM s13.options;

SELECT *
FROM s13.prospect;

SELECT *
FROM s13.saleinv;

SELECT *
FROM s13.servinv;

SELECT *
FROM s13.servwork;

/*How many vehicles were sold with some kind of insurance?*/
SELECT COUNT(*)
FROM s13.saleinv
WHERE UPPER(collision) = 'Y'
    OR UPPER(fire) = 'Y'
    OR UPPER(liability) = 'Y';

/*Show all customer information for people interested in blue Jaguars*/
SELECT DISTINCT (s13.customer.cname)
  ,s13.customer.cstreet
  ,s13.customer.ccity
  ,s13.customer.cprov
  ,s13.customer.cpostal
  ,s13.customer.chphone
  ,s13.customer.cbphone
FROM s13.customer
JOIN s13.prospect
  ON s13.customer.cname = s13.prospect.cname
WHERE UPPER(s13.prospect.make)='JAGUAR'
AND UPPER(s13.prospect.color)='BLUE' ;

/*List the names and home phone numbers of customers who purchased Jaguar XJRs and who do not
have a business phone*/
SELECT DISTINCT (s13.customer.cname)
  ,s13.customer.chphone
FROM s13.customer
  JOIN s13.car
    ON s13.customer.cname = s13.car.cname
  JOIN s13.saleinv
    ON s13.customer.cname = s13.saleinv.cname
WHERE UPPER(s13.car.make)='JAGUAR'
  AND  UPPER(s13.car.model)='XJR'
  AND s13.customer.cbphone IS NULL
ORDER BY  s13.customer.cname DESC ;

/*What is the average cost of service visits on 2015 Mercedes*/
SELECT ROUND(AVG(s13.servinv.totalcost),2)
  AS MERCEDES_SERVICE_COST
FROM s13.servinv
  JOIN s13.car
    ON s13.car.serial = s13.servinv.serial
WHERE UPPER(s13.car.make) = 'MERCEDES'
  AND UPPER(s13.car.cyear)='2015';

/*List the name and phone number of all customers who have purchased a car from us but have never
come in for servicing.*/
SELECT customer.cname
  ,customer.chphone
FROM s13.customer
  LEFT JOIN  s13.servinv
    ON customer.cname = servinv.cname
WHERE customer.cname
      NOT IN (SELECT
                customer.cname
              FROM s13.customer
                RIGHT JOIN  s13.servinv
                  ON customer.cname = servinv.cname);

/*Print the mailing label formatted name, full address, car make and model of the person who
purchased the most expensive car from us*/
SELECT customer.cname
  ,(customer.cstreet
  || customer.ccity
  ||customer.cprov
  ||customer.cpostal) AS Address
  ,car.make
  ,car.model
FROM s13.customer
  JOIN s13.car
    ON customer.cname = car.cname
  JOIN s13.saleinv
    ON car.serial = saleinv.serial
WHERE totalprice =
      (SELECT MAX(totalprice)
       FROM s13.saleinv);

/*Print the total number and average dollar value of service visits for each of Land Rovers, Mercedes and
Jaguars sold between February 2013 and January 2017 inclusive */
SELECT car.make,COUNT(*)
  ,ROUND(AVG(servinv.totalcost),2)
FROM s13.servinv
  JOIN s13.car
    ON servinv.serial = car.serial
WHERE REPLACE(TRIM(UPPER(car.make)),' ','')
      IN ('LANDROVER','MERCEDES','JAGUAR')
      AND serdate
      BETWEEN '2013-02-01'
      AND '2017-01-31'
GROUP BY make ;

/*Print a list of salespersons names who have sold less than 3 cars*/
SELECT salesman
  ,COUNT(*)
FROM s13.saleinv
GROUP BY salesman
HAVING COUNT(*)<3;

/*List the names of all customers who purchased cars with sunroofs*/
SELECT customer.cname
FROM s13.customer
  JOIN s13.prospect
    ON s13.customer.cname = s13.prospect.cname
  JOIN s13.options
    ON prospect.ocode = options.ocode
WHERE UPPER(odesc) = 'SUN ROOF';

/*List all 2016 cars which are not sold (serial#, make, model). Add (option#, optiondesc, option list price)
if they have options*/
SELECT car.serial
  ,car.make
  ,car.model
  ,options.ocode
  ,options.odesc
  ,options.olist
FROM s13.car
  JOIN s13.baseoption
    ON car.serial = baseoption.serial
  JOIN s13.options
    ON baseoption.ocode = options.ocode
WHERE cyear='2016'
    AND cname IS NULL;

/*Who are the customers living in Brampton who have purchased a car with $1000 or more of extra
options? Include the total amount of the extra options in the output. (Ascending order)*/
SELECT s13.customer.cname
  ,SUM(s13.options.ocost)
FROM s13.customer
  JOIN s13.saleinv
    ON s13.customer.cname = s13.saleinv.cname
  JOIN s13.prospect
    ON s13.customer.cname = s13.prospect.cname
  JOIN s13.options
    ON s13.prospect.ocode = s13.options.ocode
WHERE UPPER(s13.customer.ccity)='BRAMPTON'
GROUP BY s13.customer.cname
HAVING SUM(s13.options.ocost)>1000
ORDER BY SUM(s13.options.ocost);

/*List the name, address and home phone of customers interested in any car which is on the lot unsold.
Match on make, model, year and color. Include the matching criteria in the output.*/
SELECT DISTINCT (s13.customer.cname)
  ,(s13.customer.cstreet
  ||s13.customer.ccity
  ||s13.customer.cprov
  ||s13.customer.cpostal)
  AS ADDRESS
  ,s13.car.make
  ,s13.car.model
  ,s13.car.cyear
  ,s13.car.color
FROM s13.customer
  JOIN s13.prospect
    ON s13.customer.cname = s13.prospect.cname
  JOIN s13.car
    ON s13.car.make = s13.prospect.make
       AND s13.car.model = s13.prospect.model
       AND s13.prospect.cyear = s13.car.cyear
       AND s13.car.color = s13.prospect.color
WHERE s13.car.cname IS NULL;


