USE YOURDB

DECLARE @EndYear int = YOUR END YEAR

SELECT DISTINCT
	'SCHOOLYEAR' AS SCHOOLYEAR,
	vsi.sectionID AS CLASSLOCALID,
	vci.courseNumber AS COURSEID, 
	vci.courseName AS COURSENAME,
	ISNULL(vsc.departmentName,'') AS COURSESUBJECT,
	'' AS CLASSNAME,
	ISNULL(vsc.description,'') AS CLASSDESCRIPTION,
	vss.periodStart AS CLASSPERIOD,
	'MDR' AS ORGANIZATIONTYPEID,
	CASE	
		WHEN sch.entityID = YOURSCHOOLID1
		THEN 'HMHID1'
		WHEN sch.entityID = YOURSCHOOLID2
		THEN 'HMHID2'
	END AS 'ORGANIZATIONID',
	vci.grade AS GRADE,
	vss.termStart AS TERMID,
	'TC.HMO.ED' AS HMHAPPLICATIONS

FROM v_CourseInfo vci
JOIN v_SectionInfo vsi on vsi.courseID = vci.courseID
JOIN Trial tr on tr.trialID = vsi.trialID AND tr.calendarID = vci.calendarID
JOIN calendar cal ON cal.calendarID = tr.calendarID AND cal.endYear = @EndYear
JOIN School sch on sch.schoolID = vci.schoolID
JOIN v_SectionSchedule vss on vss.calendarID = vci.calendarID AND vss.sectionID = vsi.sectionID
JOIN v_CourseSection vsc on vsc.sectionID = vsi.sectionID

WHERE 
    vci.courseMasterID IS NOT NULL 
	AND vci.active = 1
	AND tr.active = 1
	--AND vci.courseName NOT LIKE '%keywordtoexcludecourses%' 
	AND vci.endYear = @EndYear
	AND vsc.studentCount > 0

ORDER BY vsi.sectionID