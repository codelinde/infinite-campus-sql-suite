use YOURDB
DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'CONCLUDING YEAR OF SCHOOL YEAR'

SELECT DISTINCT
    'A' AS 'Action A/U (R)',
    ----School PID-----
    CASE
	--School 1--
	WHEN sch.schoolID = SCHOOLID1
	THEN SCHOOLPID1
	--School 2--
	WHEN sch.schoolID = SCHOOLID2
	THEN SCHOOLPID2
    END AS 'School PID (R)',
    ---------------------
    --Example username format
    LOWER(LEFT(vahs.firstName, 1)) + LOWER(vahs.lastName) AS 'Username (R)',
    'DefaultPassword' AS 'Password (R)',
    vahs.firstname AS FirstName,
    ISNULL(LEFT(vahs.middleName,1),'') AS 'MI',
    vahs.lastname AS 'Last Name',
    CASE
	WHEN vahs.Grade LIKE 'KG'
	THEN 'Grade K'
	ELSE 'Grade' + ' ' + SUBSTRING(vahs.Grade, PATINDEX('%[^0]%', vahs.Grade+'.'), LEN(vahs.Grade))
    END AS 'Grade',
    vahs.studentNumber AS 'Student ID',
    --Example email format
    LOWER(LEFT(vahs.firstName, 1) + vahs.lastName + '@mydomain.org') AS 'email address',
    'Active' AS 'Active/Inactive (R)',
    '' AS 'Learning Style'

FROM v_AdHocStudent vahs
    JOIN contact c ON c.personID = vahs.personID
    JOIN view_students vs on vs.personID = vahs.personID
    JOIN School sch ON sch.schoolID = vahs.schoolID

WHERE 
    vahs.endDate IS NULL AND vahs.startStatus <> 'E'
    --You can use this to query for new students on a daily basis: AND vahs.startDate >= CAST(GETDATE() AS DATE)
    AND vahs.endYear = @EndYear
    AND vahs.studentNumber IS NOT NULL

ORDER BY vahs.lastName, vahs.firstName DESC
