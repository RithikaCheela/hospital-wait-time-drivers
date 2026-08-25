-- SQLite
-- Table names:
--  Timely_and_Effective_Care
--  Hospital_General_Information
--  HCAHPS

--PRAGMA table_info(Timely_and_Effective_Care);
--PRAGMA table_info(Hospital_General_Information);
--PRAGMA table_info(HCAHPS);

SELECT Facility_ID, Facility_Name, State, Measure_ID, Measure_Name, Score, Start_Date, End_Date
FROM Timely_and_Effective_Care 
LIMIT 10;

-- time&effective care: OP(OutPatient) measures - 18b, 18c, 20, and 21. different time measures
-- 30 distinct meansures

SELECT Facility_ID, Facility_Name, State, Hospital_Type, Hospital_Ownership, Emergency_Services, "Hospital overall rating"
FROM Hospital_General_Information
LIMIT 10; 

-- gen info: emergency services for emergency department wait times. ownership can be confouder for wait times and satisfaction. overall ratin: also be used to understand correlation

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

-- SELECT * FROM Survey_rating_table LIMIT 10;

DROP TABLE IF EXISTS Survey_rating_table;
CREATE TABLE Survey_rating_table AS 
SELECT Facility_ID, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_1_LINEAR_SCORE' THEN "HCAHPS Linear Mean Value" END) AS Nurse_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_1_STAR_RATING' THEN "Patient Survey Star Rating" END) AS Nurse_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_2_LINEAR_SCORE' THEN "HCAHPS Linear Mean Value" END) AS Doctor_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_COMP_2_STAR_RATING' THEN "Patient Survey Star Rating" END) AS Doctor_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_HSP_RATING_LINEAR_SCORE' THEN "HCAHPS Linear Mean Value" END) AS Hospital_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_HSP_RATING_STAR_RATING' THEN "Patient Survey Star Rating" END) AS Hospital_Rating,
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_RECMND_LINEAR_SCORE' THEN "HCAHPS Linear Mean Value" END) AS Recommend_Score, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_RECMND_STAR_RATING' THEN "Patient Survey Star Rating" END) AS Recommend_Rating, 
   MAX( CASE WHEN HCAHPS_Measure_ID = 'H_STAR_RATING' THEN "Patient Survey Star Rating" END) AS Overall_Rating
FROM HCAHPS
WHERE HCAHPS_Measure_ID IN ('H_COMP_1_LINEAR_SCORE', 'H_COMP_1_STAR_RATING', 'H_COMP_2_LINEAR_SCORE', 'H_COMP_2_STAR_RATING', 'H_HSP_RATING_LINEAR_SCORE', 'H_HSP_RATING_STAR_RATING', 'H_RECMND_LINEAR_SCORE', 'H_RECMND_STAR_RATING')
GROUP BY Facility_ID;
-- need to check if the values are integers or strings