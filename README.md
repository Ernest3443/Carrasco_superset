# Carrasco_superset
Dataset for ADSB-X planes tracked:

WITH LatestTimestamp AS (
    SELECT
        MAX(time_request) AS largest_time
    FROM
        adsbx
   
)
SELECT
    COUNT(*) AS data_count
FROM
    adsbx t
JOIN
    LatestTimestamp l ON t.time_request = l.largest_time;
    
Dataset for Open Sky planes tracked:

WITH LatestTimestamp AS (
    SELECT
        MAX(time_request) AS largest_time
    FROM
        opensky

)
SELECT
    COUNT(*) AS data_count
FROM
    opensky t
JOIN
    LatestTimestamp l ON t.time_request = l.largest_time;
    
Create view in pgadmin using query and use it as a dataset for Plane Matches:

CREATE VIEW plane_matches AS
WITH LatestTimestamp AS (
    SELECT
        MAX(time_begin) AS largest_time
    FROM
        merge
    
)
SELECT
    COUNT(*) AS data_count
FROM
    merge t
JOIN
    LatestTimestamp l ON t.time_begin = l.largest_time;

    
Create view in pgadmin using query and use it it as a dataset for Anomaly Score:

create view anomaly_score as
WITH LatestTimestamp AS (
    SELECT
        MAX(time_begin) AS largest_time
    FROM
        merge 
 
)
SELECT icao, avg_med_dist_value::float  
FROM merge t
JOIN
    LatestTimestamp l ON t.time_begin = l.largest_time
order by t.avg_med_dist_value desc limit 5

Create a view called overall_most using the query below and use it as the dataset for Overall Most Current Data By Source:

CREATE view overall_most AS
SELECT
    'adsbx' AS system_name,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'adsbx'
GROUP BY system_name

UNION ALL

SELECT
    'opensky' AS system_name,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'opensky'
GROUP BY system_name;

Create a view called data_quality using the query below and use it as a dataset for Data Quality (Success or Error):

CREATE data_quality AS
SELECT
    'Successful Calculations' AS status,
    COUNT(*) AS count
FROM merge
UNION ALL
SELECT
    'Errors' AS status,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets'


Create a view called data_errors using the query below and use it as a dataset for Data Errors By Source:

CREATE VIEW data_errors AS
SELECT
    'adsbx' AS source,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets' and system = 'adsbx'
UNION ALL
SELECT
    'opensky' AS source,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets' and system = 'opensky'



Create view api_delay and use it as dataset for API Call Delay:

CREATE view api_delay AS
SELECT DISTINCT adsbx.time_request AS "time",
    adsbx.time_return - adsbx.time_request AS adsbx,
    opensky.time_return - opensky.time_request AS opensky
   FROM adsbx
     JOIN opensky ON adsbx.time_request = opensky.time_request;



Create a view called age_data and use it as dataset for Age of Data by Source:

CREATE view age_data AS
WITH adsbx_cte AS (
         SELECT adsbx.time_request AS "time",
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (adsbx.time_return - adsbx.time_reported_by_source)) AS adsbx
           FROM adsbx
          GROUP BY adsbx.time_request
        ), opensky_cte AS (
         SELECT opensky.time_request AS "time",
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (opensky.time_return - opensky.time_reported_by_source)) AS opensky
           FROM opensky
          GROUP BY opensky.time_request
        )
 SELECT adsbx_cte."time",
    adsbx_cte.adsbx,
    opensky_cte.opensky
   FROM adsbx_cte
     JOIN opensky_cte ON adsbx_cte."time" = opensky_cte."time";


Dataset for Plane geographic:

WITH LatestTimestampAdsBX AS (
    SELECT
        MAX(time_return) AS largest_time
    FROM
        adsbx
),
LatestTimestampOpenSky AS (
    SELECT
        MAX(time_return) AS largest_time
    FROM
        opensky

)
SELECT
    t.icao,
    l_adsbx.largest_time,
    t.lat,
    t.lon,
    t.track,
    'adsbx' as source
FROM
    adsbx t
JOIN
    LatestTimestampAdsBX l_adsbx ON t.time_return = l_adsbx.largest_time

UNION ALL

SELECT
    t.icao,
    l_opensky.largest_time,
    t.lat,
    t.lon,
    t.track,
    'opensky' as source
FROM
    opensky t
JOIN
    LatestTimestampOpenSky l_opensky ON t.time_return = l_opensky.largest_time;

Dataset for selected plane:

SELECT *
FROM adsbx
WHERE 
  $__timeFilter(TIMESTAMP 'epoch' + time_return * INTERVAL '1 second')
AND 
CASE 
  WHEN ('$icao' <> '') THEN (icao = '$icao')
  ELSE 1 = 1           
END;

SELECT *
FROM opensky
WHERE 
  $__timeFilter(TIMESTAMP 'epoch' + time_return * INTERVAL '1 second')
AND 
CASE 
  WHEN ('$icao' <> '') THEN (icao = '$icao')
  ELSE 1 = 1           
END;


