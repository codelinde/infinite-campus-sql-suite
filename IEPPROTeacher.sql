DECLARE @StartDate date = 'FIRST DAY OF SCHOOL
DECLARE @EndYear int = 'END YEAR OF THE SCHOOL YEAR'

USE YOURDB

SELECT DISTINCT
	con.email AS 'StaffEMail',
	i.staffNumber AS 'StaffEmpID',
	i.firstname AS 'StaffFName',
	i.lastName AS 'StaffLName',
	vahs.studentnumber AS 'StudentID',
	1 AS 'Active'

FROM Course c
	JOIN Calendar ca ON ca.calendarid = c.calendarid AND ca.endYear = @EndYear
	JOIN Section se ON se.courseid = c.courseid
	JOIN Roster r ON r.sectionid = se.sectionid 
	JOIN v_AdHocStudent vahs ON vahs.personid = r.personid and vahs.calendarid = c.calendarid
	JOIN Trial t ON t.trialid = se.trialid  AND t.active = 1 AND t.calendarID = ca.calendarID
	JOIN School sc ON sc.schoolid = ca.schoolid
	JOIn Individual i ON i.personid = se.teacherpersonid 
	JOIN SectionPlacement sp ON sp.sectionid = se.sectionid
	JOIN Term tr ON tr.termid = sp.termid
	JOIN Contact con ON con.personID = i.personID
	LEFT JOIN v_LearningPlanDetail vlpd ON vlpd.personID = vahs.personID AND vlpd.disability1 IS NOT NULL
    LEFT JOIN v_ProgramParticipationFlags vppf ON vppf.personID = vahs.personID AND vppf.name = '504*'

WHERE
	tr.name LIKE 'TERM NAME HERE'
	AND vahs.activeToday = 1
	AND vahs.activeYear = 1
    --Use this to exclude certain grades: AND vahs.Grade <> 'Excluded Grade'

ORDER BY [StaffEMail], [StaffEmpID]