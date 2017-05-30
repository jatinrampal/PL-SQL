/*Customer Table */
Create table CUSTOMER
(CNAME CHAR(20) NOT NULL PRIMARY KEY,
CSTREET CHAR(20) NOT NULL,
CCITY CHAR(20) NOT NULL,
CPROV CHAR(20) NOT NULL,
CPOSTAL CHAR(10),
CHPHONE CHAR(13),
CBPHONE CHAR(13));

/*Options Table */
Create table OPTIONS
(OCODE CHAR(4) NOT NULL PRIMARY KEY,
ODESC CHAR(30),
OLIST NUMERIC(7,2),
OCOST NUMERIC(7,2));

/*Employee Table */
Create table EMPLOYEE
(EMPNAME CHAR(20) NOT NULL PRIMARY KEY,
STARTDATE DATE NOT NULL,
MANAGER CHAR(20) REFERENCES EMPLOYEE(EMPNAME),
COMMISSIONRATE NUMERIC(2,0),
TITLE CHAR(26));

/*Car Table */
Create table CAR
(SERIAL CHAR(8) NOT NULL PRIMARY KEY,
CNAME CHAR(20) REFERENCES CUSTOMER(CNAME),
MAKE CHAR(10) NOT NULL,
MODEL CHAR(8) NOT NULL,
CYEAR CHAR(4) NOT NULL,
COLOR CHAR(12) NOT NULL,
TRIM CHAR(16) NOT NULL,
ENGINETYPE CHAR(10) NOT NULL,
PURCHINV CHAR(6),
PURCHDATE DATE,
PURCHFROM CHAR(12),
PURCHCOST NUMERIC(9,2),
FREIGHTCOST NUMERIC(9,2),
TOTALCOST NUMERIC(9,2),
LISTPRICE NUMERIC(9,2));

/*BaseOption Table */
Create table BASEOPTION
(SERIAL CHAR(8) NOT NULL REFERENCES CAR(SERIAL),
OCODE CHAR(4) NOT NULL REFERENCES OPTIONS(OCODE),
CONSTRAINT BASEOPT PRIMARY KEY (SERIAL, OCODE));

/*SaleInv Table*/
Create table SALEINV
(SALEINV CHAR(6) NOT NULL PRIMARY KEY,
CNAME CHAR(20) REFERENCES CUSTOMER(CNAME),
SALESMAN CHAR(20) NOT NULL REFERENCES EMPLOYEE(EMPNAME),
SALEDATE DATE NOT NULL,
SERIAL CHAR(8) NOT NULL REFERENCES CAR(SERIAL),
TOTALPRICE NUMERIC(9,2),
DISCOUNT NUMERIC(8,2) ,
NET NUMERIC(9,2),
TAX NUMERIC(8,2),
LICFEE NUMERIC(6,2),
COMMISSION NUMERIC(8,2),
TRADESERIAL CHAR(8) NOT NULL REFERENCES CAR(SERIAL),
TRADEALLOW NUMERIC(9,2),
FIRE CHAR(1)CHECK (FIRE IN ('Y','N')),
COLLISSION CHAR(1) CHECK (COLLISSION IN ('Y','N')),
LIABILITY CHAR(1)CHECK (LIABILITY IN ('Y','N')),
PROPERTY CHAR(1)CHECK (PROPERTY IN ('Y','N')));

/*InvOption Table */
Create table INVOPTION
(SALEINV CHAR(6) NOT NULL REFERENCES SALEINV(SALEINV),
OCODE CHAR(4) NOT NULL REFERENCES OPTIONS(OCODE),
SALEPRICE NUMERIC(7,2) NOT NULL ,
UNIQUE (SALEINV, OCODE));

/*ServInv Table */
Create table SERVINV
(SERVINV CHAR(5) NOT NULL PRIMARY KEY,
SERDATE DATE NOT NULL,
CNAME CHAR(20) NOT NULL REFERENCES CUSTOMER(CNAME),
SERIAL CHAR(8) NOT NULL REFERENCES CAR(SERIAL),
PARTSCOST NUMERIC(7,2),
LABORCOST NUMERIC(7,2),
TAX NUMERIC(6,2),
TOTALCOST NUMERIC(8,2));

/*ServWork Table */
Create table SERVWORK
(SERVINV CHAR(5) NOT NULL REFERENCES SERVINV(SERVINV),
WORKDESC CHAR(80) NOT NULL,
CONSTRAINT SERVWORK PRIMARY KEY (SERVINV, WORKDESC));

/*Prospect Table */
Create table PROSPECT
(CNAME CHAR(20) NOT NULL REFERENCES CUSTOMER(CNAME),
MAKE CHAR(10) NOT NULL,
MODEL CHAR(8) REFERENCES CUSTOMER(CNAME),
CYEAR CHAR(4) REFERENCES CAR(SERIAL),
COLOR CHAR(12),
TRIM CHAR(16),
OCODE CHAR(4) NOT NULL REFERENCES OPTIONS(OCODE),
UNIQUE(CNAME, MAKE, MODEL, CYEAR, COLOR, TRIM, OCODE));