USE YOURDB

--- 504 ---

SELECT
	i.studentNumber AS 'Student ID',
    CASE
        WHEN vppf_504.name = '504*'
        THEN '504'
    END AS 'Program Name'

FROM individual i 
    JOIN student s ON s.personID = i.personID
    JOIN enrollment e ON e.personID = i.personID
		AND e.endYear = (SELECT endyear FROM SchoolYear WHERE active = 1)
    JOIN calendar cal ON cal.calendarID = e.calendarID
    JOIN school sch ON sch.schoolID = cal.schoolID
    LEFT JOIN v_ProgramParticipationFlags vppf_504 ON vppf_504.personID = i.personid
        AND vppf_504.startDate <= GETDATE()
        AND ((vppf_504.endDate >= GETDATE()) OR (vppf_504.endDate IS NULL))
		AND vppf_504.name = '504*'

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    AND e.grade NOT IN ('04','05','06','07','08','PK')
    AND vppf_504.name = '504*'
    --Limit by start date: AND s.startDate > CAST(GETDATE() AS DATE)

UNION

--- Gifted ---

SELECT
	i.studentNumber AS 'Student ID',
    vppf_Gifted.name AS 'Program Name'

FROM individual i 
    JOIN student s ON s.personID = i.personID
    JOIN enrollment e ON e.personID = i.personID
		AND e.endYear = (SELECT endyear FROM SchoolYear WHERE active = 1)
    JOIN calendar cal ON cal.calendarID = e.calendarID
    JOIN school sch ON sch.schoolID = cal.schoolID
    LEFT JOIN v_ProgramParticipationFlags vppf_Gifted ON vppf_Gifted.personID = i.personID
		AND vppf_Gifted.startDate <= GETDATE()
		AND ((vppf_Gifted.endDate >= GETDATE()) OR (vppf_Gifted.endDate IS NULL))
		AND vppf_Gifted.name = 'Gifted'

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    AND e.grade <> 'PK'
    AND e.grade NOT IN ('04','05','06','07','08','PK')
    AND vppf_Gifted.name = 'Gifted'
    --Limit by start date: AND e.startDate >= CAST(GETDATE() AS DATE)

UNION

--- FRL ---

SELECT
	i.studentNumber AS 'Student ID',
    CASE
        WHEN vpec.eligibility = 'Free' OR vpec.eligibility = 'Reduced'
        THEN 'FRL'
    END AS 'Program Name'

FROM individual i 
    JOIN student s ON s.personID = i.personID
    JOIN enrollment e ON e.personID = i.personID
		AND e.endYear = (SELECT endyear FROM SchoolYear WHERE active = 1)
    JOIN calendar cal ON cal.calendarID = e.calendarID
    JOIN school sch ON sch.schoolID = cal.schoolID
    LEFT JOIN v_POSEligibilityCurrent vpec ON vpec.personID = i.personid

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    AND e.grade <> 'PK'
    AND e.grade NOT IN ('04','05','06','07','08','PK')
    AND (vpec.eligibility = 'Free' OR vpec.eligibility = 'Reduced')
    --Limit by start date: AND e.startDate >= CAST(GETDATE() AS DATE)

UNION

--- IEP ---

SELECT
	i.studentNumber AS 'Student ID',
    CASE
        WHEN vlpd.disability1 IS NOT NULL
        THEN 'IEP'
    END AS 'Program Name'

FROM individual i 
    JOIN student s ON s.personID = i.personID
    JOIN enrollment e ON e.personID = i.personID
		AND e.endYear = (SELECT endyear FROM SchoolYear WHERE active = 1)
    JOIN calendar cal ON cal.calendarID = e.calendarID
    JOIN school sch ON sch.schoolID = cal.schoolID
    LEFT JOIN v_learningPlanDetail vlpd ON vlpd.personID = i.personid
        AND vlpd.planStartDate <= GETDATE()
        AND ((vlpd.planEndDate >= GETDATE()) OR (vlpd.planEndDate IS NULL))
		AND vlpd.disability1 IS NOT NULL

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    AND e.grade <> 'PK'
    AND e.grade NOT IN ('04','05','06','07','08','PK')
    AND vlpd.disability1 IS NOT NULL
    --Limit by start date: AND e.startDate >= CAST(GETDATE() AS DATE)

UNION

--- ELL ---

SELECT
	i.studentNumber AS 'Student ID',
    CASE
        WHEN lp.programStatus = 'LEP' THEN 'ELL'
    END AS 'Program Name'

FROM individual i 
    JOIN student s ON s.personID = i.personID
    JOIN enrollment e ON e.personID = i.personID
		AND e.endYear = (SELECT endyear FROM SchoolYear WHERE active = 1)
    JOIN calendar cal ON cal.calendarID = e.calendarID
    JOIN school sch ON sch.schoolID = cal.schoolID
    LEFT JOIN Lep lp ON lp.personID = i.personID

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    AND e.grade <> 'PK'
    AND e.grade NOT IN ('04','05','06','07','08','PK')
    AND lp.programStatus = 'LEP'
    --Limit by start date: AND e.startDate >= CAST(GETDATE() AS DATE)