use YOURDB

DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'END YEAR OF THE SCHOOL YEAR'

SELECT DISTINCT
    'YOURCODE' AS 'School State Code',
    sc.name AS 'School Name',
    '' AS 'Previous Instructor ID',
    i.staffNumber AS 'Instructor ID',
    '' AS 'Instructor State ID',
    i.lastName AS 'Instructor Last Name',
    i.firstName AS 'Instructor First Name',
    '' AS 'Instructor Middle Initial',
    con.email AS 'User Name',
    con.email AS 'Email Address',
    (SUBSTRING(vahs.Grade, PATINDEX('%[^0]%', vahs.Grade+'.'), LEN(vahs.Grade))
 +  ' - ' + i.lastName) AS 'Class Name',
    '' AS 'Previous Student ID',
    vahs.studentNumber AS 'Student ID',
    vahs.stateID AS 'Student State ID',
    vahs.lastName AS 'Student Last Name',
    vahs.firstName AS 'Student First Name',
    '' AS 'Student Middle Initial',
    CONVERT(varchar,vahs.birthdate, 1) AS 'Student Date Of Birth',
    vahs.gender AS 'Student Gender',
    CASE
        WHEN vahs.grade = 'K' THEN 'K'
        WHEN vahs.grade = 01 THEN '1'
        WHEN vahs.grade = 02 THEN '2'
        WHEN vahs.grade = 03 THEN '3'
    END AS 'Student Grade',
    CASE 
	    WHEN vahs.raceEthnicityFed = 1 THEN 'Hispanic or Latino' 
        WHEN vahs.raceEthnicityFed = 2 THEN 'American Indian'
        WHEN vahs.raceEthnicityFed = 3 THEN 'Asian'
        WHEN vahs.raceEthnicityFed = 4 THEN 'Black or African American' 
        WHEN vahs.raceEthnicityFed = 5 THEN 'Hawaiian or Other Pacific Islander'
        WHEN vahs.raceEthnicityFed = 6 THEN 'Caucasian'
        WHEN vahs.raceEthnicityFed = 7 THEN 'Two or More Races'
    END AS 'Student Ethnic Group Name',
    '' AS 'Student User Name',
    '' AS 'Student Email'

FROM Course c

JOIN Calendar ca ON ca.calendarid = c.calendarid
    AND ca.endYear = @EndYear
JOIN Section se ON se.courseid = c.courseid
JOIN Roster r ON r.sectionid = se.sectionid 
JOIN v_AdHocStudent vahs ON vahs.personid = r.personid
    AND vahs.calendarid = c.calendarid
JOIN Enrollment e on e.personID = vahs.personID
JOIN Trial t ON t.trialid = se.trialid 
    AND t.active = 1
    AND t.calendarID = ca.calendarID
JOIN School sc ON sc.schoolid = ca.schoolid
JOIn Individual i ON i.personid = se.teacherpersonid 
JOIN SectionPlacement sp ON sp.sectionid = se.sectionid
JOIN Term tr ON tr.termid = sp.termid
JOIN Contact con ON con.personID = i.personID

WHERE
    vahs.grade NOT IN ('04','05','06','07','08','PK')
    AND se.teacherDisplay = vahs.homeroomTeacher