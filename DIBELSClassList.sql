use YOURDB

DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'ENDING YEAR OF SCHOOL YEAR'

SELECT DISTINCT 
	
	sch.name AS 'School',
	vahs.Grade,
	CASE
		WHEN vahs.homeroomTeacher IS NOT NULL
		THEN
			(CASE
				WHEN vahs.grade LIKE '%01%'
				THEN LEFT(vahs.homeroomTeacher, charindex(',',vahs.homeroomTeacher) -1) + ' 1st Grade'
				WHEN vahs.grade LIKE '%02%'
				THEN LEFT(vahs.homeroomTeacher, charindex(',',vahs.homeroomTeacher) -1) + ' 2nd Grade'
				WHEN vahs.grade LIKE '%03%'
				THEN LEFT(vahs.homeroomTeacher, charindex(',',vahs.homeroomTeacher) -1) + ' 3rd Grade'
				WHEN vahs.grade LIKE '%KG%'
				THEN LEFT(vahs.homeroomTeacher, charindex(',',vahs.homeroomTeacher) -1) + ' Kindergarten'
			END)
		ELSE 'NO TEACHER ASSIGNED'
	END AS 'Class'

FROM v_AdHocStudent vahs
JOIN view_students vs on vs.personID = vahs.personID
JOIN School sch ON sch.schoolID = vahs.schoolID

WHERE
	vahs.endDate IS NULL
	AND vahs.startStatus <> 'E'
	AND vahs.startDate >= @StartDate
	AND vahs.endYear = @EndYear
	AND vahs.studentNumber IS NOT NULL
	AND (vahs.grade Like '%KG%' OR vahs.grade IN('01', '02', '03'))
	AND vahs.homeroomTeacher IS NOT NULL
 
ORDER BY [School], [Grade] ASC