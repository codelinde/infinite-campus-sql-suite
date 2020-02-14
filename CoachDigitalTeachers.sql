USE YOURDB

SELECT DISTINCT
    'A' AS 'Action A/U (R)',
    ----School PID----
    CASE
	WHEN vse.schoolID = SCHOOLID1
	THEN PID1
	WHEN vse.schoolID = SCHOOLID2
	THEN PID1
	ELSE '' --Choose default case
    END AS 'School PID (R)',

    LOWER(ISNULL(c.email,'')) AS 'Username (R)',
    'DefaultPassword' AS 'Password (R)',
    i.firstName AS 'First Name',
    ISNULL(LEFT(i.middleName,1),'') AS MI,
    i.lastName AS 'Last Name',
    ISNULL(vse.gradeLevel,'') AS Grade,
    LOWER(ISNULL(c.email,'')) AS 'email address (R)',
    'Active' AS 'Active/Inactive (R)'

FROM individual i
    JOIN EmploymentAssignment ea ON ea.personID = i.personID
    LEFT JOIN Contact c on c.personID = i.personID
    LEFT JOIN v_SchoolEmployment vse ON vse.personID = i.personID
    LEFT JOIN CampusDictionary cd_asgnmt ON cd_asgnmt.attributeID = 463
        AND cd_asgnmt.code = vse.assignmentCode
    JOIN school sch ON sch.schoolID = vse.schoolID
    JOIN District d ON d.districtID = sch.districtID
    JOIN v_DistrictEmployment vde ON vde.personID = i.personID

WHERE i.staffNumber IS NOT NULL
    AND vse.teacher = 1
    AND sch.entityID IS NOT NULL
    AND vse.assignmentEndDate IS NULL
    AND vde.districtEndDate IS NULL
    AND vse.title IS NOT NULL
    --Use this to exclude certain schools: AND sch.entityID NOT IN (NUMBER, NUMBER, NUMBER)

ORDER BY i.lastName, i.firstName
