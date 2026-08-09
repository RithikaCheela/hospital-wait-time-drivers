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

SELECT Facility_ID, Facility_Name, State, Hospital_Type, Hospital_Ownership, Emergency_Services, "Hospital overall rating"
FROM Hospital_General_Information
LIMIT 10; 

SELECT Facility_ID, Facility_Name, State, HCAHPS_Measure_ID, HCAHPS_Question, HCAHPS_Answer_Description, "Patient Survey Star Rating", "HCAHPS Linear Mean Value"
FROM HCAHPS
LIMIT 20;

-- HCAHPS dataset has most of the patient satisfaction of the hospital, so star rating and recommendation in the Question column. 
-- so hcahps can be used to see if there is a correlation between patient satisfaction and hospital wait times. 
-- can also add in the nurse/doctor communication, cleanliness.... to see if any can have a small correlation with wait times.