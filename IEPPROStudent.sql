USE YOURDB

DECLARE @StartDate date = 'FIRST DAY OF SCHOOL'
DECLARE @EndYear int = 'ENDING YEAR OF SCHOOL YEAR'

SELECT DISTINCT
	vahs.edFiID 'StateIDNumber',
	vahs.studentNumber 'SISIDNumber',

	-----SchoolCode-----
	CASE
		--School 1--
		WHEN
			sch.schoolID = ID1
		THEN
			RIGHT('000'+CAST(ID1 AS VARCHAR(3)),3)
		--School 2--
		WHEN
			sch.schoolID = ID2
		THEN
			RIGHT('000'+CAST(ID2 AS VARCHAR(3)),3)
		ELSE RIGHT('000'+CAST(sch.schoolID AS VARCHAR(3)),3)
	END AS 'SchoolCode',
	-------------------

	vahs.LastName,
	vahs.FirstName,
	ISNULL(vahs.middleName,'') AS 'MiddleName' ,
	CONVERT(varchar,vahs.birthdate,101) AS 'DOB',
	vahs.gender AS Gender,

    --All race/ethnicity columns--
    ------------------------------
	--Hispanic--
	CASE
		WHEN vahs.raceEthnicityFed = 1 THEN 1
		ELSE 0
	END AS 'Ethnicity_HI',
	--American Indian--
	CASE
		WHEN vahs.raceEthnicityFed = 2 THEN 1
		ELSE 0
	END AS 'Ethnicity_AM',
	--Asian--
	CASE
		WHEN vahs.raceEthnicityFed = 3 THEN 1
		ELSE 0
	END AS 'Ethnicity_AS',
	--Black--
		CASE
		WHEN vahs.raceEthnicityFed = 4 THEN 1
		ELSE 0
	END AS 'Ethnicity_BL',
	--Pacific Islander--
	CASE
		WHEN vahs.raceEthnicityFed = 5 THEN 1
		ELSE 0
	END AS 'Ethnicity_PI',
	--White--
	CASE
		WHEN vahs.raceEthnicityFed = 6 THEN 1
		ELSE 0
	END AS 'Ethnicity_WH',
    ------------------------------
    ------------------------------

	--Grade--
	SUBSTRING(vahs.Grade, PATINDEX('%[^0]%', vahs.Grade+'.'), LEN(vahs.Grade)) AS 'Grade',
	
	----Student Address --
	vccs.addressLine1 AS 'StudentAddress1',
	vccs.addressLine2 AS 'StudentAddress2',
	vccs.addressLine1 + vccs.addressLine2 AS 'StudentPhysAddress',

	--Student Phone--
	COALESCE((SELECT home_phone FROM view_students WHERE view_students.personID = vahs.personID ORDER BY home_phone OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY),'') AS 'StudentPhone',

	--Student Email--
    --This is just an example format so please use your own--
	LOWER(LEFT(vahs.firstName,1)) + LOWER(vahs.lastName) + '@mydomain.org' AS 'StudentEMail',

	--Parent 1 Details--
	vccs.firstName + ' ' + vccs.LastName AS 'Parent1Name',
	vccs.addressLine1 AS 'Parent1Address1',
	ISNULL(vccs.addressLine2,'') AS 'Parent1Address2',
	ISNULL(vccs.homePhone,'') AS 'Parent1HomePhone',
	ISNULL(vccs.workPhone,'') AS 'Parent1WorkPhone',
	ISNULL(vccs.cellPhone,'') AS 'Parent1CellPhone',
	vccs.relationship AS 'Parent1Relationship',
	ISNULL(vccs.email,'') AS 'Parent1Email',

	--Parent 2 Details--
	ISNULL(vccs2.firstName + ' ' + vccs2.LastName,'') AS 'Parent2Name',
	ISNULL(vccs2.addressLine1,'') AS 'Parent2Address1',
	ISNULL(vccs2.addressLine2,'') AS 'Parent2Address2',
	ISNULL(vccs2.homePhone,'') AS 'Parent2HomePhone',
	ISNULL(vccs2.workPhone,'') AS 'Parent2WorkPhone',
	ISNULL(vccs2.cellPhone,'') AS 'Parent2CellPhone',
	ISNULL(vccs2.relationship,'') AS 'Parent2Relationship',
	ISNULL(vccs2.email,'') AS 'Parent2Email',

	cs.value 'PrimaryLanguage',
	cd.name 'HomeLanguage',
	DISTRICT NUMBER AS 'DOR',
	'DISTRICT CODE' AS 'DOA',
	'' AS 'HomeSchool',

	sch.name AS 'AttendingSchool',

	vccsE.firstName + ' ' + vccsE.lastName AS 'EmergencyContact',
	ISNULL(vccsE.cellPhone,'') AS 'EmergencyContactPhone',

	--VisionTestDate--
	CASE
		WHEN
			CONVERT(varchar,COALESCE((SELECT MAX(visionDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),''),101) = '01/01/1900'
		THEN ''
		ELSE
			CONVERT(varchar,COALESCE((SELECT MAX(visionDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),''),101)
	END AS 'VisionTestDate',

	--HearingTestDate--
	CASE
		WHEN
			CONVERT(varchar,COALESCE((SELECT MAX(hearingDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),''),101) = '01/01/1900'
		THEN ''
		ELSE
			CONVERT(varchar,COALESCE((SELECT MAX(hearingDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),''),101)
	END AS 'HearingTestDate',

	--Not currently supported--
	'' AS 'PrimaryLangTestDate',

	--VisionTestResults--
	CASE
		WHEN
			COALESCE((SELECT TOP 1 visionStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.visionDate = COALESCE((SELECT MAX(visionDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'P'
		THEN
			'PAS'
		WHEN
			COALESCE((SELECT TOP 1 visionStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.visionDate = COALESCE((SELECT MAX(visionDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'F'
		THEN
			'F/R'
		WHEN
			COALESCE((SELECT TOP 1 visionStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.visionDate = COALESCE((SELECT MAX(visionDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'R'
		THEN 'REF'
		ELSE 'OTH'
	END AS 'VisionTestResults',
	
	--HearingTestResults--
	CASE
		WHEN
			COALESCE((SELECT TOP 1 hearingStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.hearingDate = COALESCE((SELECT MAX(hearingDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'P'
		THEN
			'PAS'
		WHEN
			COALESCE((SELECT TOP 1 hearingStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.hearingDate = COALESCE((SELECT MAX(hearingDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'F'
		THEN
			'F/R'
		WHEN
			COALESCE((SELECT TOP 1 hearingStatus FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID AND v_HealthScreeningDetail.hearingDate = COALESCE((SELECT MAX(hearingDate) FROM v_HealthScreeningDetail WHERE v_HealthScreeningDetail.personID = vahs.personID),'')),'') = 'R'
		THEN 'REF'
		ELSE 'OTH'
	END AS 'HearingTestResults',
	
	--Not currently supported--
	---------------------------
	'' AS 'PrimaryLangTestResults',
	'' AS 'AZELLATestDate',
	'' AS 'AZELLATestResults',

	CASE
		WHEN vppf.name = '504*' 
            AND (vppf.enddate IS NULL OR vppf.enddate >= GETDATE())
        THEN 1
		ELSE 0
	END AS 'Student_504'

FROM v_AdHocStudent vahs

JOIN School sch ON vahs.schoolID = sch.schoolID
LEFT JOIN campusDictionary cd ON cd.code = vahs.homePrimaryLanguage
JOIN campusAttribute caa ON caa.attributeID = cd.attributeID
	AND object ='definition'
	AND element ='iso639-2Language'
LEFT JOIN v_LearningPlanDetail vlpd ON vlpd.personID = vahs.personID
LEFT JOIN v_ProgramParticipationFlags vppf ON vppf.personID = vahs.personID
JOIN RelatedPair rp ON rp.personID1 = vahs.personID
JOIN view_students vs on vs.personID = vahs.personID
LEFT JOIN v_CensusContactSummary vccs on vccs.personID = vahs.personID --Parent1
	AND vccs.seq = COALESCE((SELECT MIN(seq) FROM RelatedPair WHERE personID1 = vahs.personID),11)
LEFT JOIN v_CensusContactSummary vccs2 ON vccs2.personID = vahs.personID --Parent2
	AND vccs2.seq = COALESCE((SELECT MIN(seq) FROM RelatedPair WHERE seq > (SELECT MIN(seq) FROM RelatedPair WHERE personid1 = vahs.personID) AND personID1 = vahs.personID),22)
LEFT JOIN v_CensusContactSummary vccsE ON vccsE.personID = vahs.personID --Emergency Contact
	AND vccsE.seq = COALESCE((SELECT MIN(seq) FROM RelatedPair WHERE personID1 = vahs.personID),33)
LEFT JOIN CustomStudent cs ON cs.personID = vahs.personID AND cs.attributeID = 606 --PrimaryLanguage
LEFT JOIN v_HealthScreeningDetail vhsd ON vhsd.personID = vahs.personID

WHERE
	vahs.activeyear = 1
	AND vahs.activeToday = 1 
	--Use this to exclude certain grades: AND vahs.Grade <> 'Excluded Grades'
	AND (
	    (vppf.name = '504*' AND (vppf.endDate IS NULL or vppf.endDate >= @StartDate)) 
	    OR (vlpd.disability1 IS NOT NULL AND (vlpd.planEndDate IS NULL OR vlpd.planEndDate >= @StartDate)) 
	)
    
ORDER BY vahs.lastName