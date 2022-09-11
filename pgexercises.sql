-- Recursive query

-- Find the upward recommendation chain for member ID 27 
--SOLUTION 1

WITH RECURSIVE recommender AS (
  
  SELECT
  		recommendedby
  FROM
  		cd.members
  WHERE
  		memid = 27
  UNION ALL
  SELECT
  		m.recommendedby
  FROM
  		recommender rc
  INNER JOIN
  		cd.members m
  			ON m.memid = rc.recommendedby 
  
  )
SELECT 
  		rcm.recommendedby AS recommender,
		m.firstname,
		m.surname
FROM
		recommender rcm
INNER JOIN
		cd.members m 
			ON rcm.recommendedby = m.memid


-- Find the downward recommendation chain for member ID 1
--SOLUTION 1

WITH RECURSIVE recommender_chain AS (
  
  SELECT
  		memid
  FROM
  		cd.members 
  WHERE
  		recommendedby = 1
  UNION ALL
  SELECT
  		m.memid
  FROM
  		cd.members m
  INNER JOIN
  		recommender_chain rcc
  			ON m.recommendedby = rcc.memid 
 )
SELECT
 		rcc.memid,
		firstname,
		surname
FROM
		recommender_chain rcc
INNER JOIN
		cd.members m
			ON rcc.memid = m.memid
ORDER BY
		rcc.memid; 

-- Produce a CTE that can return the upward recommendation chain for any member
--SOLUTION 1

WITH RECURSIVE recommender_upward_chain AS (
  SELECT
  		recommendedby,
  		memid
  FROM
  		cd.members 
  UNION ALL
  SELECT
  		m.recommendedby,
  		ruc.memid
  FROM
  		recommender_upward_chain ruc
  INNER JOIN
  		cd.members m 
  			ON m.memid = ruc.recommendedby
   )
SELECT
 		ruc.memid AS member,
		ruc.recommendedby AS recommender,
		m.firstname,
		m.surname
FROM
		recommender_upward_chain ruc
INNER JOIN
		cd.members m
			ON ruc.recommendedby = m.memid
WHERE
  		ruc.memid = 12 OR ruc.memid = 22
ORDER BY
		ruc.memid ASC,
		ruc.recommendedby DESC; 