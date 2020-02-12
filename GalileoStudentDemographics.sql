USE YOURDB

SELECT DISTINCT 
	i.studentNumber 'Student SIS ID',
    i.Gender,

    CASE 
	    WHEN s.raceethnicityfed = 1 THEN 'H' 
	    WHEN s.raceethnicityfed = 2 THEN 'IA'
        WHEN s.raceethnicityfed = 3 THEN 'A'
        WHEN s.raceethnicityfed = 4 THEN 'B' 
        WHEN s.raceethnicityfed = 5 THEN 'PI'
        WHEN s.raceethnicityfed = 6 THEN 'W'
        WHEN s.raceethnicityfed = 7 THEN 'MR'
    END AS Ethnicity,

    CASE
        WHEN vppf_Gifted.name = 'Gifted'
		THEN 1
        ELSE 0
    END AS 'Gifted',

    CASE
		WHEN vpec.eligibility = 'Free' OR vpec.eligibility = 'Reduced'
		THEN 1
		ELSE 0
	END AS 'FRL',

    CASE   
        WHEN lp.programStatus = 'LEP'
        THEN 1
        ELSE 0
    END AS 'ELL',

    CASE
        WHEN vppf_504.name = '504*'
        THEN 1
        ELSE 0
    END AS '504',

    CASE
        WHEN vlpd.disability1 IS NOT NULL
        THEN 1
        ELSE 0
    END AS 'IEP'

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
    LEFT JOIN v_POSEligibilityCurrent vpec ON vpec.personID = i.personid
    LEFT JOIN Lep lp ON lp.personID = i.personID
    LEFT JOIN v_ProgramParticipationFlags vppf_504 ON vppf_504.personID = i.personid
        AND vppf_504.startDate <= GETDATE()
        AND ((vppf_504.endDate >= GETDATE()) OR (vppf_504.endDate IS NULL))
		AND vppf_504.name = '504*'
    LEFT JOIN v_learningPlanDetail vlpd ON vlpd.personID = i.personid
        AND vlpd.planStartDate <= GETDATE()
        AND ((vlpd.planEndDate >= GETDATE()) OR (vlpd.planEndDate IS NULL))
		AND vlpd.disability1 IS NOT NULL

WHERE e.startStatus <> 'E'
    AND (e.stateExclude = 0 OR e.stateExclude IS NULL)
    AND (e.noShow = 0 OR e.noShow IS NULL)
    AND (e.endDate IS NULL or e.endDate >= GETDATE())
    --Use this to exclude certain grades: AND e.grade <> 'Excluded Grade'