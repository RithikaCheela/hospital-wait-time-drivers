-- SQLite
-- Table names:
--  Timely_and_Effective_Care
--  Hospital_General_Information
--  HCAHPS

--PRAGMA table_info(Timely_and_Effective_Care);
--PRAGMA table_info(Hospital_General_Information);
--PRAGMA table_info(HCAHPS);

--1) Timely and Effective Care
SELECT Facility_ID, Facility_Name, State, Measure_ID, Measure_Name, Score, Start_Date, End_Date FROM Timely_and_Effective_Care LIMIT 10;

-- time&effective care: OP(OutPatient) measures . different time measures
-- OP_18a: all patients, overall ED time, OP_18b: discharged patients, excluding psych/transfer (this is often the "headline" ED wait measure CMS reports publicly), 
-- OP_18d: time before transfer to another facility, and OP_22: left before being seen
-- 30 distinct meansures

--2) Hospital General Information
---SELECT Facility_ID, Facility_Name, State, Hospital_Type, Hospital_Ownership, Emergency_Services, "Hospital overall rating" FROM Hospital_General_Information LIMIT 10; 

-- gen info: emergency services for emergency department wait times. ownership can be confouder for wait times and satisfaction. overall ratin: also be used to understand correlation

--3) HCAHPS
SELECT Facility_ID, Facility_Name, State, HCAHPS_Measure_ID, HCAHPS_Question, HCAHPS_Answer_Description, "Patient Survey Star Rating", "HCAHPS Linear Mean Value"
FROM HCAHPS
LIMIT 10;

-- HCAHPS dataset has most of the patient satisfaction of the hospital, so star rating and recommendation in the Question column. 
-- so hcahps can be used to see if there is a correlation between patient satisfaction and hospital wait times. 
-- can also add in the nurse/doctor communication, cleanliness.... to see if any can have a small correlation with wait times.

SELECT DISTINCT HCAHPS_Measure_ID, HCAHPS_Question
FROM HCAHPS
LIMIT 10;

-- want to keep, nurse comm: H_COMP_1_LINEAR_SCORE, H_COMP_1_STAR_RATING
-- doctor comm: H_COMP_2_LINEAR_SCORE, H_COMP_2_STAR_RATING
-- overall hospital: H_HSP_RATING_LINEAR_SCORE, H_HSP_RATING_STAR_RATING
-- recommend hispital: H_RECMND_LINEAR_SCORE, H_RECMND_STAR_RATING
-- do i want summary star rating: H_STAR_RATING

---- Reformatting HCAHPS table
-----------
-- Changing not avaliable & not applicable to null values
UPDATE HCAHPS
SET "HCAHPS Linear Mean Value" = NULL
WHERE "HCAHPS Linear Mean Value" IN ('Not Available', 'Not Applicable');

UPDATE HCAHPS
SET "Patient Survey Star Rating" = NULL
WHERE "Patient Survey Star Rating" IN ('Not Available', 'Not Applicable');
-----------

-- Creating wide table for survey ratings and scores, while converting text numbers to real numbers
DROP TABLE IF EXISTS Survey_rating_table;
CREATE TABLE Survey_rating_table AS 
SELECT Facility_ID, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_1_LINEAR_SCORE' THEN CAST ("HCAHPS Linear Mean Value" AS REAL) END) AS Nurse_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_1_STAR_RATING' THEN CAST ("Patient Survey Star Rating" AS REAL) END) AS Nurse_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_2_LINEAR_SCORE' THEN CAST ("HCAHPS Linear Mean Value" AS REAL) END) AS Doctor_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_2_STAR_RATING' THEN CAST ("Patient Survey Star Rating" AS REAL) END) AS Doctor_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_HSP_RATING_LINEAR_SCORE' THEN CAST ("HCAHPS Linear Mean Value" AS REAL) END) AS Hospital_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_HSP_RATING_STAR_RATING' THEN CAST ("Patient Survey Star Rating" AS REAL) END) AS Hospital_Rating,
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_RECMND_LINEAR_SCORE' THEN CAST ("HCAHPS Linear Mean Value" AS REAL) END) AS Recommend_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_RECMND_STAR_RATING' THEN CAST ("Patient Survey Star Rating" AS REAL) END) AS Recommend_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_STAR_RATING' THEN CAST ("Patient Survey Star Rating" AS REAL) END) AS Overall_Rating
FROM HCAHPS
WHERE HCAHPS_Measure_ID IN ('H_COMP_1_LINEAR_SCORE', 'H_COMP_1_STAR_RATING', 'H_COMP_2_LINEAR_SCORE', 'H_COMP_2_STAR_RATING', 'H_HSP_RATING_LINEAR_SCORE', 'H_HSP_RATING_STAR_RATING', 'H_RECMND_LINEAR_SCORE', 'H_RECMND_STAR_RATING', 'H_STAR_RATING')
GROUP BY Facility_ID;

SELECT * FROM Survey_rating_table LIMIT 10;

---- Reformatting the Timely and Effective Care table
SELECT DISTINCT Measure_ID, Measure_Name FROM Timely_and_Effective_Care; 

-----------
-- Changing not avaliable to NULL values: Not Available
-- very high,  high, low, medium are used for unnecessary measures, so wont fix
UPDATE Timely_and_Effective_Care
SET Score = NULL
WHERE Score = 'Not Available';
-----------

-- Creating wide table for outpatient measures, converting text to real numbers
DROP TABLE IF EXISTS Wait_time_table;
CREATE TABLE Wait_time_table AS
SELECT Facility_ID,
   MAX(CASE WHEN Measure_ID = 'OP_18a' THEN CAST(Score AS REAL) END) AS Overall_ED_Wait,
   MAX(CASE WHEN Measure_ID = 'OP_18b' THEN CAST(Score AS REAL) END) AS ED_Wait_Discharged,
   MAX(CASE WHEN Measure_ID = 'OP_18d' THEN CAST(Score AS REAL) END) AS ED_Wait_Transfer,
   MAX(CASE WHEN Measure_ID = 'OP_22' THEN CAST(Score AS REAL) END) AS Left_Before_Seen_Pct
FROM Timely_and_Effective_Care
WHERE Measure_ID IN ('OP_18a', 'OP_18b', 'OP_18d', 'OP_22')
GROUP BY Facility_ID;

SELECT * FROM Wait_time_table LIMIT 10;

SELECT * FROM Timely_and_Effective_Care
WHERE Measure_ID = 'OP_22';