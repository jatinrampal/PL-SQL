/*Create a VIEW which includes the customer name and city, the car make and model, the service invoice number and date along with the total value of each invoice.*/
CREATE OR REPLACE VIEW Invoice AS
  SELECT customer.cname
    , customer.ccity
    , car.make
    , car.model
    , servinv.servinv
    , servinv.serdate
    , servinv.totalcost
    FROM customer
      JOIN car
        ON customer.cname = car.cname
      JOIN servinv
        ON car.serial = servinv.serial;


/*How much is the total spending of the customers from Brampton?*/
CREATE OR REPLACE VIEW Brampton_Total AS
  SELECT 'Purchase'
    AS Type
    ,SUM(saleinv.net + saleinv.tax + saleinv.licfee)
    AS Total
  FROM servinv
    JOIN customer
     ON servinv.cname = customer.cname
    JOIN saleinv ON customer.cname = saleinv.cname
  WHERE UPPER(customer.ccity)='BRAMPTON'
  UNION
    SELECT 'Service'
    AS Type
      , SUM(servinv.totalcost)
      AS Total
    FROM servinv
      JOIN customer
       ON servinv.cname = customer.cname
    WHERE UPPER(customer.ccity)='BRAMPTON';



/*How many customers from Toronto have brought their car for service?*/
CREATE OR REPLACE VIEW Toronto_Service AS
  SELECT COUNT(*) AS Total
  FROM servinv
    JOIN customer
     ON servinv.cname = customer.cname
  WHERE UPPER(customer.ccity)='TORONTO';


/*What is the average of the amount spent by customers from Mississauga?*/
CREATE OR REPLACE VIEW Mississauga_Average AS
  SELECT ROUND(AVG(saleinv.totalprice + servinv.totalcost),2) AS Average
  FROM servinv
    JOIN customer
      ON servinv.cname = customer.cname
    JOIN saleinv ON customer.cname = saleinv.cname
  WHERE UPPER(customer.ccity)='MISSISSAUGA';



SELECT * FROM Brampton_Total;


SELECT * FROM Toronto_Service;


SELECT * FROM Mississauga_Average;

