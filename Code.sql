CREATE TABLE VACCINE_T 
(VACCINE_TYPE VARCHAR2(20), 
CONSTRAINT VACCINETYPE_PK PRIMARY KEY (VACCINE_TYPE));

CREATE TABLE PATIENTADDRESS_T 
(POSTAL_CODE NUMBER(5), 
City varchar(30), 
State varchar(40), 
Street varchar(60), 
PRIMARY KEY (POSTAL_CODE));

CREATE TABLE PATIENT_T 
(PATIENT_ID  NUMBER(7) NOT NULL, 
FIRST_NAME  VARCHAR2(25) NOT NULL, 
LAST_NAME  VARCHAR2(25), 
PATIENT_PHONENO NUMBER(11), 
PATIENT_EMAIL  varchar(319), 
PATIENT_AGE  NUMBER(2), 
POSTAL_CODE NUMBER(5), 
VACCINE_TYPE VARCHAR2(20), 
CONSTRAINT PATIENT_PK PRIMARY KEY (PATIENT_ID), 
FOREIGN KEY(POSTAL_CODE) REFERENCES PATIENTADDRESS_T(POSTAL_CODE), 
FOREIGN KEY(VACCINE_TYPE) REFERENCES VACCINE_T(VACCINE_TYPE));

CREATE TABLE CENTER_T 
(CENTER_NAME VARCHAR2(35), 
VACCINE_TYPE VARCHAR2(20), 
CENTER_LOCATION VARCHAR2(40), 
CENTER_WORKING_HRS VARCHAR2(25), 
VACCINE_SCHEDULE DATE DEFAULT SYSDATE, 
CONSTRAINT CENTER_PK PRIMARY KEY (CENTER_NAME), 
FOREIGN KEY (VACCINE_TYPE) REFERENCES VACCINE_T(VACCINE_TYPE));

CREATE TABLE DOCTOR_T 
(DOCTOR_ID NUMBER(7), 
DOCTOR_NAME VARCHAR2(25) NOT NULL, 
CENTER_NAME VARCHAR2(35), 
DOCTOR_SPECIALIZATION VARCHAR2(60), 
WORKING_HRS VARCHAR2(25), 
CONSTRAINT DOCTOR_PK PRIMARY KEY (DOCTOR_ID), 
FOREIGN KEY (CENTER_NAME) REFERENCES CENTER_T(CENTER_NAME));

CREATE TABLE APPOINTMENT_T 
(APPOINTMENT_NO  NUMBER(7) NOT NULL, 
APPOINTMENT_STATUS  VARCHAR2(20), 
CONSTRAINT APPOINTMENT_PK PRIMARY KEY (APPOINTMENT_NO));

CREATE TABLE DOSE_T 
(PATIENT_ID  NUMBER(7), 
APPOINTMENT_NO  NUMBER(7), 
VACCINE_TYPE VARCHAR2(20), 
NUMBER_Of_DOSES  NUMBER(2), 
CONSTRAINT PATIENT_PK3 PRIMARY KEY (PATIENT_ID,VACCINE_TYPE,APPOINTMENT_NO), 
CONSTRAINT PATIENT_FK FOREIGN KEY (PATIENT_ID) REFERENCES PATIENT_T(PATIENT_ID), 
FOREIGN KEY (APPOINTMENT_NO) REFERENCES APPOINTMENT_T(APPOINTMENT_NO), 
FOREIGN KEY (VACCINE_TYPE) REFERENCES VACCINE_T(VACCINE_TYPE));

INSERT INTO VACCINE_T VALUES('PFIZER');

INSERT INTO VACCINE_T VALUES('NOVAVAX');

INSERT INTO VACCINE_T VALUES('MODERNA');

INSERT INTO VACCINE_T VALUES('OXFORD');

INSERT INTO VACCINE_T VALUES('GAMAIEYA');

INSERT INTO PATIENTADDRESS_T VALUES(64537,'JEDDAH','MAKKAH','SETTEN ST');

INSERT INTO PATIENTADDRESS_T VALUES(53425,'JEDDAH','MAKKAH','AL MAKARUNAH ST');

INSERT INTO PATIENTADDRESS_T VALUES(36443,'JEDDAH','MAKKAH','PRINCE MAJID ST');

INSERT INTO PATIENTADDRESS_T VALUES(41255,'JEDDAH','MAKKAH','CORNISHE ST');

INSERT INTO PATIENTADDRESS_T VALUES(34498,'JEDDAH','MAKKAH','PRINCE FAISAL IBN FAHD ST');

INSERT INTO PATIENT_T VALUES(2006526,'WESAL','HAWSAWI','0534614365','XWESAL.5@GMAIL.COM','21',64537,'PFIZER');

INSERT INTO PATIENT_T VALUES(2005534,'RITAJ', 'ALMUTAIRI','0554669664','RITAJ.3@GMAIL.COM','21',53425,'NOVAVAX');

INSERT INTO PATIENT_T VALUES(2005521,'JWANA', 'ALTHUNIYYAN','0554634664','JWANA.9@GMAIL.COM','20',36443,'MODERNA');

INSERT INTO PATIENT_T VALUES(2006522,'DEEMA','ALMSBH','0521914365','DEEMA25@GMAIL.COM','25',41255,'OXFORD');

INSERT INTO PATIENT_T VALUES(2011534,'RAGHAD', 'ALZHRANI','0554662844','RAGHAD.6@gmail.com','21',34498,'GAMAIEYA');

INSERT INTO CENTER_T VALUES('KING ABDULAZIZ UNIVERSITY HOSPITAL','PFIZER','JEDDAH','24 Hours','25-JAN-2022');

INSERT INTO CENTER_T VALUES('SAUDI GERMAN HEALTH','NOVAVAX','JEDDAH','8:00AM to 12:30AM','29-MAY-2022');

INSERT INTO CENTER_T VALUES('KING FAHAD GENRAL HOSPITAL','MODERNA','JEDDAH','24 Hours','9-FEB-2022');

INSERT INTO CENTER_T VALUES('KING ABDULLAH GENRAL HOSPITAL','OXFORD','JEDDAH','1:00PM to 12:30AM','27-JUN-2022');

INSERT INTO CENTER_T VALUES('BUGSHAN HOSPITAL','GAMAIEYA','JEDDAH','24 Hours','1-DEC-2022');

INSERT INTO DOCTOR_T VALUES(4568372,'MOHAMMED','KING ABDULAZIZ UNIVERSITY HOSPITAL','NEUROLOGIST','1:00PM TO 12:30AM');

INSERT INTO DOCTOR_T VALUES(654296,'RUBA','SAUDI GERMAN HEALTH','PEDIATRICIAN','12:00PM TO 6:00PM');

INSERT INTO DOCTOR_T VALUES(8256346,'ALI','KING FAHAD GENRAL HOSPITAL','CARDIOLOGIST','4:00AM TO 11:00AM');

INSERT INTO DOCTOR_T VALUES(8156346,'SAEED','KING ABDULLAH GENRAL HOSPITAL','NUTRITIONIST','4:30PM TO 9:00PM');

INSERT INTO DOCTOR_T VALUES(8456347,'FATIMAH','BUGSHAN HOSPITAL','CARDIOLOGIST','1:30AM TO 6:30AM');

INSERT INTO APPOINTMENT_T VALUES(1452862,'CONFIRMED');

INSERT INTO APPOINTMENT_T VALUES(4328320,'CANCELLED');

INSERT INTO APPOINTMENT_T VALUES(5624973,'DID NOT ATTEND');

INSERT INTO APPOINTMENT_T VALUES(1892862,'UNCONFIRMED');

INSERT INTO APPOINTMENT_T VALUES(1477862,'CONFIRMED');

INSERT INTO DOSE_T VALUES(2006526,1452862,'PFIZER',4);

INSERT INTO DOSE_T VALUES(2005534,4328320,'NOVAVAX',2);

INSERT INTO DOSE_T VALUES(2005521,5624973,'MODERNA',2);

INSERT INTO DOSE_T VALUES(2006522,1892862,'OXFORD',2);

INSERT INTO DOSE_T VALUES(2005534,1477862,'GAMAIEYA',3);

SELECT FIRST_NAME , LAST_NAME , PT.VACCINE_TYPE  
FROM PATIENT_T PT 
WHERE PT.VACCINE_TYPE IN  
(SELECT VACCINE_TYPE FROM VACCINE_T  
WHERE VACCINE_TYPE ='PFIZER');

SELECT DOCTOR_ID , DOCTOR_NAME , CN.CENTER_NAME 
FROM DOCTOR_T DT , CENTER_T CN  
WHERE DT.CENTER_NAME = CN.CENTER_NAME 
ORDER BY DOCTOR_ID;

SELECT CITY , COUNT(CITY) AS "NUMBER OF CENTERS" 
FROM PATIENTADDRESS_T  
GROUP BY CITY;

SELECT CENTER_NAME, VACCINE_TYPE, 
CENTER_LOCATION ,CENTER_WORKING_HRS 
FROM CENTER_T  
WHERE VACCINE_TYPE LIKE '%O%';

CREATE OR REPLACE PROCEDURE NUMBEROFDOCTORS (CNAME IN VARCHAR2  )  
IS 
C_NAME VARCHAR2(35); 
DOCTOR_COUNT NUMBER; 
BEGIN 
SELECT COUNT(DOCTOR_ID) INTO DOCTOR_COUNT from DOCTOR_T DT where CENTER_NAME=CNAME; 
    dbms_output.put_line('NUMBERS OF DOCTORS IN THIS CENTER IS: '|| DOCTOR_COUNT); 
     
END NUMBEROFDOCTORS; 
 
exec NUMBEROFDOCTORS('SAUDI GERMAN HEALTH'); 
 
 
 
---------------------UPDATETOATTEND PROCEDURE--------------------- 
---------------------THIS PROCEDURE UPDATES THE STATUS OF AN APPOINTMENT TO CONFIRMED --------------------- 
CREATE OR REPLACE PROCEDURE UPDATETOATTEND (APPOINTMENT_NUM APPOINTMENT_T.APPOINTMENT_NO%Type)   
AS 
 
APP_NO NUMBER(7); 
APP_STATUS VARCHAR2(20); 
 
BEGIN 
SELECT APPOINTMENT_NO , APPOINTMENT_STATUS INTO APP_NO , APP_STATUS 
FROM  APPOINTMENT_T 
WHERE APPOINTMENT_NO = APPOINTMENT_NUM; 
 
Update APPOINTMENT_T 
Set APPOINTMENT_STATUS = 'CONFIRMED' 
Where APPOINTMENT_NO = APPOINTMENT_NUM; 
 
Exception 
WHEN NO_DATA_FOUND THEN 
INSERT INTO APPOINTMENT_T (APPOINTMENT_NO,APPOINTMENT_STATUS) 
Values (App_NO,'CONFIRMED'); 
END UPDATETOATTEND; 
 
EXEC UPDATETOATTEND(4328320); 
 
SELECT * FROM APPOINTMENT_T; 
---------------------END OF PROCEDURES---------------------
/

