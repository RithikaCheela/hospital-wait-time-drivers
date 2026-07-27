-- SQLite
-- Table names:
--  Timely_and_Effective_Care
--  Hospital_General_Information
--  HCAHPS

PRAGMA table_info(Timely_and_Effective_Care);
PRAGMA table_info(Hospital_General_Information);
PRAGMA table_info(HCAHPS);

SELECT Facility ID, State, Measure ID, Measure Name, Score, Start Date, End Date
FROM Timely_and_Effective_Care 
LIMIT 10;