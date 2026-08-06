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

SELECT Facility_ID, Facility_Name, State, Hospital_Type, Hospital_Ownership, Emergency_Services, "Hospital overall rating"
FROM Hospital_General_Information
LIMIT 10; 
