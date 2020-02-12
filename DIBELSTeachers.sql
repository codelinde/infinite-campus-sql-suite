DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'END YEAR OF SCHOOL YEAR'

USE YOURDB

SELECT DISTINCT
	con.email AS 'Username',
	'DefaultPassword' AS 'Password',
	'Class' AS 'Scope',
	sc.name AS 'School',
	CASE
		WHEN vahs.grade LIKE '01'
		THEN i.lastName + ' 1st Grade'
		WHEN vahs.grade LIKE '02'
		THEN i.lastName + ' 2nd Grade'
		WHEN vahs.grade LIKE '03'
		THEN i.lastName + ' 3rd Grade'
		WHEN vahs.grade LIKE 'KG'
		THEN i.lastName + ' Kindergarten'
	END AS 'Class',
	'Data' as 'Access Level',
	con.email AS 'Email Address'

FROM Course c
	JOIN Calendar ca ON ca.calendarid = c.calendarid AND ca.endYear = @EndYear
	JOIN Section se ON se.courseid = c.courseid
	JOIN Roster r ON r.sectionid = se.sectionid 
	JOIN v_AdHocStudent vahs ON vahs.personid = r.personid and vahs.calendarid = c.calendarid
	JOIN Trial t ON t.trialid = se.trialid  AND t.active = 1 AND t.calendarID = ca.calendarID
	JOIN School sc ON sc.schoolid = ca.schoolid
	JOIN Individual i ON i.personid = se.teacherpersonid
	JOIN SectionPlacement sp ON sp.sectionid = se.sectionid
	JOIN Course ON Course.courseID = se.courseID
	JOIN Term tr ON tr.termid = sp.termid
	JOIN Contact con ON con.personID = i.personID

WHERE
	tr.name LIKE 'TERMNAME'
	AND vahs.endDate IS NULL
	AND vahs.startStatus <> 'E'
	AND vahs.startDate >= @StartDate
	AND vahs.endYear = @EndYear
	AND (vahs.grade Like '%KG%' OR vahs.grade IN('01', '02', '03'))	
	AND ((course.number LIKE 'HOMEROOMCOURSENUMBERAM') OR (course.number LIKE 'HOMEROOMCOURSENUMBERPM'))

ORDER BY [School], [Class], [Username] ASC