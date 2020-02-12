use YOURDB

DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'END YEAR OF THE SCHOOL YEAR'

SELECT DISTINCT 
	'Federated ID' as 'Identity Type',
    --This is just an example of a possible username format
	LOWER(LEFT(vahs.firstName, 1)) + LOWER(vahs.lastName) + vahs.studentNumber AS 'Username',
	'mydomain.org' AS 'Domain',
    --This is just an example of a possible email format
	LOWER(LEFT(vahs.firstName, 1)) + LOWER(vahs.lastName) + vahs.studentNumber + '@mydomain.org' AS 'Email',
	vahs.firstName as 'First Name',
	vahs.lastName as 'Last Name',
	'US' as 'Country Code',
	'Default Adobe Spark for K-12 - 2 GB configuration' as 'Product Configurations',
	'' as 'Admin Roles',
	'Students' as 'User Groups',
	'' as 'User Groups',
	'' as 'Products Administered',
	'' as 'Developer Access',
	'' as 'Auto Assigned Products'

FROM v_AdHocStudent vahs
JOIN view_students vs on vs.personID = vahs.personID
JOIN School sch ON sch.schoolID = vahs.schoolID

WHERE vahs.activeyear = 1
    AND vahs.activeToday = 1 
    AND vahs.startDate >= CAST(GETDATE() AS DATE)
	AND vahs.studentNumber IS NOT NULL
    -- Use this to exclude certain grades: AND vahs.grade <> 'ExcludedGrade'
    
ORDER BY vahs.lastName ASC